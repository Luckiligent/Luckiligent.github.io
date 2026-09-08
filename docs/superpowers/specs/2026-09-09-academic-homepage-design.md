# Academic Homepage Redesign

## Goal

Refresh Linxiao Cao's GitHub Pages site into a restrained academic homepage for research collaborators and industry readers. The redesign retains the site's current scholarly content and adds a separate personal photo-gallery page.

## Content Preservation

The site keeps all existing information and its current wording unless a layout-specific shortening is necessary:

- About Me biography and collaboration invitation
- Research Interests
- News
- Publications from `_data/publications.yml`
- Patents, Awards, Experience, and Services includes
- Existing Google Scholar, CV, GitHub, avatar, affiliation, and email links

The redesign must not remove existing publications, news items, patents, awards, experience, or service information. Existing paper assets and linked PDFs remain usable. Content may move to dedicated pages where that makes the homepage easier to scan.

## Information Architecture

### Home

The homepage uses a persistent identity sidebar on desktop and a compact identity header on mobile.

- The sidebar presents avatar, name, role, affiliation, email, Scholar, CV, and GitHub links. It is wide enough for `lcao950@connect.hkust-gz.edu.cn` to remain on one line at desktop widths.
- Main content is deliberately compact: About, Research Interests, News, and a small Selected Publications list.
- The About block uses the current biography rather than a new marketing-style research slogan.
- Research interests are low-emphasis tags or inline labels, not competing colored callouts.
- News remains on the homepage so recent research activity is immediately visible.
- Selected Publications is a short, scannable preview that links to the full Publications page.

### Supporting Academic Pages

- `Publications` contains the full existing publication list with thumbnails, authors, venues, and resource links.
- `Achievements` contains the current Patents and Awards information.
- `Experience & Service` contains the current Experience and Services information.
- These pages preserve all current content without forcing the homepage to function as a CV.

### Life

`Life` is a separate navigation destination, never a homepage section.

- It displays personal moments as occasion-based albums, such as table-tennis events and travel.
- Each album has a cover image, title, optional date/location/caption, and photo count.
- Opening an album displays all of its images in a keyboard-accessible lightbox/gallery.
- Albums are stored as structured data so additional photos or albums can be added without changing templates.
- An empty gallery state is intentional and polished until personal images are supplied.

## Visual Direction

- Calm, publication-first academic design with a light neutral background, dark readable text, and one restrained blue accent for links and interactive states.
- No hero slogan, dashboard metrics, or unrelated colored comparison panels.
- Modest borders and spacing separate content blocks without turning sections into floating cards.
- Desktop uses the approved left/right composition; mobile collapses into one column with navigation and identity information before the main content.

## Technical Design

- Continue using Jekyll and the existing GitHub Pages deployment.
- Replace the current single-column layout with a custom homepage layout and scoped stylesheet updates.
- Keep publication data in `_data/publications.yml` and existing reusable includes.
- Add `life.md`, a `_data/life.yml` data source, and an image directory under `assets/img/life/`.
- Use lightweight vanilla JavaScript and semantic HTML for the image gallery; avoid a client framework or remote runtime dependency.
- Preserve existing URLs and assets. The new Life URL is additive.

## Validation

- Build the Jekyll site locally.
- Verify every existing named section is present somewhere in the redesigned site, and the homepage contains only About, Research Interests, News, and Selected Publications.
- Verify desktop sidebar email does not wrap.
- Verify responsive layouts at desktop and mobile widths.
- Verify Life supports albums with more than one image, gallery open/close, keyboard dismissal, and an empty-state fallback.
