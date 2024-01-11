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
  
