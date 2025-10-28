# Agent Instructions for taxes.github.io

This file provides context and guidelines for AI coding agents working on this repository.

## Repository Overview

This is a personal website and blog for Ken, hosted on GitHub Pages at knowingken.com. The site is built using Jekyll, a static site generator, and uses the Minima theme.

**Purpose:** Personal blog and portfolio.

**Technology Stack:**
- Jekyll (static site generator)
- GitHub Pages (hosting)
- Minima theme with custom css
- Ruby/Bundler for dependencies

## Repository Structure

```
├── _config.yml           # Jekyll configuration
├── _layouts/             # Custom layout templates
├── _includes/            # Reusable template components
├── _posts/               # Blog posts (YYYY-MM-DD-title.md format)
├── _site/                # Generated site (ignored by git)
├── assets/
│   └── css/              # Custom styles
├── *.md files            # Static pages (bio, poetry, reading, etc.)
├── index.md              # Homepage
└── agents.md             # This file (excluded from site build)
```

## Content Guidelines

**Content That Should NOT Be Modified Without Explicit Permission:**
- `bio.md` - Personal biography
- `poetry.md` and poetry content files
- `reading.md` - Personal reading list
- Any personal writing or blog posts
- `CNAME` - Domain configuration
- Personal details, contact information, or biographical facts

## Development Workflow

**Local Development:**
```bash
bundle install              # Install dependencies
bundle exec jekyll serve    # Start local server at http://localhost:4000
```

**Git Branching:**
- Main branch: `gh-pages` (production, auto-deploys to GitHub Pages)
- Development branch: `dev` (for testing changes)
- Merge to `dev` first for testing, then to `gh-pages` for deployment

**Deployment:**
- GitHub Pages automatically builds and deploys from the `gh-pages` branch
- Changes pushed to `gh-pages` go live within minutes
- No manual build/deploy steps required

## Jekyll Conventions

**Front Matter:**
All pages and posts require YAML front matter at the top:
```yaml
---
layout: default    # or 'home', 'post', etc.
title: "Page Title"
slug: page-slug    # Used for permalinks
tags: [tag1, tag2] # Optional, used for filtering
---
```

**Blog Posts:**
- Filename format: `YYYY-MM-DD-title.md` in `_posts/` directory
- Must include `layout: post` in front matter
- Date in filename determines post date
- Tags: Use `memory` tag for memory-related learning posts

**Permalinks:**
- Configured as `/:slug` in `_config.yml`
- Use the `slug` front matter variable to control URL

**Special Tags:**
- `memory` - Posts about learning about memory (displayed on homepage)
- Untagged posts appear in the main blog list

## Important Files

**Do Not Modify Without Permission:**
- `_config.yml` - Site-wide configuration (domain, analytics, plugins)
- `CNAME` - Domain routing for GitHub Pages
- `Gemfile` / `Gemfile.lock` - Ruby dependencies

**Safe to Modify:**
- `assets/css/style.css` - Custom styles
- `_layouts/*.html` - Layout templates (with care)
- New blog posts in `_posts/`

## Common Tasks

**Adding a New Blog Post:**
1. Create file in `_posts/` with format: `YYYY-MM-DD-title.md`
2. Add front matter with layout, title, and optional tags
3. Write content in Markdown
4. Test locally with `bundle exec jekyll serve`
5. Commit to `dev` branch first, then merge to `gh-pages`

**Adding a New Static Page:**
1. Create `.md` file in root directory
2. Add front matter with layout and title
3. Link to it from relevant pages (e.g., `index.md` or navigation)
4. Add to Jekyll exclude list in `_config.yml` if it's not meant to be public

**Modifying Styles:**
1. Edit `assets/css/style.css`
2. Test locally to ensure changes work
3. Check responsive design if layout changes

**Updating Navigation/Layout:**
1. Modify `_layouts/default.html` or relevant layout file
2. Test all pages to ensure layout works correctly
3. Be careful with Liquid template syntax

## Files Excluded from Site Build

These files exist in the repo but are NOT published to the website:
- `agents.md` (this file)
- Jekyll config and build files
- Ruby/Bundler files (Gemfile, etc.)
- Git files (.gitignore, etc.)
- See `exclude:` section in `_config.yml` for full list

## Notes for Agents

- Always test changes locally before committing
- Respect the personal nature of this site - don't modify personal content without explicit approval
- Follow existing patterns and conventions in the codebase
- When in doubt, ask the user before making significant changes
- This is a personal site, not a commercial project
- The owner (Ken) may edit this file to add more specific instructions over time
- Value minimalist aesthetic and performant code. Minimize dependencies