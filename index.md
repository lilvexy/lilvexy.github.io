---
layout: home
title: "Hem"
---
<section class="hero">
  <h1>Hello, Welcome to Vexy´s Blog </h1>
  <p>IT-entusiast in Network, systems and security.</p>
</section>

<section class="posts">
  <h2>Latest post</h2>
  {% for post in site.posts %}
    <article class="post-preview">
      <a href="{{ post.url }}">
        <h3>{{ post.title }}</h3>
      </a>
      <p class="meta">{{ post.date | date: "%Y-%m-%d" }}</p>
      <p>{{ post.excerpt }}</p>
    </article>
  {% endfor %}
</section>
