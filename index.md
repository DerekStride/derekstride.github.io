---
layout: home
id: home
---

{%- assign entry_limit = 7 -%}

# Hi, I'm Derek.

I'm a developer based in Ottawa, ON, working on storefront performance at [Shopify](https://github.com/shopify/). The most
recent project I'm proud of is [Kinsley](https://github.com/DerekStride/kinsley). You can find the rest of my projects
on [Github](https://github.com/{{- site.data.general.github -}}).

Want to chat? Feel free to [email](mailto:{{- site.data.general.email -}}) me.

## Posts

{% for post in site.posts limit: entry_limit -%}
  [{{ post.title }}]({{ post.url }}) <span class="text text-gray-500">({{ post.date | date: "%Y-%m-%d" }})</span>

  {{ post.excerpt }}
{% endfor %}

[I wrote {{ site.posts.size }} posts](/posts). {% include posts-rss.md %}

## Talks

{% for talk in site.talks limit: entry_limit -%}
  [{{ talk.title }}]({{ talk.url }}) <span class="text text-gray-500">({{ talk.date | date: "%Y-%m-%d" }})</span>

  {{ talk.excerpt }}
{% endfor %}

[I presented {{ site.talks.size }} talks](/talks). {% include talks-rss.md %}

## Bookshelf

{% for book in site.books limit: entry_limit -%}
  [{{ book.title }}]({{ book.url }}) <span class="text text-gray-500">({{ book.date | date: "%Y-%m-%d" }})</span>

  {{ book.excerpt }}
{% endfor %}

[I wrote notes for {{ site.books.size }} books](/books). {% include books-rss.md %}

## Ideas

{% for idea in site.ideas limit: entry_limit -%}
  [{{ idea.title }}]({{ idea.url }}) <span class="text text-gray-500">({{ idea.date | date: "%Y-%m-%d" }})</span>


  {{ idea.excerpt }}
{% endfor %}

[I documented {{ site.ideas.size }} ideas](/ideas).
