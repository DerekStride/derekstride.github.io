---
layout: collection-index
id: ideas
title: Ideas
---

{% for idea in site.ideas -%}
  [{{ idea.title }}]({{ idea.url }})

  {{ idea.excerpt }}
{% endfor %}
