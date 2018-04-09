
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

function underlineText (id){
  switch(id){
    case 0:
      $("#mh-source-text").css("text-decoration", "underline");
      break;
    case 1:
      $("#mh-all-text").css("text-decoration", "underline");
      break;
    case 2:
      $("#mh-pdf-text").css("text-decoration", "underline");
      break;
  }

}

function notUnderlineText (id){
  switch(id){
    case 0:
      $("#mh-source-text").css("text-decoration", "none");
      break;
    case 1:
      $("#mh-all-text").css("text-decoration", "none");
      break;
    case 2:
      $("#mh-pdf-text").css("text-decoration", "none");
      break;
  }
  
}

//document.getElementById("myLink").click();

/*

border-style: solid;
  border-color: #fdcc77;
    border-width: 5px;
    
*/