param([string]$SiteDirectory = "_site")

function Assert-Contains([string]$Path, [string]$Needle) {
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing generated file: $Path"
  }
  if (-not (Select-String -LiteralPath $Path -SimpleMatch $Needle -Quiet)) {
    throw "Missing '$Needle' in $Path"
  }
}

function Assert-NotContains([string]$Path, [string]$Needle) {
  if (Select-String -LiteralPath $Path -SimpleMatch $Needle -Quiet) {
    throw "Homepage must not include dedicated-page content: '$Needle'"
  }
}

function Assert-Matches([string]$Path, [string]$Pattern, [string]$Description) {
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing generated file: $Path"
  }
  if (-not [regex]::IsMatch((Get-Content -LiteralPath $Path -Raw), $Pattern)) {
    throw "Missing $Description in $Path"
  }
}

function Assert-AllowedHomeHeadings([string]$Path) {
  $HomeContent = Get-Content -LiteralPath $Path -Raw
  $MainContent = [regex]::Match($HomeContent, '(?is)<main\b[^>]*\bclass=["''][^"'']*\bpage-main\b[^"'']*["''][^>]*>(?<content>.*?)</main>')
  if (-not $MainContent.Success) {
    throw "Missing homepage content container: $Path"
  }

  $AllowedHeadings = @("About Me", "Research Interests", "News", "Selected Publications")
  $ObservedHeadings = @()
  foreach ($Match in [regex]::Matches($MainContent.Groups["content"].Value, '(?is)<h[1-6][^>]*>(?<heading>.*?)</h[1-6]>')) {
    $Heading = [System.Net.WebUtility]::HtmlDecode([regex]::Replace($Match.Groups["heading"].Value, '<[^>]+>', '')).Trim()
    $ObservedHeadings += $Heading
    if (-not $AllowedHeadings.Contains($Heading)) {
      throw "Homepage contains unsupported content heading: '$Heading'"
    }
  }
  foreach ($AllowedHeading in $AllowedHeadings) {
    if ($ObservedHeadings -notcontains $AllowedHeading) {
      throw "Homepage is missing required content heading: '$AllowedHeading'"
    }
  }
}

