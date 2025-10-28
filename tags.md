---
layout: default
title: Tags
permalink: /tags/
---

# Tags

{% assign sorted_tags = site.tags | sort %}
{% for tag in sorted_tags %}
  {% assign tag_name = tag[0] %}
  {% assign posts = tag[1] %}

## {{ tag_name }}

<ul class="post-list">
{% for post in posts reversed %}
  {% include post-list-item.html post=post %}
{% endfor %}
</ul>

{% endfor %}

{% if site.tags.size == 0 %}
No tagged posts yet.
{% endif %}
