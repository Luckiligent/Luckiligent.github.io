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
