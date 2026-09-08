param([string]$RepositoryRoot = ".")

function Assert-NotMatches([string]$Path, [string]$Pattern, [string]$Message) {
  $Content = Get-Content -LiteralPath $Path -Raw
  if ($Content -match $Pattern) {
    throw $Message
  }
}

function Assert-Matches([string]$Path, [string]$Pattern, [string]$Message) {
  $Content = Get-Content -LiteralPath $Path -Raw
  if ($Content -notmatch $Pattern) {
    throw $Message
  }
}

function Assert-OnlyFrontMatterSeparators([string]$Path) {
  $Separators = @(Select-String -LiteralPath $Path -Pattern '^---\s*$')
  if ($Separators.Count -ne 2) {
    throw "Only front matter separators are allowed in $Path."
  }
}

$PublicationsInclude = Join-Path $RepositoryRoot "_includes/publications.md"
$IndexPage = Join-Path $RepositoryRoot "index.md"
$ExperiencePage = Join-Path $RepositoryRoot "experience-service.md"
$Stylesheet = Join-Path $RepositoryRoot "_sass/_academic-homepage.scss"
$PatentsInclude = Join-Path $RepositoryRoot "_includes/patents.md"
$AwardsInclude = Join-Path $RepositoryRoot "_includes/awards.md"
$ServicesInclude = Join-Path $RepositoryRoot "_includes/services.md"

Assert-NotMatches $PublicationsInclude '<h2\b[^>]*>\s*Publications\s*</h2>' "The Publications include must not repeat the page title."
Assert-OnlyFrontMatterSeparators $IndexPage
Assert-OnlyFrontMatterSeparators $ExperiencePage
Assert-NotMatches $Stylesheet '(?s)\.page-main h2\s*\{[^}]*border-bottom' "Section headings must not draw divider lines."
Assert-Matches $Stylesheet '(?s)\.site-shell\s*\{[^}]*grid-template-columns\s*:\s*300px' "The profile column must be widened."
Assert-Matches $Stylesheet '(?s)\.profile-name\s*\{[^}]*font-size\s*:\s*1\.15rem' "The profile name must be only slightly larger than the affiliation."
Assert-Matches $Stylesheet '(?s)\.profile-avatar\s*\{[^}]*width\s*:\s*150px[^}]*height\s*:\s*120px' "The profile avatar must use the restored oval proportion."
Assert-Matches $Stylesheet '(?s)\.site-footer\s*\{[^}]*text-align\s*:\s*center' "The footer must be centered within the main content column."
Assert-Matches $Stylesheet '(?s)\.page-main h3\s*\{[^}]*font-size\s*:\s*1rem' "Service groups must have a consistent tertiary heading style."
Assert-NotMatches $PatentsInclude '<autocolor>|style=' "Patents must not retain legacy inline styling."
Assert-NotMatches $AwardsInclude '<autocolor>|style=' "Awards must not retain legacy inline styling."
Assert-NotMatches $ServicesInclude '<autocolor>|style=' "Services must not retain legacy inline styling."
Assert-NotMatches $Stylesheet '(?s)\.page-main \.pub-row\s*\{[^}]*border-bottom' "Publication rows must not draw divider lines."
Assert-Matches $Stylesheet '(?s)\.page-main \.pub-row\s*\{[^}]*align-items\s*:\s*start' "Publication artwork and text must align at their top edges."
Assert-Matches $Stylesheet '(?s)\.page-main \.title\s*\{[^}]*font-size\s*:\s*inherit' "Publication titles must inherit the body text size."
Assert-Matches $Stylesheet '(?s)\.page-main \.author\s*,\s*\.page-main \.periodical\s*\{[^}]*font-size\s*:\s*inherit' "Publication authors and venues must inherit the body text size."

Write-Output "Content structure checks passed."
