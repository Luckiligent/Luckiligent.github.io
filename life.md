---
layout: homepage
title: Life
permalink: /life/
---

{% if site.data.life.albums and site.data.life.albums.size > 0 %}
{% assign sorted_albums = site.data.life.albums | sort: "sort_date" | reverse %}
<div class="life-timeline">
  {% for album in sorted_albums %}
  <article class="life-timeline-entry">
    <div class="life-timeline-date">
      <time datetime="{{ album.date | date: '%Y-%m' }}">{{ album.date }}</time>
      {% if album.location %}<span>{{ album.location }}</span>{% endif %}
    </div>
    <div class="life-timeline-content">
      <div class="life-photo-strip" role="list" aria-label="Photos from {{ album.title | escape }}">
        {% for image in album.images %}
        <button class="life-photo" type="button" role="listitem" data-life-album='{{ album.images | jsonify | escape }}' data-life-title="{{ album.title | escape }}" data-life-index="{{ forloop.index0 }}">
          <img src="{{ image.src | relative_url }}" alt="{{ image.alt | default: album.title | escape }}" loading="lazy">
        </button>
        {% endfor %}
      </div>
    </div>
  </article>
  {% endfor %}
</div>
{% else %}
<p class="life-empty">No moments have been added yet.</p>
{% endif %}

<dialog id="life-gallery-dialog" class="life-dialog" aria-labelledby="life-gallery-title">
  <img id="life-gallery-image" src="" alt="">
  <p id="life-gallery-title" class="life-gallery-title"></p>
  <div class="life-dialog-controls"><div class="life-dialog-navigation"><button class="life-dialog-nav" type="button" data-life-previous aria-label="Previous photo"><span aria-hidden="true">←</span><span>Previous</span></button><span id="life-gallery-count" aria-live="polite"></span><button class="life-dialog-nav" type="button" data-life-next aria-label="Next photo"><span>Next</span><span aria-hidden="true">→</span></button></div><button class="life-dialog-close" type="button" data-life-close aria-label="Close gallery"><span aria-hidden="true">×</span><span>Close</span></button></div>
</dialog>
