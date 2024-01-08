# Building a Payments Product: Introduction

Payments are just moving money from one place to another, right? How hard can it be?

This is the introduction for a series covering the fundamentals of standing up a new payments processing product.

I spent a few years as a product manager at a large bank. One of my major projects was launching a new payments product which involved integrating a third party digital wallet provider as a payment partner. The goal was to enable the bank's corporate clients to send money to their customers' digital wallets without each corporate client having to integrate with the digital wallet provider itself. These integrations incur a large start-up cost as well as ongoing administrative overhead - think development costs, contract negotiations, funding arrangements, monitoring, etc. - so a corporate client gets significant value out of being integrated with a relatively small number of banks through which they can reach a relatively large number of payment endpoints.

## Some basic terminology

If corporations paying their customers (or in payments lingo, a B2C or business-to-consumer payment, crucially distinct from a C2B payment flowing in the other direction) is not intuitive, join the club. You, like most consumers, almost certainly act as a payor (a payment sender) several times as frequently as you act as a payee (a payment recipient). A few common examples of a B2C payment flow are:
* Payroll - whether you're an airline pilot or a rideshare driver, your employer need to be able to pay you for work done.
* Refunds - if you return a purchase to a merchant, they need a way to refund your money.
* Insurance claims - if your apartment floods, your insurance provider needs a way to pay out on your insurance claim.

This post is written from the perspective of a bank or payment provider. "Payment" generically refers to a cash flow between two parties in any direction. I'll use the terms outbound payment, disbursement, or payout interchangeably to mean a cash flow from the bank/client to the end customer, while inbound payment, receipt, or pay-in will mean a cash flow from the end customer to the bank/client. It's important to segment based on the direction of the flow because different flows have varying needs and priorities.

## First, understand your customers and market.

Today, there are a number of digital wallet providers in the US. This is a relatively recent development - a few years ago, there were really only two dominant players in the space. To better guide our decision-making around partner selection, it became important to understand what motivates the primary buyers of payment products - usually corporate treasurers or those in a similar role. One of their responsibilities is to find ways to make payouts to customers, with major considerations being (roughly in order of priority): reach, cost, customer experience, and speed.

 If you are building a payments product, you will at almost certainly need to integrate with a partner or network at some stage, and understanding your customers' needs helps provide a framework for evaluating potential partners. (You can disregard the integration-related portions if you are reading this in the year 3000 and the global financial system is run through an all-encompassing hive mind.)

### They want to pay everyone.

The value of reach emerges from a few base considerations: you want to be able to pay all your customers and offer choices and flexibility, but you don't want to implement dozens of payment methods - even though integrating through a central service provider such as a bank means you can pick up an incremental payment method at a significantly lower cost than a DIY integration, there is still cost involved.

You might guess that reach is a simple matter of market share - the more customers, the better reach, but there are some complications. For various reasons, businesses can be much more concerned with ensuring each and every customer has at least one payment option vs. providing many options that overlap. In other words, a business may prefer a payment method that only reaches 2% of its customer base if those customers would otherwise be unserved over a method that has 20% overall consumer penetration that overlaps entirely with populations that are already served. These businesses may be willing to cough up transaction costs that are loss-making at the transaction level, customer level, and possibly even at the customer segment level based on strategic, reputational, or regulatory concerns.

Takeaway: niche payment methods with high costs and low overall adoption might be viable products if they provide access to underserved populations.

### They don't want to spend a lot of money to pay people.

A second priority is costs. I like to think of these in two parts: bank costs and network costs. Bank costs are the typical costs associated with offering a product - technology, implementation, sales, support, etc. Network costs are charged by the organization which runs the payment rail. In the mainstream US banking system, this is either The Clearing House (TCH) or the Federal Reserve. Traditionally, payments between large financial institutions leverage the TCH network because large banks are more likely to be members of the TCH network, but ultimately, both TCH and the Fed's services are nearly identical, and banking products abstract over any remaining differences before they reach a client. Payment products on traditional rails such as checks, ACH, and domestic wires are largely commoditized.

