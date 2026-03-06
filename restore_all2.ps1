$files = Get-ChildItem -Path . -Filter "*.html"

foreach ($file in $files) {
    if (Test-Path $file.FullName) {
        $corruptedText = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        
        # We check if trying to get bytes as 1252 then UTF-8 results in a valid string.
        # But wait, we can just look at the characters: "Ã" or "Ø" or "Ù"
        if ($corruptedText -match "Ø|Ù|Ú|Ã") {
            try {
                $bytes = [Text.Encoding]::GetEncoding(1252).GetBytes($corruptedText)
                
                # Check if valid utf-8 without throwing exceptions
                $utf8 = New-Object System.Text.UTF8Encoding $false, $true
                $restoredText = $utf8.GetString($bytes)
                
                [IO.File]::WriteAllText($file.FullName, $restoredText, [System.Text.Encoding]::UTF8)
                Write-Host "Restored $($file.Name)"
            } catch {
                Write-Host "Failed to restore $($file.Name): $_"
            }
        } else {
            Write-Host "Skipped $($file.Name)"
        }
    }
}
