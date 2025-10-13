---
layout: home
title:  "Hello"
slug: index
---

Hi, I'm Ken. I'm interested in the products and technologies that power commerce. You can read more [about me](/bio.md) or [about what I'm reading](/reading.md).
You can reach me via [email](mailto:ken@knowingken.com).

## Blog

Sometimes I write about things that are interesting to me.

<ul class="post-list" markdown="1">
{% for post in site.posts %}
	{% if post.tags == empty or post.tags.size == 0 %}
	<li>
		{{ post.date | date: "%Y-%m" }}
		<a href="{{ post.url | relative_url }}">{{ post.title }}</a>
	</li>
	{% endif %}
{% endfor %}
</ul>

## Notes on memory

Learning about memory in public.

<ul class="post-list" markdown="1">
{% for post in site.posts reversed %}
	{% if post.tags contains 'memory' %}
	<li>
		{{ post.date | date: "%Y-%m" }}
		<a href="{{ post.url | relative_url }}">{{ post.title }}</a>
	</li>
	{% endif %}
{% endfor %}
</ul>