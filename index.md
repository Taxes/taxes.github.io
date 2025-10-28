---
layout: home
title:  "Hello"
slug: index
---

Hi, I'm Ken. I'm interested in the products and technologies that power commerce. You can read more [about me](/bio.md) or [about what I'm reading](/reading.md).
You can reach me via [email](mailto:ken@knowingken.com).

## Blog

Sometimes I write about things that are interesting to me.

<ul class="post-list">
{% for post in site.posts %}
	{% if post.tags == empty or post.tags.size == 0 %}
		{% include post-list-item.html post=post %}
	{% endif %}
{% endfor %}
</ul>

## Notes on memory

Learning about memory in public.

<ul class="post-list">
{% for post in site.posts reversed %}
	{% if post.tags contains 'memory' %}
		{% include post-list-item.html post=post %}
	{% endif %}
{% endfor %}
</ul>