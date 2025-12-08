---
layout: talk
title: scaling-shopify
---

I give this talk every year to Carleton University Software Engineering students on scaling software systems using
examples from Shopify's history as it grew from 10's of requests per second to multi-millions requests per seconds.

See the up-to-date slides on [Google Drive](https://docs.google.com/presentation/d/1rILFmRsw4PjZ1mfR6QeTDJRAYhiz65-mGgLWKF1fDS8/edit?usp=sharing).

{%- assign pdfs = site.static_files | where: "pdf", true -%}
{% for static_file in pdfs -%}
  {%- if static_file.basename == "scaling-shopify" -%}
    {%- assign talk = static_file -%}
  {%- endif -%}
{% endfor %}

<object data="{{ talk.path }}" width="1000" height="1000" type='application/pdf'></object>

