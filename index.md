---
layout: default
title: Hem
---

<section class="hero">
  <div class="container">
    <h1>Hello, Welcome to my blog </h1>
    <p class="tagline">
    I will share my learning experiances and projects here
    </p>
  </div>
</section>

<section class="post-list">
  <div class="container">
    <h2>Senaste inläggen</h2>

    {% for post in site.posts %}
      <article class="post-item">
        <!-- Titel -->
        <a href="{{ post.url }}" class="post-link">
          <h3>{{ post.title }}</h3>
        </a>

        <!-- Datum -->
        <div class="post-meta">
          {{ post.date | date: "%d %B %Y" }}
        </div>

        <!-- Taggar -->
        {% if post.tags %}
          <div class="post-tags">
            {% for tag in post.tags %}
              <a class="tag" href="/tags/{{ tag | downcase | replace: ' ', '-' }}/">{{ tag }}</a>
            {% endfor %}
          </div>
        {% endif %}

        <!-- Kort teaser -->
        {% if post.intro %}
          <p class="post-excerpt">{{ post.intro }}</p>
        {% else %}
          <p class="post-excerpt">{{ post.content | strip_html | truncate: 140 }}</p>
        {% endif %}

        <!-- Läs mer-länk -->
        <a href="{{ post.url }}" class="read-more">Läs mer →</a>
      </article>
    {% endfor %}

  </div>
</section>
