// loginpage.js - simple show/hide password
document.addEventListener('DOMContentLoaded', function() {
  const toggleLogin = document.getElementById('toggleLoginPassword');
  const loginPwd = document.getElementById('loginPassword');
  if (toggleLogin && loginPwd) {
    toggleLogin.addEventListener('click', function() {
      loginPwd.type = loginPwd.type === 'password' ? 'text' : 'password';
    });
  }
});
