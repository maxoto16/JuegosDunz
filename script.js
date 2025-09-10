// JuegosDunz - Interactive JavaScript

document.addEventListener('DOMContentLoaded', function() {
    
    // Mobile Menu Toggle
    const menuToggle = document.querySelector('.menu-toggle');
    const navMenu = document.querySelector('.nav-menu');
    
    if (menuToggle && navMenu) {
        menuToggle.addEventListener('click', function() {
            navMenu.classList.toggle('active');
            menuToggle.classList.toggle('active');
        });
    }

    // Smooth Scrolling for Navigation Links
    const navLinks = document.querySelectorAll('a[href^="#"]');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                const headerHeight = document.querySelector('.header').offsetHeight;
                const targetPosition = targetElement.offsetTop - headerHeight - 20;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
                
                // Close mobile menu if open
                if (navMenu.classList.contains('active')) {
                    navMenu.classList.remove('active');
                    menuToggle.classList.remove('active');
                }
            }
        });
    });

    // Header Background Change on Scroll
    const header = document.querySelector('.header');
    
    window.addEventListener('scroll', function() {
        if (window.scrollY > 50) {
            header.style.background = 'rgba(255, 255, 255, 0.95)';
            header.style.backdropFilter = 'blur(10px)';
        } else {
            header.style.background = '#ffffff';
            header.style.backdropFilter = 'none';
        }
    });

    // Game Card Hover Effects
    const gameCards = document.querySelectorAll('.game-card');
    
    gameCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-10px) scale(1.02)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });

    // Animated Counter for Prices (on scroll)
    const observerOptions = {
        threshold: 0.5,
        rootMargin: '0px 0px -100px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
                
                // Add pulse animation to buy buttons
                const buyButtons = entry.target.querySelectorAll('.btn-primary');
                buyButtons.forEach(btn => {
                    btn.style.animation = 'pulse 2s infinite';
                });
            }
        });
    }, observerOptions);

    // Observe all game cards
    gameCards.forEach(card => {
        observer.observe(card);
    });

    // Add loading animation to buy buttons
    const buyButtons = document.querySelectorAll('.btn-primary');
    
    buyButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            // Don't prevent default since we want email to work
            const originalText = this.textContent;
            
            // Add loading state
            this.style.pointerEvents = 'none';
            this.innerHTML = '<span class="loading"></span> Abriendo...';
            
            // Reset after delay
            setTimeout(() => {
                this.textContent = originalText;
                this.style.pointerEvents = 'auto';
            }, 2000);
        });
    });

    // Parallax effect for hero section
    const hero = document.querySelector('.hero');
    
    if (hero) {
        window.addEventListener('scroll', function() {
            const scrolled = window.pageYOffset;
            const rate = scrolled * -0.5;
            
            hero.style.transform = `translateY(${rate}px)`;
        });
    }

    // Dynamic typing effect for hero title (optional enhancement)
    const heroTitle = document.querySelector('.hero h1');
    if (heroTitle) {
        const originalText = heroTitle.textContent;
        heroTitle.textContent = '';
        
        let i = 0;
        const typeWriter = function() {
            if (i < originalText.length) {
                heroTitle.textContent += originalText.charAt(i);
                i++;
                setTimeout(typeWriter, 100);
            }
        };
        
        // Start typing effect after a short delay
        setTimeout(typeWriter, 500);
    }

    // Add ripple effect to buttons
    function createRipple(event) {
        const button = event.currentTarget;
        const circle = document.createElement('span');
        const diameter = Math.max(button.clientWidth, button.clientHeight);
        const radius = diameter / 2;
        
        circle.style.width = circle.style.height = `${diameter}px`;
        circle.style.left = `${event.clientX - button.offsetLeft - radius}px`;
        circle.style.top = `${event.clientY - button.offsetTop - radius}px`;
        circle.classList.add('ripple');
        
        const ripple = button.getElementsByClassName('ripple')[0];
        if (ripple) {
            ripple.remove();
        }
        
        button.appendChild(circle);
    }

    // Add ripple CSS
    const rippleStyle = document.createElement('style');
    rippleStyle.textContent = `
        .btn {
            position: relative;
            overflow: hidden;
        }
        
        .ripple {
            position: absolute;
            border-radius: 50%;
            transform: scale(0);
            animation: ripple-animation 0.6s linear;
            background-color: rgba(255, 255, 255, 0.3);
        }
        
        @keyframes ripple-animation {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }
        
        .animate-in {
            animation: fadeInUp 0.8s ease forwards;
        }
    `;
    document.head.appendChild(rippleStyle);

    // Apply ripple effect to all buttons
    const allButtons = document.querySelectorAll('.btn, .cta-button, .contact-email');
    allButtons.forEach(button => {
        button.addEventListener('click', createRipple);
    });

    // Add floating animation to some elements
    const floatingElements = document.querySelectorAll('.game-image');
    
    floatingElements.forEach((element, index) => {
        element.style.animation = `float 3s ease-in-out ${index * 0.2}s infinite`;
    });

    // Add floating animation CSS
    const floatingStyle = document.createElement('style');
    floatingStyle.textContent = `
        @keyframes float {
            0%, 100% {
                transform: translateY(0px);
            }
            50% {
                transform: translateY(-5px);
            }
        }
    `;
    document.head.appendChild(floatingStyle);

    // Console welcome message
    console.log('%c🎮 Bienvenido a JuegosDunz!', 'color: #4a90e2; font-size: 20px; font-weight: bold;');
    console.log('%cSi eres desarrollador, ¡nos encantaría conocerte! Contacta: maxoto82@gmail.com', 'color: #7b68ee; font-size: 14px;');

    // Easter egg: Konami Code
    let konamiCode = [];
    const konamiSequence = ['ArrowUp', 'ArrowUp', 'ArrowDown', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'ArrowLeft', 'ArrowRight', 'KeyB', 'KeyA'];
    
    document.addEventListener('keydown', function(e) {
        konamiCode.push(e.code);
        
        if (konamiCode.length > konamiSequence.length) {
            konamiCode.shift();
        }
        
        if (konamiCode.length === konamiSequence.length && 
            konamiCode.every((code, index) => code === konamiSequence[index])) {
            
            // Easter egg activated!
            document.body.style.filter = 'hue-rotate(180deg)';
            
            const message = document.createElement('div');
            message.innerHTML = '🎉 ¡Código Konami activado! ¡Modo desarrollador desbloqueado!';
            message.style.cssText = `
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: linear-gradient(135deg, #4a90e2, #7b68ee);
                color: white;
                padding: 20px 40px;
                border-radius: 10px;
                z-index: 10000;
                font-size: 18px;
                font-weight: bold;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
                animation: bounce 1s ease;
            `;
            
            document.body.appendChild(message);
            
            setTimeout(() => {
                message.remove();
                document.body.style.filter = 'none';
            }, 3000);
            
            konamiCode = [];
        }
    });

    // Add bounce animation for easter egg
    const bounceStyle = document.createElement('style');
    bounceStyle.textContent = `
        @keyframes bounce {
            0%, 20%, 53%, 80%, 100% {
                transform: translate(-50%, -50%) translateY(0);
            }
            40%, 43% {
                transform: translate(-50%, -50%) translateY(-20px);
            }
            70% {
                transform: translate(-50%, -50%) translateY(-10px);
            }
            90% {
                transform: translate(-50%, -50%) translateY(-4px);
            }
        }
    `;
    document.head.appendChild(bounceStyle);

});

// Utility function to animate numbers (for future use)
function animateNumber(element, start, end, duration) {
    const startTime = performance.now();
    const difference = end - start;
    
    function updateNumber(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);
        
        const easedProgress = 1 - Math.pow(1 - progress, 3); // Ease out cubic
        const current = start + (difference * easedProgress);
        
        element.textContent = Math.floor(current);
        
        if (progress < 1) {
            requestAnimationFrame(updateNumber);
        }
    }
    
    requestAnimationFrame(updateNumber);
}

// Function to show notifications (for future enhancements)
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${type === 'success' ? '#4CAF50' : type === 'error' ? '#f44336' : '#2196F3'};
        color: white;
        padding: 15px 25px;
        border-radius: 5px;
        z-index: 1000;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        transform: translateX(400px);
        transition: transform 0.3s ease;
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.transform = 'translateX(0)';
    }, 100);
    
    setTimeout(() => {
        notification.style.transform = 'translateX(400px)';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}