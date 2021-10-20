const btn = document.getElementById('theme');
const body = document.getElementById('body');

const toggle = {
  dark: 'light',
  light: 'dark',
};

const setTheme = (ev) => {
  const value = ev.target.innerText;
  body.setAttribute('data-theme', value);
  btn.innerText = toggle[value];
  localStorage.setItem('rodolfo-blog-theme', value);
};

btn.addEventListener('click', setTheme);
