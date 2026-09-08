# Academic Homepage Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild the Jekyll site as a concise academic homepage with preserved content on supporting pages and a separate multi-image Life gallery.

**Architecture:** Keep Jekyll and the existing publication data source. A shared sidebar layout provides the site navigation; the homepage contains only identity, biography, research interests, News, and a publication preview, while full academic content moves to focused Markdown pages. Life data is YAML-driven and rendered through a standalone gallery page with a lightweight JavaScript lightbox.

**Tech Stack:** Jekyll 3.8.5, Liquid templates, SCSS, vanilla JavaScript, PowerShell verification script.

**Spec:** `docs/superpowers/specs/2026-09-09-academic-homepage-design.md`

## Global Constraints

- Preserve all existing publication, news, patent, award, experience, service, contact, social-link, PDF, and image content.
- Keep existing prose unchanged except for layout-specific presentation; do not introduce a marketing-style research slogan.
- Homepage content is limited to About, Research Interests, News, and Selected Publications.
- `Life` is a dedicated page and must not appear as a homepage section.
- Use a light neutral visual system and one restrained blue link/interaction accent.
- Do not add a client framework, remote runtime dependency, or a second static-site generator.
- Desktop email `lcao950@connect.hkust-gz.edu.cn` must not wrap.
- The site must remain usable at desktop and mobile widths.

---

## File Structure

- `_layouts/homepage.html`: shared document shell, identity sidebar, navigation, social links, and page-content slot.
- `_sass/_academic-homepage.scss`: design-specific layout, typography, navigation, publication preview, life gallery, dialog, and responsive styles.
- `assets/css/style.scss` and `assets/css/style-no-dark-mode.scss`: import the shared academic stylesheet after the selected Minimal Light base theme.
- `index.md`: compact homepage containing existing About copy, current research interests, existing News copy, and selected-publication preview.
- `_includes/publications-preview.html`: renders the first three entries in `site.data.publications.main`.
- `publications.md`: full existing publications list.
- `achievements.md`: existing patents and awards.
- `experience-service.md`: existing experience and service information.
- `life.md`: Life page, album grid, empty state, and accessible dialog markup.
- `_data/life.yml`: stable album schema; begins with an empty album collection so the site builds before personal photos are added.
- `assets/js/life-gallery.js`: dialog open/close, image selection, Escape, and previous/next keyboard controls.
- `scripts/verify-site.ps1`: build-output assertions for page presence, preserved sections, navigation, homepage scope, and Life empty/gallery markup.

## Task 1: Add Build-Output Verification

**Files:**
- Create: `scripts/verify-site.ps1`
- Test: `scripts/verify-site.ps1`

**Interfaces:**
- Consumes: Jekyll output directory passed as `-SiteDirectory`.
- Produces: exit code `0` when required generated pages and content markers exist; nonzero exit code with a named missing file or marker otherwise.

- [ ] **Step 1: Write the failing verifier contract**

Create `scripts/verify-site.ps1` with this initial assertion set:

```powershell
param([string]$SiteDirectory = "_site")

function Assert-Contains([string]$Path, [string]$Needle) {
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing generated file: $Path"
  }
  if (-not (Select-String -LiteralPath $Path -SimpleMatch $Needle -Quiet)) {
    throw "Missing '$Needle' in $Path"
  }
}

Assert-Contains (Join-Path $SiteDirectory "index.html") "Research Interests"
Assert-Contains (Join-Path $SiteDirectory "index.html") "Selected Publications"
Assert-Contains (Join-Path $SiteDirectory "publications/index.html") "Discrete Tokenization for Multimodal LLMs"
Assert-Contains (Join-Path $SiteDirectory "achievements/index.html") "China Patent"
Assert-Contains (Join-Path $SiteDirectory "experience-service/index.html") "Teaching Assistant"
Assert-Contains (Join-Path $SiteDirectory "life/index.html") "No moments have been added yet"
```

