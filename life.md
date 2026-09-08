---
layout: homepage
title: Life
permalink: /life/
---

{% if site.data.life.albums and site.data.life.albums.size > 0 %}
<div class="life-grid">
  {% for album in site.data.life.albums %}
  <button class="life-album" type="button" data-life-album='{{ album.images | jsonify | escape }}' data-life-title="{{ album.title | escape }}">
    <img src="{{ album.cover | relative_url }}" alt="{{ album.title | escape }}">
    <span class="life-album-copy"><span class="life-album-title">{{ album.title }}</span><span class="life-album-meta">{{ album.date }}{% if album.location %} · {{ album.location }}{% endif %} · {{ album.images.size }} photos</span></span>
  </button>
  {% endfor %}
</div>
{% else %}
<p class="life-empty">No moments have been added yet.</p>
{% endif %}

<dialog id="life-gallery-dialog" class="life-dialog" aria-labelledby="life-gallery-title">
  <img id="life-gallery-image" src="" alt="">
  <p id="life-gallery-title"></p>
  <div class="life-dialog-controls"><button type="button" data-life-previous>Previous</button><span id="life-gallery-count"></span><button type="button" data-life-next>Next</button><button type="button" data-life-close>Close</button></div>
</dialog>
