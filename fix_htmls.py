import os
import re

top_bar_header_content = """    <!-- Top Bar -->
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
    </header>"""

footer_nav_content = """    <!-- Footer -->
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
    </nav>"""

def replace_in_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find the top bar <!-- Top Bar --> down to the end of </header>
    top_pattern = re.compile(r'<!-- Top Bar -->.*?</header>', re.DOTALL)
    
    new_content, count1 = top_pattern.subn(top_bar_header_content, content, count=1)

    # We will match from <!-- Footer --> to the end of <nav class="mobile-bottom-nav">...</nav>
    footer_pattern = re.compile(r'<!-- Footer -->.*?</body>', re.DOTALL)

    def replacer(match):
        return footer_nav_content + "\n</body>"
        
    new_content, count2 = footer_pattern.subn(replacer, new_content, count=1)
    
    # Alternatively some files might have script tags
    footer_pattern_script = re.compile(r'<!-- Footer -->.*?<script', re.DOTALL)
    def replacer_script(match):
        return footer_nav_content + "\n    <script"
        
    if count2 == 0:
        new_content, count2 = footer_pattern_script.subn(replacer_script, new_content, count=1)

    if count1 > 0 or count2 > 0:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {filepath}")

for root, _, files in os.walk('.'):
    # skip node_modules, assets, backup, dist etc
    if 'node_modules' in root or '.git' in root or 'assets' in root or 'css' in root or 'js' in root:
        continue
    for f in files:
        if f.endswith('.html'):
            replace_in_file(os.path.join(root, f))