$RequiredMarkers = @(
  @{ RelativePath = "index.html"; Marker = "About Me" }
  @{ RelativePath = "index.html"; Marker = "Research Interests" }
  @{ RelativePath = "index.html"; Marker = "News" }
  @{ RelativePath = "index.html"; Marker = "Selected Publications" }
  @{ RelativePath = "index.html"; Marker = "I'm a Ph.D. student in the Artificial Intelligence Thrust at" }
  @{ RelativePath = "index.html"; Marker = "HKUST (Guangzhou)" }
  @{ RelativePath = "index.html"; Marker = "Menglin Yang" }
  @{ RelativePath = "index.html"; Marker = "I received my M.S. from the" }
  @{ RelativePath = "index.html"; Marker = "School of Data Science" }
  @{ RelativePath = "index.html"; Marker = "University of Science and Technology of China (USTC)" }
  @{ RelativePath = "index.html"; Marker = "where I was advised by Prof." }
  @{ RelativePath = "index.html"; Marker = "Wei Gong" }
  @{ RelativePath = "index.html"; Marker = "I welcome opportunities for collaboration—please feel free to reach out." }
  @{ RelativePath = "index.html"; Marker = "[Apr 2026]" }
  @{ RelativePath = "index.html"; Marker = "Happy to share our new preprint" }
  @{ RelativePath = "index.html"; Marker = "[Mar 2026]" }
  @{ RelativePath = "index.html"; Marker = "Delighted that" }
  @{ RelativePath = "index.html"; Marker = "[Feb 2026]" }
  @{ RelativePath = "index.html"; Marker = "Grateful that" }
  @{ RelativePath = "index.html"; Marker = "[Nov 2025]" }
  @{ RelativePath = "index.html"; Marker = "A new preprint is out:" }
  @{ RelativePath = "index.html"; Marker = "[Feb 2025]" }
  @{ RelativePath = "index.html"; Marker = "Glad to share that" }
  @{ RelativePath = "index.html"; Marker = "[Jun 2024]" }
  @{ RelativePath = "index.html"; Marker = "Our paper" }
  @{ RelativePath = "index.html"; Marker = "[Mar 2024]" }
  @{ RelativePath = "index.html"; Marker = "Happy to note that two of our patents have been granted!" }
  @{ RelativePath = "index.html"; Marker = "[May 2023]" }
  @{ RelativePath = "index.html"; Marker = "Honored that" }
  @{ RelativePath = "index.html"; Marker = "[Oct 2022]" }
  @{ RelativePath = "index.html"; Marker = "One paper was accepted to" }
  @{ RelativePath = "index.html"; Marker = 'href="/publications/"' }
  @{ RelativePath = "index.html"; Marker = 'href="/achievements/"' }
  @{ RelativePath = "index.html"; Marker = 'href="/experience-service/"' }
  @{ RelativePath = "index.html"; Marker = 'href="/life/"' }
  @{ RelativePath = "index.html"; Marker = "lcao950@connect.hkust-gz.edu.cn" }
  @{ RelativePath = "index.html"; Marker = "mailto:lcao950@connect.hkust-gz.edu.cn" }
  @{ RelativePath = "index.html"; Marker = "https://scholar.google.com.hk/citations?user=bFhDN14AAAAJ&hl=zh-CN" }
  @{ RelativePath = "index.html"; Marker = "assets/files/Linxiao_Cao_Resume.pdf" }
  @{ RelativePath = "index.html"; Marker = "https://github.com/Luckiligent" }
  @{ RelativePath = "index.html"; Marker = "assets/img/clx.png" }
  @{ RelativePath = "publications/index.html"; Marker = "Discrete Tokenization for Multimodal LLMs: A Comprehensive Survey" }
  @{ RelativePath = "publications/index.html"; Marker = "https://arxiv.org/pdf/2507.22920" }
  @{ RelativePath = "publications/index.html"; Marker = "./assets/img/Discrete_token.png" }
  @{ RelativePath = "publications/index.html"; Marker = "Towards Calibrated Gradient-based Multi-Task Learning" }
  @{ RelativePath = "publications/index.html"; Marker = "https://openaccess.thecvf.com/content/CVPR2026F/papers/Cao_Towards_Calibrated_Gradient-based_Multi-Task_Learning_CVPRF_2026_paper.pdf" }
  @{ RelativePath = "publications/index.html"; Marker = "./assets/img/VarGrad.png" }
  @{ RelativePath = "publications/index.html"; Marker = "HyperbolicRAG: Enhancing Retrieval-Augmented Generation with Hyperbolic Representations" }
  @{ RelativePath = "publications/index.html"; Marker = "./assets/files/HyperbolicRAG.pdf" }
  @{ RelativePath = "publications/index.html"; Marker = "./assets/img/HyperbolicRAG.png" }
  @{ RelativePath = "publications/index.html"; Marker = "Federated Reinforcement Learning for Therapeutic Interventions over ICUs with Noisy Labels" }
  @{ RelativePath = "publications/index.html"; Marker = "./assets/files/FERRY.pdf" }
  @{ RelativePath = "publications/index.html"; Marker = "./assets/files/FERRY_Slides.pdf" }
  @{ RelativePath = "publications/index.html"; Marker = "./assets/img/FERRY.png" }
  @{ RelativePath = "publications/index.html"; Marker = "SFPrompt: Communication-Efficient Split Federated Fine-Tuning for Large Pre-Trained Models over Resource-Limited Devices" }
  @{ RelativePath = "publications/index.html"; Marker = "https://arxiv.org/pdf/2407.17533" }
  @{ RelativePath = "publications/index.html"; Marker = "./assets/img/SFPrompt.png" }
  @{ RelativePath = "publications/index.html"; Marker = "Federated Inverse Reinforcement Learning for Smart ICUs with Differential Privacy" }
  @{ RelativePath = "publications/index.html"; Marker = "https://ieeexplore.ieee.org/document/10138664" }
  @{ RelativePath = "publications/index.html"; Marker = "./assets/img/FedICU.png" }
  @{ RelativePath = "achievements/index.html"; Marker = "An Inverse Reinforcement Learning-based Approach to ICU Ventilator and Sedative Management, China Patent, Granted, ZL202310151557.4" }
  @{ RelativePath = "achievements/index.html"; Marker = "A Federated Learning-based Approach to Intelligent Clinical Decision Making in Networked ICUs, China Patent, Granted, ZL202310151555.5" }
  @{ RelativePath = "achievements/index.html"; Marker = "Building Intelligent Fire Alarm and Escape System, China Software Copyright, Granted, 2020SR0296931" }
  @{ RelativePath = "achievements/index.html"; Marker = "USTC Outstanding Graduate 2024" }
  @{ RelativePath = "achievements/index.html"; Marker = "Anhui Province Outstanding Graduate 2021" }
  @{ RelativePath = "achievements/index.html"; Marker = "AHU Outstanding Graduate 2021" }
  @{ RelativePath = "experience-service/index.html"; Marker = "Remote Research Assistant" }
  @{ RelativePath = "experience-service/index.html"; Marker = "Research Intern" }
  @{ RelativePath = "experience-service/index.html"; Marker = "National College Student Innovation and Entrepreneurship Training Program" }
  @{ RelativePath = "experience-service/index.html"; Marker = "Teaching Assistant" }
  @{ RelativePath = "experience-service/index.html"; Marker = "Introduction to Artificial Intelligence @2025 Fall, HKUST (Guangzhou)" }
  @{ RelativePath = "experience-service/index.html"; Marker = "Conference Reviewers" }
  @{ RelativePath = "experience-service/index.html"; Marker = "AAAI 2027" }
  @{ RelativePath = "experience-service/index.html"; Marker = "AAAI 2026, ICML 2026" }
  @{ RelativePath = "experience-service/index.html"; Marker = "ICASSP 2025, ICME 2025" }
  @{ RelativePath = "experience-service/index.html"; Marker = "ICME 2024" }
  @{ RelativePath = "experience-service/index.html"; Marker = "Journal Reviewers" }
  @{ RelativePath = "experience-service/index.html"; Marker = "IEEE Network" }
  @{ RelativePath = "experience-service/index.html"; Marker = "IEEE Internet of Things Journal" }
  @{ RelativePath = "life/index.html"; Marker = "No moments have been added yet" }
)

foreach ($RequiredMarker in $RequiredMarkers) {
  Assert-Contains (Join-Path $SiteDirectory $RequiredMarker.RelativePath) $RequiredMarker.Marker
}

$HomePage = Join-Path $SiteDirectory "index.html"
Assert-AllowedHomeHeadings $HomePage
Assert-Matches $HomePage '(?is)<a\b[^>]*\bclass=["''][^"'']*\bprofile-email\b[^"'']*["''][^>]*\bhref=["'']mailto:lcao950@connect\.hkust-gz\.edu\.cn["''][^>]*>[^<]*lcao950@connect\.hkust-gz\.edu\.cn\s*</a>' "a .profile-email email element"

foreach ($DedicatedContent in ($RequiredMarkers |
    Where-Object { $_.RelativePath -in @("achievements/index.html", "experience-service/index.html", "life/index.html") } |
    Select-Object -ExpandProperty Marker)) {
  Assert-NotContains $HomePage $DedicatedContent
}

$DesktopStylesheet = Join-Path $SiteDirectory "assets/css/style-no-dark-mode.css"
Assert-Matches $DesktopStylesheet '(?s)\.profile-email\s*\{[^}]*white-space\s*:\s*nowrap' "a non-wrapping .profile-email rule"
