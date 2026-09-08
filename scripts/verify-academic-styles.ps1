param([string]$Stylesheet = "_sass/_academic-homepage.scss")

$Content = Get-Content -LiteralPath $Stylesheet -Raw

if ($Content -notmatch '(?s)\.site-footer\s*\{[^}]*\bposition\s*:\s*static') {
  throw "The academic footer must override the legacy fixed positioning."
}

if ($Content -notmatch '(?s)\.site-footer\s*\{[^}]*\bwidth\s*:\s*auto') {
  throw "The academic footer must override the legacy fixed width."
}

Write-Output "Academic layout style checks passed."
