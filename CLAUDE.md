# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal website/blog built with Jekyll 4.4 and deployed to GitHub Pages. It uses Tailwind CSS for styling with PostCSS processing.

## Development Commands

**Start local development server:**
```bash
npm run server
```
This runs `bundle exec jekyll serve --watch --drafts` which serves the site at http://localhost:4000 with live reload and draft posts visible.

**Install dependencies:**
```bash
bundle install
npm install
```

## Architecture

### Collections
The site has three content collections defined in `_config.yml`:
- `_posts/` - Blog posts (permalink: `/posts/:title`)
- `_books/` - Book reviews/notes (permalink: `/books/:title`)
- `_talks/` - Conference talks (permalink: `/talks/:title`)

### CSS Pipeline
- Tailwind CSS is processed via `jekyll-postcss` plugin
- Main stylesheet: `assets/css/bundle.css`
- PostCSS plugins: postcss-import, tailwindcss, postcss-nested, autoprefixer, cssnano (production only)
- Tailwind plugins: @tailwindcss/typography, @tailwindcss/aspect-ratio

### Jekyll Plugins
- `jekyll-feed` - RSS feeds for posts, books, and talks
- `jekyll-postcss` - PostCSS/Tailwind integration
- `jekyll-graphviz` - Graphviz diagram rendering

### Layouts
- `default.html` - Base layout with head, nav, and container
- `post.html` - Blog post layout
- `book.html` - Book review layout
- `talk.html` - Talk layout
- `collection-index.html` - Index page for collections
- `home.html` - Homepage layout

### Deployment
Pushes to `master` trigger GitHub Actions workflow that builds the site and deploys to the `gh-pages` branch.
