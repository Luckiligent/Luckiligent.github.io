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

if ($AlbumContent -notmatch "title: Jiuzhaigou") {
  throw "The Jiuzhaigou album is missing."
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

$LifePage = Join-Path $RepositoryRoot "life.md"
$LifePageContent = Get-Content -LiteralPath $LifePage -Raw
foreach ($Marker in @("life-timeline", "life-timeline-date", "life-photo-strip", "life-photo")) {
  if ($LifePageContent -notmatch [regex]::Escape($Marker)) {
    throw "Life page is missing the $Marker layout hook."
  }
}

$Stylesheet = Join-Path $RepositoryRoot "_sass/_academic-homepage.scss"
$StylesheetContent = Get-Content -LiteralPath $Stylesheet -Raw
foreach ($Pattern in @("\.life-timeline\s*\{", "\.life-photo-strip\s*\{", "overflow-x\s*:\s*auto", "\.life-dialog img\s*\{[^}]*width\s*:\s*min\(820px, 84vw\)", "object-fit\s*:\s*contain", "\.life-dialog button\s*\{[^}]*border-radius")) {
  if (-not [regex]::IsMatch($StylesheetContent, $Pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)) {
    throw "Life stylesheet is missing expected rule: $Pattern"
  }
}

Write-Output "Jiuzhaigou life album checks passed."
