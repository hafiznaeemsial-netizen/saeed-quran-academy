// Number Counter for Statistics
document.addEventListener('DOMContentLoaded', () => {
    const stats = document.querySelectorAll('.stat-item h3');

    const animateStats = () => {
        stats.forEach(stat => {
            const target = parseInt(stat.innerText.replace('+', '').replace(',', ''));
            const count = 0;
            const speed = 200;

            const updateCount = () => {
                const current = parseInt(stat.innerText.replace('+', '').replace(',', '')) || 0;
                const increment = target / speed;

                if (current < target) {
                    stat.innerText = Math.ceil(current + increment) + '+';
                    setTimeout(updateCount, 1);
                } else {
                    stat.innerText = target + '+';
                }
            };

            updateCount();
        });
    };

    // Trigger animation when scrolled into view
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                animateStats();
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.5 });

    const statsSection = document.querySelector('.stats');
    if (statsSection) {
        observer.observe(statsSection);
    }
});

// Smooth Scrolling for Navigation
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth'
            });
        }
    });
});

// Contact Form WhatsApp & Email Integration
const contactForm = document.getElementById('contactForm');
if (contactForm) {
    contactForm.addEventListener('submit', function (e) {
        // Get Form Data
        const name = document.getElementById('userName').value;
        const email = document.getElementById('userEmail').value;
        const phone = document.getElementById('userPhone').value;
        const course = document.getElementById('userCourse').value;
        const msg = document.getElementById('userMsg').value;

        // Construct WhatsApp Message
        const waMessage = `*New Student Registration - Sial Quranic Mastery Institute*%0A%0A` +
            `*Name:* ${name}%0A` +
            `*Email:* ${email}%0A` +
            `*Phone:* ${phone}%0A` +
            `*Course:* ${course}%0A` +
            `*Message:* ${msg}`;

        const waLink = `https://wa.me/923027480855?text=${waMessage}`;

        // Open WhatsApp in new tab
        window.open(waLink, '_blank');

        // The form will still submit to Formspree for Email notification
        // Note: Formspree will handle the success redirect/page
    });
}
