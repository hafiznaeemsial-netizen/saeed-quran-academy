$files = @(
    "about.html",
    "article-8th-sehri.html",
    "article-dua-patience.html",
    "article-hidden-virtues-en.html",
    "article-hidden-virtues.html",
    "article-hifz-benefits-en.html",
    "article-hifz-benefits.html",
    "article-kids-prayer.html",
    "article-kids-upbringing.html"
)
foreach ($file in $files) {
    if (Test-Path $file) {
        $corruptedText = Get-Content -Path $file -Raw -Encoding UTF8
        $bytes = [Text.Encoding]::GetEncoding(1252).GetBytes($corruptedText)
        $restoredText = [Text.Encoding]::UTF8.GetString($bytes)
        [IO.File]::WriteAllText($file, $restoredText, [System.Text.Encoding]::UTF8)
        Write-Host "Restored $file"
    }
}
