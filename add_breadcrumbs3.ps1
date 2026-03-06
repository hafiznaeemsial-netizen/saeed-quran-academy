$files = @("article-quran-importance.html", "article-spiritual-silence.html")
foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content -Raw -Path $file -Encoding UTF8
        $h1Text = ""
        if ($content -match '(?i)<h1[^>]*>(.*?)</h1>') {
            $h1Text = $matches[1] -replace '<[^>]+>', ''
            $h1Text = $h1Text.Trim()
        }
        $breadcrumb = @"
            <!-- Breadcrumbs -->
            <div class="urdu" style="margin-bottom: 20px; font-size: 0.9rem; color: #666; text-align: right;">
                <a href="index.html" style="color: var(--primary-color); text-decoration: none;">ہوم</a> 
                <i class="fas fa-chevron-left" style="font-size: 0.7rem; margin: 0 5px;"></i> 
                <a href="blog.html" style="color: var(--primary-color); text-decoration: none;">اردو بلاگ</a> 
                <i class="fas fa-chevron-left" style="font-size: 0.7rem; margin: 0 5px;"></i> 
                <span style="color: #999;">$h1Text</span>
            </div>
"@
        if ($content -notmatch '<!-- Breadcrumbs -->') {
            $pattern = '(<article[^>]*>)'
            $replacement = "`$1`n$breadcrumb"
            $newContent = $content -replace $pattern, $replacement
            [IO.File]::WriteAllText($file, $newContent, [System.Text.Encoding]::UTF8)
            Write-Host "Added $file"
        }
    }
}
