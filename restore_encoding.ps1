$files = @(
    "article-kids-west-upbringing.html",
    "article-kids-western.html",
    "article-online-benefits.html",
    "article-online-learning-methods-en.html",
    "article-online-learning-methods.html",
    "article-online-tips.html",
    "article-quran-importance.html",
    "article-quran-science.html",
    "article-quran-success.html",
    "article-ramzan-reflection-en.html",
    "article-ramzan-reflection.html",
    "article-ramzan-tabdeeli.html",
    "article-spiritual-silence.html",
    "article-tajweed-global.html",
    "article-tajweed-importance-en.html",
    "article-tajweed-importance.html",
    "article-teach-quran-methods-en.html",
    "article-teach-quran-methods.html",
    "article-tears-mercy-en.html",
    "article-tears-mercy.html",
    "blog-en.html",
    "blog.html",
    "contact.html",
    "courses.html",
    "faqs.html",
    "gallery.html",
    "index.html",
    "pricing.html",
    "privacy-policy.html",
    "terms.html"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $corruptedText = Get-Content -Path $file -Raw -Encoding UTF8
        # Convert corrupted string back to bytes using window-1252 encoding which read it incorrectly
        $bytes = [Text.Encoding]::GetEncoding(1252).GetBytes($corruptedText)
        # Convert the bytes back to a UTF8 string
        $restoredText = [Text.Encoding]::UTF8.GetString($bytes)
        
        [IO.File]::WriteAllText($file, $restoredText, [System.Text.Encoding]::UTF8)
        Write-Host "Restored $file"
    }
}
