function updateTime() {
    const currentTime = new Date();
    const options = { weekday: 'long', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit' };
    const formattedTime = currentTime.toLocaleDateString('de', options);
    document.getElementById('current-time').innerText = formattedTime;
  }
  updateTime();
  setInterval(updateTime, 1000);
  
