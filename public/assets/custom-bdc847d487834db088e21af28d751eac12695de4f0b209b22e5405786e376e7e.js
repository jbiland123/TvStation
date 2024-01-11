// app/assets/javascripts/custom.js
document.addEventListener('DOMContentLoaded', function() {
    // Verzögerung in Millisekunden
    const delay = 5000;
  
    // Ausblenden des Cursors nach der Verzögerung
    setTimeout(() => {
      document.body.style.cursor = 'none';
  
      // Ereignislistener für die Bewegung der Maus hinzufügen
      document.addEventListener('mousemove', () => {
        // Cursor anzeigen
        document.body.style.cursor = 'auto';
  
        // Timer zurücksetzen (optional)
        clearTimeout(resetTimer);
  
        // Neuen Timer für das erneute Ausblenden des Cursors starten
        resetTimer = setTimeout(() => {
          document.body.style.cursor = 'none';
        }, delay);
      });
  
      // Timer für das erneute Ausblenden des Cursors starten
      let resetTimer = setTimeout(() => {
        document.body.style.cursor = 'none';
      }, delay);
    }, delay);
  });
  
