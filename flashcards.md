---
layout: collection-index
id: flashcards
title: Flashcards
---

{% for deck in site.flashcards -%}
  * [{{ deck.title }}]({{ deck.url }})
{% endfor %}
