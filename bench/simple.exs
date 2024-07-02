liquid = """
{% comment %} https://github.com/Shopify/liquid/blob/main/performance/tests/vogue/theme.liquid {% endcomment %}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<title>{{ shop.name }} &mdash; {{ page_title }}</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

{{ 'stylesheet.css' | asset_url | stylesheet_tag }}

<!-- Additional colour schemes for this theme. If you want to use them, just replace the above line with one of these
{{ 'caramel.css' | asset_url | stylesheet_tag }}
{{ 'sea.css' | asset_url | stylesheet_tag }}
-->

{{ 'mootools.js'        | global_asset_url  | script_tag }}
{{ 'slimbox.js'         | global_asset_url  | script_tag }}
{{ 'option_selection.js' | shopify_asset_url | script_tag }}

{{ content_for_header }}
</head>

<body id="page-{{ template }}">

<div id="header">
  <div class="container">
    <div id="logo">
      <h1><a href="/" title="{{ shop.name }}">{{ shop.name }}</a></h1>
    </div>
    <div id="navigation">
      <ul id="navigate">
        <li><a href="/cart">View Cart</a></li>
        {% for link in linklists.main-menu.links reversed %}
          <li><a href="{{ link.url }}">{{ link.title }}</a></li>
        {% endfor %}
      </ul>
    </div>
  </div>
</div>

<div id="mini-header">
  <div class="container">
    <div id="shopping-cart">
      <a href="/cart">Your shopping cart contains {{ cart.item_count }} {{ cart.item_count | pluralize: 'item', 'items' }}</a>
    </div>
    <div id="search-box">
      <form action="/search" method="get">
        <input type="text" name="q" id="q" />
        <input type="image" src="{{ 'seek.png' | asset_url }}" value="Seek" onclick="this.parentNode.submit(); return false;" id="seek" />
      </form>
    </div>
  </div>
</div>

<div id="layout">
  <div class="container">
    <div id="layout-left" {% if template != "cart" %}{% if template != "product" %}style="width:619px"{% endif %}{% endif %}>{% if template == "search" %}
      <h1>Search Results</h1>{% endif %}
      {{ content_for_layout }}
    </div>{% if template != "cart" %}{% if template != "product" %}

    <div id="layout-right">
      {% if template == "index" %}
      {% if blogs.news.articles.size > 1 %}
      <a href="{{ shop.url }}/blogs/news.xml"><img src="{{ 'feed.png' | asset_url }}" alt="Subscribe" class="feed" /></a>
      <h3><a href="/blogs/news">More news</a></h3>
      <ul id="blogs">{% for article in blogs.news.articles limit: 6 offset: 1 %}
        <li><a href="{{ article.url }}">{{ article.title | strip_html | truncate: 30 }}</a><br />
          <small>{{ article.content | strip_html | truncatewords: 12 }}</small>
        </li>{% endfor %}
      </ul>
      {% endif %}
      {% endif %}

      {% if template == "collection" %}
      <h3>Collection Tags</h3>
      <div id="tags">{% if collection.tags.size == 0 %}
        No tags found.{% else %}
        <span class="tags">{% for tag in collection.tags %}{% if current_tags contains tag %} {{ tag | highlight_active_tag | link_to_remove_tag: tag }}{% else %} {{ tag | highlight_active_tag | link_to_add_tag: tag }}{% endif %}{% unless forloop.last %}, {% endunless %}{% endfor %}</span>{% endif %}
      </div>
      {% endif %}

      <h3>Navigation</h3>
      <ul id="links">
      {% for link in linklists.main-menu.links %}
        <li><a href="{{ link.url }}">{{ link.title }}</a></li>
      {% endfor %}
      </ul>

      {% if template != "page" %}
      <h3>Featured Products</h3>
      <ul id="featuring">{% for product in collections.frontpage.products limit: 6 %}
        <li class="featuring-list">
          <div class="featuring-image">
            <a href="{{ product.url | within: collections.frontpage }}" title="{{ product.title | escape }} &mdash; {{ product.description | strip_html | truncate: 50 }}"><img src="{{ product.images.first | product_img_url: 'icon' }}" alt="{{ product.title | escape }}" /></a>
          </div>
          <div class="featuring-info">
            <a href="{{ product.url | within: collections.frontpage }}">{{ product.title | strip_html | truncate: 28 }}</a><br />
            <small><span class="light">from</span> {{ product.price | money }}</small>
          </div>
        </li>{% endfor %}
      </ul>
      {% endif %}
    </div>{% endif %}{% endif %}
  </div>
</div>

<div id="footer">
  <div id="footer-fader">
    <div class="container">
      <div id="footer-right">{% for link in linklists.footer.links %}
        {{ link.title | link_to: link.url }} {% unless forloop.last %}&#124;{% endunless %}{% endfor %}
      </div>
      <span id="footer-left">
        Copyright &copy; {{ "now" | date: "%Y" }} <a href="/">{{ shop.name }}</a>. All Rights Reserved. All prices {{ shop.currency }}.<br />
        This website is powered by <a href="http://www.shopify.com">Shopify</a>.
      </span>
    </div>
  </div>
</div>

</body>
</html>
"""
Benchee.run(
  %{
    "parse" => fn -> {:ok, _} = Solid.parse(liquid) end,
  }
)
