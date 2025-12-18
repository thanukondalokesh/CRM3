window.onload = function() {
    let timeLeft = 120; 
    const timerDisplay = document.getElementById('timer');
    
    const timer = setInterval(() => {
        if (!timerDisplay) return; // safe check

        let minutes = Math.floor(timeLeft / 60);
        let seconds = timeLeft % 60;

        timerDisplay.textContent =
            `OTP expires in ${minutes}:${seconds < 10 ? '0' : ''}${seconds}`;

        if (timeLeft <= 0) {
            clearInterval(timer);
            timerDisplay.textContent = "OTP expired! Please click 'Resend OTP'.";
        }

        timeLeft--;
    }, 1000);
};
// verifyotp.js - optional timer placeholder; you may implement JS timer if you want
document.addEventListener('DOMContentLoaded', function(){
  // optional: you can render OTP expiry timestamp from CFML into JS to show countdown
});
