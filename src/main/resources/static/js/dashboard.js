/**
 * SpendWise - Dashboard Script
 * Initializes dashboard widgets. Chart data wiring will be added
 * once the Analytics API endpoints are implemented in a later step.
 */

document.addEventListener('DOMContentLoaded', function () {
  animateStatCards();
});

/**
 * Adds a subtle entrance animation to the dashboard statistic cards.
 */
function animateStatCards() {
  const cards = document.querySelectorAll('.stat-card');

  cards.forEach(function (card, index) {
    card.style.opacity = '0';
    card.style.transform = 'translateY(8px)';

    setTimeout(function () {
      card.style.transition = 'opacity 300ms ease, transform 300ms ease';
      card.style.opacity = '1';
      card.style.transform = 'translateY(0)';
    }, index * 80);
  });
}
