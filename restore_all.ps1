$files = Get-ChildItem -Path . -Filter "*.html"

foreach ($file in $files) {
    if (Test-Path $file.FullName) {
        $corruptedText = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        
        # Check if the text is corrupted by looking for common mojibake characters like Ø or Ú
        if ($corruptedText -match 'Ø|Ú') {
            # Convert corrupted string back to bytes using window-1252 encoding which read it incorrectly
            $bytes = [Text.Encoding]::GetEncoding(1252).GetBytes($corruptedText)
            # Convert the bytes back to a UTF8 string
            $restoredText = [Text.Encoding]::UTF8.GetString($bytes)
            
            [IO.File]::WriteAllText($file.FullName, $restoredText, [System.Text.Encoding]::UTF8)
            Write-Host "Restored $($file.Name)"
        } else {
            Write-Host "Skipped $($file.Name) (Not obviously corrupted)"
        }
    }
}
