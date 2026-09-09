param([string]$RepositoryRoot = ".")

$AlbumFile = Join-Path $RepositoryRoot "_data/life.yml"
$AlbumContent = Get-Content -LiteralPath $AlbumFile -Raw
$ExpectedImages = @(
  "01-forest-path.png",
  "02-turquoise-lake-branch.png",
  "03-submerged-log.png",
  "04-emerald-shore.jpg",
  "05-mountain-lake.jpg",
  "06-lake-through-leaves.jpg",
  "07-mountain-reflection.jpg",
  "08-valley-lake.jpg",
  "09-mountain-and-lake.jpg",
  "10-alpine-valley.jpg",
  "11-lakeside-forest.jpg"
)

if ($AlbumContent -notmatch "title: Blue in the Keeping of Mountains") {
  throw "The Jiuzhaigou gallery title is missing."
}
if ($AlbumContent -notmatch "sort_date: 2026-08-01") {
  throw "The Jiuzhaigou album needs an ISO sorting date."
}

if ($AlbumContent -notmatch "date: August 2026") {
  throw "The Jiuzhaigou album date is missing."
}

foreach ($ImageName in $ExpectedImages) {
  if ($AlbumContent -notmatch [regex]::Escape($ImageName)) {
    throw "The album does not reference $ImageName."
  }

  $ImagePath = Join-Path $RepositoryRoot ("assets/img/life/jiuzhaigou-2026-08/" + $ImageName)
  if (-not (Test-Path -LiteralPath $ImagePath -PathType Leaf)) {
    throw "Missing album image: $ImagePath"
  }
}

if ($AlbumContent -notmatch "cover: /assets/img/life/jiuzhaigou-2026-08/02-turquoise-lake-branch.png") {
  throw "The album cover must reference an image in the album."
}

$GuizhouImages = @(
  "01-mountain-waterfall.png",
  "02-riverside-fisher.png",
  "03-miao-village.png",
  "04-tall-waterfall.png",
  "05-stone-bridge.png",
  "06-tea-hills.png",
  "07-tiered-waterfall.png",
  "08-waterfall-cascade.png"
)
if ($AlbumContent -notmatch "title: Songs of Water and Stone") { throw "The Guizhou gallery title is missing." }
if ($AlbumContent -notmatch "sort_date: 2026-04-01") { throw "The Guizhou album needs an ISO sorting date." }
if ($AlbumContent -notmatch "date: April 2026") { throw "The Guizhou album date is missing." }
if ($AlbumContent -notmatch "location: Guizhou") { throw "The Guizhou album location is missing." }
foreach ($ImageName in $GuizhouImages) {
  if ($AlbumContent -notmatch [regex]::Escape($ImageName)) { throw "The Guizhou album does not reference $ImageName." }
  $ImagePath = Join-Path $RepositoryRoot ("assets/img/life/guizhou-2026-04/" + $ImageName)
  if (-not (Test-Path -LiteralPath $ImagePath -PathType Leaf)) { throw "Missing Guizhou image: $ImagePath" }
}
if ($AlbumContent -notmatch "cover: /assets/img/life/guizhou-2026-04/01-mountain-waterfall.png") {
  throw "The Guizhou album cover must reference an image in the album."
}

$LifePage = Join-Path $RepositoryRoot "life.md"
$LifePageContent = Get-Content -LiteralPath $LifePage -Raw
foreach ($Marker in @("life-timeline", "life-timeline-date", "life-photo-strip", "life-photo")) {
  if ($LifePageContent -notmatch [regex]::Escape($Marker)) {
    throw "Life page is missing the $Marker layout hook."
  }
}
if ($LifePageContent -notmatch 'sort: "sort_date"') {
  throw "Life albums must be ordered by their ISO sorting date."
}
if ($LifePageContent -match "life-album-heading|images\.size}} photos|images\.size }} photos") {
  throw "Life page must not visibly repeat album names or photo counts."
}
foreach ($Marker in @("life-dialog-navigation", "life-dialog-close")) {
  if ($LifePageContent -notmatch [regex]::Escape($Marker)) {
    throw "Life page is missing the $Marker dialog layout hook."
  }
}

$Stylesheet = Join-Path $RepositoryRoot "_sass/_academic-homepage.scss"
$StylesheetContent = Get-Content -LiteralPath $Stylesheet -Raw
foreach ($Pattern in @("\.life-timeline\s*\{", "\.life-photo-strip\s*\{", "overflow-x\s*:\s*auto", "\.life-dialog img\s*\{[^}]*width\s*:\s*min\(820px, 84vw\)", "object-fit\s*:\s*contain", "\.life-dialog button\s*\{[^}]*border-radius", "\.life-timeline::before\s*\{[^}]*left\s*:\s*104px", "\.life-timeline-entry::before\s*\{[^}]*left\s*:\s*-36px", "\.life-timeline-date\s*\{[^}]*left\s*:\s*-160px[^}]*width\s*:\s*120px", "\.life-gallery-title\s*\{[^}]*text-align\s*:\s*center", "\.life-dialog-controls\s*\{[^}]*grid-template-columns\s*:\s*1fr\s+auto\s+1fr", "\.life-dialog-close\s*\{[^}]*justify-self\s*:\s*end", "font-family\s*:\s*inherit", "line-height\s*:\s*1\.2", "linear-gradient")) {
  if (-not [regex]::IsMatch($StylesheetContent, $Pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)) {
    throw "Life stylesheet is missing expected rule: $Pattern"
  }
}

Write-Output "Jiuzhaigou life album checks passed."
