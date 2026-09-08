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

$HomePage = Join-Path $SiteDirectory "index.html"
Assert-Contains $HomePage 'href="/publications/"'
Assert-Contains $HomePage 'href="/achievements/"'
Assert-Contains $HomePage 'href="/experience-service/"'
Assert-Contains $HomePage 'href="/life/"'
Assert-Contains $HomePage "lcao950@connect.hkust-gz.edu.cn"

if (Select-String -LiteralPath $HomePage -Pattern '<h[1-6][^>]*>\s*Life\s*</h[1-6]>' -Quiet) {
  throw "Homepage must not include the Life page heading"
}
