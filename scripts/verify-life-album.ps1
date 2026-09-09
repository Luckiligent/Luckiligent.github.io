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

Write-Output "Jiuzhaigou life album checks passed."
