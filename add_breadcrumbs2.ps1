$files = Get-ChildItem -Path . -Filter "article-*.html"

foreach ($file in $files) {
    if ($file.Name -match "teach-quran") {
        continue # Already done
    }

    $content = Get-Content -Raw -Path $file.FullName -Encoding UTF8
    
    # Extract the h1 text for the breadcrumb title
    $h1Text = ""
    if ($content -match '(?i)<h1[^>]*>(.*?)</h1>') {
        $h1Text = $matches[1] -replace '<[^>]+>', '' # remove any inner tags if present
        $h1Text = $h1Text.Trim()
    }

    if ($h1Text -eq "") {
        continue
    }

    # Determine if English or Urdu
    $isEnglish = ($file.Name -match '-en\.html$') -or ($content -match 'lang="en"')
    if ($file.Name -match 'article-kids-western.html' -or $file.Name -match 'online-learning-methods.html' -or $file.Name -match 'tajweed-importance.html' -or $file.Name -match 'ramzan-reflection.html' -or $file.Name -match 'tears-mercy.html' -or $file.Name -match 'kids-western') {
        # Check by content 
    }
    
    if ($content -match '<html lang="ur"') {
        $isEnglish = $false
    } elseif ($content -match '<html lang="en"') {
        $isEnglish = $true
    }

    if ($isEnglish) {
        $breadcrumb = @"
            <!-- Breadcrumbs -->
            <div style="margin-bottom: 20px; font-size: 0.9rem; color: #666;">
                <a href="index.html" style="color: var(--primary-color); text-decoration: none;">Home</a> 
                <i class="fas fa-chevron-right" style="font-size: 0.7rem; margin: 0 5px;"></i> 
                <a href="blog-en.html" style="color: var(--primary-color); text-decoration: none;">English Blog</a> 
                <i class="fas fa-chevron-right" style="font-size: 0.7rem; margin: 0 5px;"></i> 
                <span style="color: #999;">$h1Text</span>
            </div>
"@
    } else {
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
    }

    if ($content -notmatch '<!-- Breadcrumbs -->') {
        # Try to find common wrappers
        $pattern = '(<(div|article)[^>]*max-width:\s*\d+px[^>]*>\s*)'
        if ($content -match $pattern) {
            $replacement = "`$1$breadcrumb`n"
            $newContent = $content -replace $pattern, $replacement
            [IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
            Write-Host "Added breadcrumb to $($file.Name)"
        } else {
            Write-Host "Warning: Could not find insert spot in $($file.Name)"
        }
    } else {
        Write-Host "Breadcrumb already exists in $($file.Name)"
    }
}
