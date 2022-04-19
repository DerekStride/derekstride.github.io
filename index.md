---
layout: home
id: home
---

{%- assign entry_limit = 7 -%}

# Hi, I'm Derek.

I'm a software developer based in Ottawa, ON, working on storefront performance at [Shopify](https://www.shopify.ca/).

## Posts

{% for post in site.posts limit: entry_limit -%}
  [{{ post.title }}]({{ post.url }}) <span class="text text-gray-500">({{ post.date | date: "%Y-%m-%d" }})</span>

  {{ post.excerpt }}
{% endfor %}

[I wrote {{ site.posts.size }} posts](/posts). {% include posts-rss.md %}

## Bookshelf

{% for book in site.books limit: entry_limit -%}
  [{{ book.title }}]({{ book.url }}) <span class="text text-gray-500">({{ book.date | date: "%Y-%m-%d" }})</span>

  {{ book.excerpt }}
{% endfor %}

[I wrote notes for {{ site.books.size }} books](/books). {% include books-rss.md %}