# Task 1 Report: Build-Output Verification

## Implementation

Created `scripts/verify-site.ps1`. It accepts `-SiteDirectory` (default `_site`) and exits successfully only when the generated site includes:

- homepage Research Interests and Selected Publications markers;
- generated Publications, Achievements, Experience & Service, and Life pages with their required content markers;
- homepage links to `/publications/`, `/achievements/`, `/experience-service/`, and `/life/`;
- the exact email address `lcao950@connect.hkust-gz.edu.cn`; and
- no `Life` heading (`<h1>` through `<h6>`) in the homepage body, preserving Life as a separate page while allowing its navigation link.

Missing generated files and missing markers produce named terminating errors and a nonzero exit code.

## Commands And Results

| Command | Result |
| --- | --- |
| `pwsh -File scripts/verify-site.ps1 -SiteDirectory _site` | Expected failure, exit 1: `Missing generated file: _site\\index.html`. |
| `pwsh -File scripts/verify-site.ps1 -SiteDirectory scripts/.verify-site-fixture` | Passed, exit 0, against a temporary complete generated-site fixture. The fixture was removed after verification. |
| `pwsh -File scripts/verify-site.ps1 -SiteDirectory _site` | Expected final failure, exit 1: `Missing generated file: _site\\index.html`. |
| `git diff --check` | Passed, exit 0. |

## RED/GREEN Evidence

RED: Before page creation, the verifier failed for the expected missing generated homepage (`_site\\index.html`). This demonstrates it will block an absent or incomplete build output.

GREEN: A controlled generated-site fixture with every required page, marker, route link, exact email, and no Life heading on its homepage exited 0. The verifier exercised the actual script and filesystem paths rather than inspecting its own source.

## Files Changed

- `scripts/verify-site.ps1`
- `.superpowers/sdd/2026-09-09-academic-homepage-redesign/task-1-report.md`

## Self-Review

The script uses `-LiteralPath` for filesystem checks and `-SimpleMatch` for required literal markers. The Life exclusion is limited to heading markup, so a necessary `/life/` navigation link does not cause a false failure. The verifier has no dependency on a running server or external tooling beyond PowerShell.

## Concerns

The repository has not yet created the redesigned generated pages, so the verifier is intentionally red when run against `_site`. A later page-creation task must run `bundle exec jekyll build` and then rerun this verifier against the real build output.

## Fix Round 1

### Review Findings Addressed

- Replaced one-off assertions with `$RequiredMarkers`, a canonical literal marker list that maps each preservation requirement to its expected generated route.
- Added homepage requirements for About Me, Research Interests, News, Selected Publications, navigation, and all configured contact/social destinations (email mailto, Scholar, CV, and GitHub).
- Reject dedicated page headings for Publications, Achievements, Experience & Service, and Life. Dedicated achievement, experience/service, and Life markers are also rejected from the homepage, while publication titles remain valid in the intentional Selected Publications preview.
- Added a generated desktop stylesheet assertion requiring `.profile-email` to contain `white-space: nowrap`.
- Expanded the temporary GREEN fixture to include all six publications, all patents and awards, all experiences and services, every configured contact/social destination, the full compact homepage marker set, and the compiled `.profile-email` rule.

### Fix Verification

| Command | Result |
| --- | --- |
| `pwsh -File scripts/verify-site.ps1 -SiteDirectory scripts/.verify-site-fixture` with a homepage `<h2>Achievements</h2>` mutation | Expected failure, exit 1: `Homepage must not include the dedicated page heading: Achievements`. |
| `pwsh -File scripts/verify-site.ps1 -SiteDirectory scripts/.verify-site-fixture` after removing the mutation | Passed, exit 0. |
| `git diff --check` | Passed, exit 0. |

### Fix Self-Review

`Assert-Matches` reads the stylesheet as a single string before applying the CSS regex, so selector and declaration formatting across separate lines is correctly accepted. All preservation checks are literal and route-specific. The homepage exclusions derive from the same canonical list, preventing the route and scope inventories from drifting apart.

### Fix Concerns

The real generated `_site` remains unavailable until the later implementation tasks build the redesigned pages. The verifier's full GREEN evidence therefore uses a temporary output fixture; it must be rerun against a real `bundle exec jekyll build` result during integration.

## Fix Round 2

### Review Findings Addressed

- Replaced the homepage heading deny-list with `Assert-AllowedHomeHeadings`. It inspects headings within `.page-main`, requires About Me, Research Interests, News, and Selected Publications, and rejects every other content heading. Profile/sidebar identity headings are outside that content container.
- Added a homepage email-element assertion: the exact configured address must appear as a `mailto:` anchor with the `profile-email` class. The existing generated stylesheet assertion continues to require `.profile-email { white-space: nowrap; }`.
- Expanded `$RequiredMarkers` with the complete About biography facts, exact collaboration invitation, every dated news item and its distinctive text, configured avatar path, and every publication title, PDF URL, image path, and FERRY slides URL.

### Fix Verification

| Command | Result |
| --- | --- |
| Legacy verifier against a fixture with an unsupported `Unrelated Section` content heading and unclassified email link | Passed, exit 0, demonstrating the previous coverage gap. |
| Updated verifier against a fixture missing the biography | Expected failure, exit 1: missing `I'm a Ph.D. student in the Artificial Intelligence Thrust at`. |
| Updated verifier against a complete fixture with `<h2>Unrelated Section</h2>` | Expected failure, exit 1: `Homepage contains unsupported content heading: 'Unrelated Section'`. |
| Updated verifier against a complete fixture whose email anchor lacks `profile-email` | Expected failure, exit 1: missing `.profile-email` email element. |
| Updated verifier against the restored complete fixture | Passed, exit 0. |

### Fix Self-Review

The allowed-heading check operates on semantic content (`main.page-main`) and strips nested heading markup before comparing exact headings. It both requires each permitted section and rejects additions. Resource preservation markers remain literal and route-specific, so a removed PDF, image, or supporting resource fails the generated-output contract.

### Fix Concerns

The final verifier contract depends on the planned `main.page-main` layout container and `profile-email` class. Those are established Task 3 layout contracts. A real Jekyll build must still validate the compiled site once the later page and layout tasks land.
