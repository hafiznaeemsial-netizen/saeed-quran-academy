$files = Get-ChildItem -Path . -Filter "article-*.html"

foreach ($file in $files) {
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
    $isEnglish = $file.Name -match '-en\.html$'
    if ($file.Name -eq 'article-kids-western.html') { $isEnglish = $false } # just in case, but usually en has -en
    
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
            <div class="urdu" style="margin-bottom: 20px; font-size: 0.9rem; color: #666;">
                <a href="index.html" style="color: var(--primary-color); text-decoration: none;">ہوم</a> 
                <i class="fas fa-chevron-left" style="font-size: 0.7rem; margin: 0 5px;"></i> 
                <a href="blog.html" style="color: var(--primary-color); text-decoration: none;">اردو بلاگ</a> 
                <i class="fas fa-chevron-left" style="font-size: 0.7rem; margin: 0 5px;"></i> 
                <span style="color: #999;">$h1Text</span>
            </div>
"@
    }

    # Check if breadcrumbs are already added
    if ($content -notmatch '<!-- Breadcrumbs -->') {
        # We need to insert it right after <div style="max-width: 950px; margin: 0 auto;">
        # Regex to find that exact line (or close to it)
        $pattern = '(<div[^>]*max-width:\s*950px[^>]*>\s*)'
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