- [ ] **Step 2: Run the verifier before the new pages exist**

Run: `pwsh -File scripts/verify-site.ps1 -SiteDirectory _site`

Expected: FAIL, reporting at least one missing generated page or required marker.

- [ ] **Step 3: Extend the verifier with homepage-scope checks**

Add checks that the generated homepage has links to `/publications/`, `/achievements/`, `/experience-service/`, and `/life/`, contains the exact email string, and does not contain the `Life` page heading as homepage content. Use `Assert-Contains` for required markers and an `if (Select-String ...) { throw ... }` block for the exclusion.

- [ ] **Step 4: Commit the verification harness**

```powershell
git add scripts/verify-site.ps1
git commit -m "test: add academic site output verifier"
```

## Task 2: Move Existing Academic Content Into Focused Pages

**Files:**
- Create: `_includes/publications-preview.html`
- Create: `publications.md`
- Create: `achievements.md`
- Create: `experience-service.md`
- Modify: `index.md`
- Test: `scripts/verify-site.ps1`

**Interfaces:**
- Consumes: `site.data.publications.main`, `_includes/publications.md`, `_includes/patents.md`, `_includes/awards.md`, `_includes/services.md`, and current `index.md` prose.
- Produces: routes `/`, `/publications/`, `/achievements/`, and `/experience-service/` with no scholarly content dropped.

- [ ] **Step 1: Write the failing content-route assertions**

Extend `scripts/verify-site.ps1` with these exact checks before creating the pages:

```powershell
Assert-Contains (Join-Path $SiteDirectory "index.html") "Happy to share our new preprint"
Assert-Contains (Join-Path $SiteDirectory "index.html") "Towards Calibrated Gradient-based Multi-Task Learning"
Assert-Contains (Join-Path $SiteDirectory "publications/index.html") "Federated Inverse Reinforcement Learning"
Assert-Contains (Join-Path $SiteDirectory "achievements/index.html") "USTC Outstanding Graduate 2024"
Assert-Contains (Join-Path $SiteDirectory "experience-service/index.html") "Remote Research Assistant"
Assert-Contains (Join-Path $SiteDirectory "experience-service/index.html") "IEEE Internet of Things Journal"
```

- [ ] **Step 2: Run the current build and verifier**

Run: `bundle exec jekyll build; pwsh -File scripts/verify-site.ps1 -SiteDirectory _site`

Expected: FAIL because the dedicated routes and homepage publication-preview heading do not exist yet.

- [ ] **Step 3: Implement the content split without rewriting prose**

Use the following page contracts:

```markdown
<!-- publications.md -->
---
layout: homepage
title: Publications
permalink: /publications/
---
{% include_relative _includes/publications.md %}
```

```markdown
<!-- achievements.md -->
---
layout: homepage
title: Achievements
permalink: /achievements/
---
{% include_relative _includes/patents.md %}
{% include_relative _includes/awards.md %}
```

Move the current Experience list from `index.md` into `experience-service.md` and append the unchanged `_includes/services.md`. Leave the current About, Research Interests, and News copy in `index.md`; replace the full publications include with `_includes/publications-preview.html`. The preview loops over the first three entries and links its heading to `/publications/`.

- [ ] **Step 4: Rebuild and run route/content checks**

Run: `bundle exec jekyll build; pwsh -File scripts/verify-site.ps1 -SiteDirectory _site`

Expected: PASS for the content-preservation and route assertions.

- [ ] **Step 5: Commit the content migration**

```powershell
git add index.md publications.md achievements.md experience-service.md _includes/publications-preview.html scripts/verify-site.ps1
git commit -m "feat: organize academic content into pages"
```

## Task 3: Build the Shared Academic Layout and Responsive Styling

**Files:**
- Create: `_sass/_academic-homepage.scss`
- Modify: `_layouts/homepage.html`
- Modify: `assets/css/style.scss`
- Modify: `assets/css/style-no-dark-mode.scss`
- Modify: `scripts/verify-site.ps1`
- Test: `scripts/verify-site.ps1`

