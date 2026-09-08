<div class="publications">
<ol class="bibliography">
{% for link in site.data.publications.main %}
  <li>
    <div class="pub-row">
      <div class="abbr">
        {% if link.image %}
        <img src="{{ link.image | relative_url }}" class="teaser" alt="Preview for {{ link.title }}">
        {% if link.conference_short %}<abbr class="badge">{{ link.conference_short }}</abbr>{% endif %}
        {% endif %}
      </div>
      <div>
        <div class="title"><a href="{{ link.pdf }}">{{ link.title }}</a></div>
        <div class="author">{{ link.authors }}</div>
        <div class="periodical"><em>{{ link.conference }}</em></div>
        <div class="links">
          {% if link.pdf %}<a href="{{ link.pdf }}" target="_blank">PDF</a>{% endif %}
          {% if link.code %}<a href="{{ link.code }}" target="_blank">Code</a>{% endif %}
          {% if link.page %}<a href="{{ link.page }}" target="_blank">Project Page</a>{% endif %}
          {% if link.slides %}<a href="{{ link.slides }}" target="_blank">Slides</a>{% endif %}
          {% if link.bibtex %}<a href="{{ link.bibtex }}" target="_blank">BibTex</a>{% endif %}
          {% if link.notes %}<strong><i style="color:#e74d3c">{{ link.notes }}</i></strong>{% endif %}
          {% if link.others %}{{ link.others }}{% endif %}
        </div>
      </div>
    </div>
  </li>
{% endfor %}
</ol>
</div>
