# AGENTS.md

This file provides guidance to Agents when working with code in this repository.

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

# Agent Instructions

This project uses **bd** (beads) for issue tracking. Run `bd onboard` to get started.

## Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --status in_progress  # Claim work
bd close <id>         # Complete work
bd sync               # Sync with git
```

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd sync
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
