// app/assets/javascripts/custom.js
document.addEventListener('DOMContentLoaded', function() {
    // Verzögerung in Millisekunden
    const delay = 5000;
  
    // Ausblenden des Cursors nach der Verzögerung
    setTimeout(() => {
      document.body.classList.add('no-cursor');
  
      // Ereignislistener für die Bewegung der Maus hinzufügen
      document.addEventListener('mousemove', () => {
        // Cursor anzeigen
        document.body.classList.remove('no-cursor');
  
        // Timer zurücksetzen (optional)
        clearTimeout(resetTimer);
  
        // Neuen Timer für das erneute Ausblenden des Cursors starten
        resetTimer = setTimeout(() => {
          document.body.classList.add('no-cursor');
        }, delay);
      });
  
      // Timer für das erneute Ausblenden des Cursors starten
      let resetTimer = setTimeout(() => {
        document.body.classList.add('no-cursor');
      }, delay);
    }, delay);
  });
  


// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import 'bootstrap/dist/js/bootstrap';
