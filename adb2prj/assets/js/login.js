const signUpButton = document.getElementById('signUp');
const signInButton = document.getElementById('signIn');

signUpButton.addEventListener("click", signUpView);
signInButton.addEventListener("click", signInView);

function signUpView(){
    document.getElementById('login').classList.add('d-hidden');
    document.getElementById('register').classList.remove('d-hidden');
}

function signInView(){
    document.getElementById('register').classList.add('d-hidden');
    document.getElementById('login').classList.remove('d-hidden');
}