Costs become more interesting and differentiated when examining more esoteric or emerging rails, such as the card networks (with very different implications depending on credit vs. debit), real-time gross settlement systems, digital wallets, and cryptocurrency / distributed ledger money. Without getting too side-tracked, the economics of international wires can also be highly variable as a result of the fascinating complexities of correspondent banking arrangements.

Takeaway: costs, while a priority, are unlikely to be the differentiating factor between competing products on the same payment rail but become more significant when comparing payment rails.

### They want their customers to be happy.

Third is the customer experience. The overwhelming majority of end users neither know nor care about payments systems and technology. They will not appreciate the nuances of settlement, reconciliation, tracking, or dispute resolution processes across the countless stakeholders which might touch a payment. From their perspective, if there is a problem with the payment, there's a problem with the company they're dealing with.

Payment providers and systems can vary significantly across these areas. Traditional rails are highly regulated and therefore tend to have consistent, if bureaucratic, support. Newer rails tend towards a more self-service approach. Large payment providers invest significantly in building experienced operations and support departments to abstract away most of these differences from the customer's perspective, but they are still ultimately constrained by the rules of the rails. (This assumes you're a high-value enterprise customer; the consumer and small business experience can be much more frustrating.)

Takeaway: a bad payments experience, no matter how loosely related to anything a client has control over, reflects poorly on the client nonetheless, while good payments experiences can boost customer loyalty and satisfaction; businesses are willing to pay for movement on the spectrum away from the former towards the latter.

### They have a need for speed.

Last, but not least, is speed. Particularly important in disbursements is the fact that customers want their money, and they want it now. The importance that a client places on speed is dependent on the use cases and customer segments they deal with. Some use cases, such as insurance claims or gig economy payouts, naturally carry a higher sense of urgency due to the end customer's needs. A casual gig worker who is working a shift to buy something today needs their money today; a salaried professional with a financial buffer places a lower value on faster settlement. Furthermore, customer expectations are shifting over time, and as other parts of their lives become faster-paced, they naturally expect faster payments as well. Speed is deliberately broken out from other facets of the customer experience as it has become a major differentiating factor in the way payment products are positioned and marketed, with a significant gap between delayed settlement systems and faster payments schemes.

Takeaway: time is money, and people will spend money so that they can get their money sooner.

### You should abstract away secondary concerns from your customer.

You might notice that accuracy, reliability, and risk (fraud, regulatory, etc.) are not on this list. Those are, with a few exceptions, pretty standard across most disbursement products and don't serve as a differentiator. There are occasions where these deserve to be considered more thoroughly when positioning a new payments product - most prominently among less established and emerging payment rails - but most payment providers have done a relatively good job of abstracting these away from the client experience. Of course, these will be relevant if you're designing a payments product, but that is a topic for another time.

## Integrations are a big investment, so keep the long term in mind.

After evaluating the two major competitors in the digital wallet space, you might find that they are closely matched in terms of costs, customer experience, and speed. Reach becomes the dominating differentiator. As noted earlier, while useful, the total number of people reached by each wallet provider is not necessarily the most important factor in this analysis. If one provider reaches 50% of the US, but your clients' customers aren't in that 50%, then their reach is useless for your needs. Based on analysis of major clients who had expressed interest in a digital wallets solutions, including research and interviews to determine what their focus customer segments were, one provider had significantly better penetration for the specific product use cases and positioning we were targeting.

There are also considerations related to the long-term strategy for the product, such as international opportunities or lateral expansion leveraging the relationship. Selecting a payment rail or partner is often only the first step in a months- or years-long process to launch a product, and it's important to maintain a long-term view of the integration and partnership.

Now that we've built a basic understanding the payments industry and have chosen a partner, it's time to explore product-specific decisions. While this post focused more on the business side, the next section will delve into the various technical decisions and tradeoffs that are instrumental in bringing a payments product from idea to reality. 