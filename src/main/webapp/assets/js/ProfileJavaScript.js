function enableEdit(fieldId) {
    document.getElementById(fieldId).removeAttribute('disabled');
}

function enableFields(){
    document.getElementById('name').removeAttribute('disabled');
    document.getElementById('email').removeAttribute('disabled');
    document.getElementById('password').removeAttribute('disabled');
    document.getElementById('contact').removeAttribute('disabled');
    document.getElementById('address').removeAttribute('disabled');
}