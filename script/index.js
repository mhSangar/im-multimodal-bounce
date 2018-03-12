
function openMenu(evt, menuName) {
  var i, x, tablinks;
  x = document.getElementsByClassName("menu");
  for (i = 0; i < x.length; i++) {
     x[i].style.display = "none";
  }
  tablinks = document.getElementsByClassName("tablink");
  for (i = 0; i < x.length; i++) {
     tablinks[i].className = tablinks[i].className.replace(" w3-dark-grey", "");
  }
  document.getElementById(menuName).style.display = "block";
  evt.currentTarget.firstElementChild.className += " w3-dark-grey";
}

function underlineText (){
  document.getElementById("mh-img-text").style.textDecoration = "underline";
}

function notUnderlineText (){
  document.getElementById("mh-img-text").style.textDecoration = "";
}

document.getElementById("myLink").click();

/*

border-style: solid;
  border-color: #fdcc77;
    border-width: 5px;
    
*/