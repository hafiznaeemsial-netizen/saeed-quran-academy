$topBarHeaderContent = @'
    <!-- Top Bar -->
    <div style="background: var(--primary-dark); color: white; padding: 5px 0; font-size: 0.8rem;">
        <div class="container" style="display: flex; justify-content: space-between;">
            <div>
                <i class="fas fa-phone"></i> <span class="phone-number">+92 302 7480855</span> | <i
                    class="fas fa-envelope"></i> hafiznaeemsial@gmail.com
            </div>
            <div class="urdu">
                <i class="fas fa-language"></i> <a href="blog.html" style="color:var(--secondary-color)">اردو</a> | <a
                    href="blog-en.html" style="color:var(--secondary-color)">English</a>
            </div>
        </div>
    </div>

    <!-- Navigation -->
    <header>
        <div class="container navbar">
            <div class="logo">
                <div class="logo-text">
                    <h1>Saeed Quran Academy</h1>
                    <span class="urdu">سعید قرآن اکیڈمی</span>
                </div>
            </div>
            <nav class="nav-links">
                <a href="index.html">Home</a>
                <a href="about.html">About</a>
                <a href="blog.html">Urdu Blog</a>
                <a href="blog-en.html">English Blog</a>
                <a href="pricing.html">Fees</a>
                <a href="contact.html">Contact</a>
            </nav>
            <a href="contact.html" class="nav-cta">Free Trial Class</a>
        </div>
    </header>
'@

$footerNavContent = @'
    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-grid">
                <div class="footer-col" style="text-align: left;">
                    <h1 style="color: var(--secondary-color); font-size: 1.5rem;">Saeed Quran Academy</h1>
                    <p style="margin-top: 15px;">A leading international online Quran academy dedicated to spreading the
                        light of Quranic education globally.</p>
                </div>
                <div class="footer-col" style="text-align: left;">
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="index.html">Home</a></li>
                        <li><a href="courses.html">Our Courses</a></li>
                        <li><a href="pricing.html">Fee Structure</a></li>
                        <li><a href="contact.html">Contact Us</a></li>
                    </ul>
                </div>
                <div class="footer-col" style="text-align: left;">
                    <h4>Our Courses</h4>
                    <ul>
                        <li><a href="courses.html">Noorani Qaida</a></li>
                        <li><a href="courses.html">Quran with Tajweed</a></li>
                        <li><a href="courses.html">Quran Translation</a></li>
                        <li><a href="courses.html">Hifz Program</a></li>
                    </ul>
                </div>
                <div class="footer-col" style="text-align: left;">
                    <h4>Contact Us</h4>
                    <p><i class="fas fa-map-marker-alt"></i> Dehli Gate Multan, Pakistan</p>
                    <p style="margin-top: 10px;"><i class="fas fa-phone"></i> <span class="phone-number">+92 302
                            7480855</span></p>
                    <p style="margin-top: 10px;"><i class="fas fa-envelope"></i> hafiznaeemsial@gmail.com</p>
                    <div style="display: flex; gap: 15px; margin-top: 20px;">
                        <a href="https://web.facebook.com/SaeedQuranAcademy" target="_blank"><i
                                class="fab fa-facebook"></i></a>
                        <a href="https://www.youtube.com/@SaeedQuranAcademy" target="_blank"><i
                                class="fab fa-youtube"></i></a>
                    </div>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2026 Saeed Quran Academy. All Rights Reserved.</p>
                <div style="margin-top: 10px;">
                    <a href="privacy-policy.html"
                        style="color: #ccc; margin: 0 10px; font-size: 0.8rem; text-decoration: none;">Privacy
                        Policy</a>
                    <a href="terms.html"
                        style="color: #ccc; margin: 0 10px; font-size: 0.8rem; text-decoration: none;">Terms of
                        Service</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Mobile Bottom Navigation -->
    <nav class="mobile-bottom-nav">
        <a href="index.html"><i class="fas fa-home"></i>Home</a>
        <a href="about.html"><i class="fas fa-info-circle"></i>About</a>
        <a href="blog.html"><i class="fas fa-blog"></i>Urdu</a>
        <a href="blog-en.html"><i class="fas fa-globe"></i>English</a>
        <a href="pricing.html"><i class="fas fa-tags"></i>Fees</a>
        <a href="contact.html"><i class="fas fa-envelope"></i>Contact</a>
    </nav>
'@

Get-ChildItem -Path . -Filter "*.html" | ForEach-Object {
    $content = Get-Content -Raw -Path $_.FullName
    
    # Replace the top bar and header
    $pattern1 = '(?s)<!-- Top Bar -->.*?</header>'
    $newContent = [regex]::Replace($content, $pattern1, $topBarHeaderContent)

    # Replace the footer and mobile nav
    $pattern2 = '(?s)<!-- Footer -->.*?</nav>'
    $newContent = [regex]::Replace($newContent, $pattern2, $footerNavContent)

    # Note: On some files, there might be '<!-- Mobile Navigation -->' instead.
    # So we replace up to </footer> or </nav> safely using a slightly larger block or loop:
    # Actually, the regex with .*?</nav> could swallow too much if there are multiple navs afterwards. Let's do a more robust string match or multiple replacements.
    
    $pattern3 = '(?s)<!-- Footer.*?<!-- Mobile [^>]*Navigation -->.*?</nav>'
    $newContent2 = [regex]::Replace($newContent, $pattern3, $footerNavContent)

    if ($newContent2 -eq $newContent -and $newContent -notmatch $pattern2) {
        $pattern4 = '(?s)<!-- Footer -->.*?</footer>'
        $newContent2 = [regex]::Replace($newContent, $pattern4, $footerNavContent)
    } elseif ($newContent2 -eq $newContent) {
        $newContent2 = [regex]::Replace($newContent, '(?s)<!-- Footer -->.*?</nav>', $footerNavContent)
    }
    
    # If the footer replacement leaves out Mobile Navigation incorrectly, we fix it by standardizing to just $footerNavContent before </body>
    $contentForFooter = $newContent2 -replace '(?s)<!-- Footer -->.*?</body>', "$footerNavContent`n</body>"
    $contentForFooter = $contentForFooter -replace '(?s)<!-- Footer -->.*?<script src="js/main.js"></script>', "$footerNavContent`n    <script src=`"js/main.js`"></script>"

    [IO.File]::WriteAllText($_.FullName, $contentForFooter, [Text.Encoding]::UTF8)
    Write-Host "Updated $($_.Name)"
}