**Interfaces:**
- Consumes: page front matter (`title`, `permalink`), site config identity/social values, and all pages from Task 2.
- Produces: `.site-shell`, `.profile-sidebar`, `.site-nav`, `.page-main`, and `.section-heading` semantic classes used by all academic pages.

- [ ] **Step 1: Add failing generated-layout assertions**

Add these checks to `scripts/verify-site.ps1`:

```powershell
Assert-Contains (Join-Path $SiteDirectory "index.html") "class=\"profile-sidebar\""
Assert-Contains (Join-Path $SiteDirectory "index.html") "lcao950@connect.hkust-gz.edu.cn"
Assert-Contains (Join-Path $SiteDirectory "index.html") "href=\"/life/\""
Assert-Contains (Join-Path $SiteDirectory "assets/css/style-no-dark-mode.css") ".profile-sidebar"
```

- [ ] **Step 2: Run the build and verify the assertions fail**

Run: `bundle exec jekyll build; pwsh -File scripts/verify-site.ps1 -SiteDirectory _site`

Expected: FAIL because the current layout has no `.profile-sidebar` or Life navigation link.

- [ ] **Step 3: Implement the layout and shared stylesheet**

Replace the fixed legacy `header`/`section` structure in `_layouts/homepage.html` with this semantic outline:

```html
<div class="site-shell">
  <aside class="profile-sidebar">...</aside>
  <main class="page-main">
    {% unless page.url == "/" %}<h1 class="page-title">{{ page.title }}</h1>{% endunless %}
    {{ content }}
  </main>
</div>
```

The sidebar navigation must link to Home, Publications, Achievements, Experience & Service, and Life. In `_sass/_academic-homepage.scss`, set the desktop sidebar to `min-width: 270px` and make `.profile-email { white-space: nowrap; }`; collapse `.site-shell` to one column below `760px`. Import this partial from both SCSS entry points after their Minimal Light import. Preserve the current configured avatar, Scholar, CV, and GitHub URLs.

- [ ] **Step 4: Rebuild and run the verifier**

Run: `bundle exec jekyll build; pwsh -File scripts/verify-site.ps1 -SiteDirectory _site`

Expected: PASS for layout, navigation, and email checks.

- [ ] **Step 5: Visually verify the page at two viewport widths**

Run: `bundle exec jekyll serve --livereload`

Inspect `http://127.0.0.1:4000/` at `1440x1000` and `390x844`. Confirm the sidebar is readable, email remains one line on desktop, navigation is reachable, no text overlaps, and the mobile layout is a single column.

- [ ] **Step 6: Commit the shared layout**

```powershell
git add _layouts/homepage.html _sass/_academic-homepage.scss assets/css/style.scss assets/css/style-no-dark-mode.scss scripts/verify-site.ps1
git commit -m "feat: add responsive academic site layout"
```

## Task 4: Add the Dedicated Life Album Gallery

**Files:**
- Create: `_data/life.yml`
- Create: `life.md`
- Create: `assets/js/life-gallery.js`
- Modify: `_sass/_academic-homepage.scss`
- Modify: `_layouts/homepage.html`
- Modify: `scripts/verify-site.ps1`
- Test: `scripts/verify-site.ps1`

**Interfaces:**
- Consumes: `site.data.life.albums`, where each album has `slug`, `title`, optional `date`, optional `location`, optional `caption`, `cover`, and an `images` list of `{ src, alt }` objects.
- Produces: `/life/` with `.life-album` cards and a native `<dialog id="life-gallery-dialog">` that opens an album and supports image navigation.

- [ ] **Step 1: Add failing Life-page assertions**

Add these checks to `scripts/verify-site.ps1`:

