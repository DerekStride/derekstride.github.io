---
layout: collection-index
id: notes
title: Notes
feed-name: notes
---

{% assign sorted_notes = site.notes | sort: 'priority' | reverse %}
{% for note in sorted_notes -%}
  [{{ note.title }}]({{ note.url }})

  {{ note.excerpt }}
{% endfor %}