```powershell
Assert-Contains (Join-Path $SiteDirectory "life/index.html") "id=\"life-gallery-dialog\""
Assert-Contains (Join-Path $SiteDirectory "life/index.html") "No moments have been added yet"
Assert-Contains (Join-Path $SiteDirectory "assets/js/life-gallery.js") "Escape"
Assert-Contains (Join-Path $SiteDirectory "assets/js/life-gallery.js") "ArrowRight"
```

- [ ] **Step 2: Run the build and confirm Life assertions fail**

Run: `bundle exec jekyll build; pwsh -File scripts/verify-site.ps1 -SiteDirectory _site`

Expected: FAIL because no Life route, data contract, or gallery script exists.

- [ ] **Step 3: Implement an empty-safe YAML data contract and page**

Create `_data/life.yml` with `albums: []`. In `life.md`, use Liquid to render album cards only when `site.data.life.albums.size > 0`; otherwise render exactly `No moments have been added yet.` Include a native dialog containing a close button, current image, caption, previous button, and next button. Add `defer` script loading for `/assets/js/life-gallery.js` in the shared layout only when `page.permalink == '/life/'`.

- [ ] **Step 4: Implement keyboard and pointer gallery behavior**

In `assets/js/life-gallery.js`, keep the selected album images in a local `activeImages` array. Card activation opens the dialog at index `0`; previous/next controls wrap around; `Escape` closes; `ArrowLeft` and `ArrowRight` change the selected image only while the dialog is open. Restore focus to the activating album card after close.

- [ ] **Step 5: Rebuild and run Life checks**

Run: `bundle exec jekyll build; pwsh -File scripts/verify-site.ps1 -SiteDirectory _site`

Expected: PASS, including the empty-state assertion. Then temporarily add a two-image sample album locally, rebuild, and verify that a card exposes both image entries to the gallery; remove the sample before committing so no invented personal moments ship.

- [ ] **Step 6: Visually and interactively verify the gallery**

With `bundle exec jekyll serve --livereload` running, open `/life/`. Verify the empty state. Temporarily use the two-image sample from Step 5 and verify card opening, Previous, Next, ArrowLeft, ArrowRight, Escape, close-button behavior, focus restoration, and mobile layout. Remove the sample afterward.

- [ ] **Step 7: Commit the Life feature**

```powershell
git add _data/life.yml life.md assets/js/life-gallery.js _sass/_academic-homepage.scss _layouts/homepage.html scripts/verify-site.ps1
git commit -m "feat: add personal life album gallery"
```

## Task 5: Final Regression Check and Deployment Readiness

**Files:**
- Modify: `scripts/verify-site.ps1` only if an assertion is missing a documented requirement.
- Test: `scripts/verify-site.ps1`, generated `_site/` output, browser rendering.

**Interfaces:**
- Consumes: all generated site routes and assets from Tasks 1-4.
- Produces: a clean local build suitable for GitHub Pages deployment.

- [ ] **Step 1: Run the full production build**

Run: `bundle exec jekyll build --trace`

Expected: exit code `0` with no Liquid, Sass, or missing-include errors.

- [ ] **Step 2: Run the complete static verification suite**

Run: `pwsh -File scripts/verify-site.ps1 -SiteDirectory _site`

Expected: exit code `0`; homepage is compact, all preserved academic content appears on a named route, and Life is independent.

- [ ] **Step 3: Review generated links and responsive behavior**

Run: `bundle exec jekyll serve --livereload`

Visit `/`, `/publications/`, `/achievements/`, `/experience-service/`, and `/life/`. Check every sidebar route, Scholar/CV/GitHub link, paper PDF link, and mobile navigation at `390x844`; check desktop email and two-column geometry at `1440x1000`.

- [ ] **Step 4: Inspect repository state before final commit**

Run: `git status --short; git diff --check`

Expected: no whitespace errors and no temporary sample-life images or generated `_site/` files staged.

- [ ] **Step 5: Commit any final validation-only correction**

```powershell
git add scripts/verify-site.ps1
git commit -m "test: cover academic homepage regressions"
```

Only create this commit when the verifier changed during final validation; otherwise do not create an empty commit.
