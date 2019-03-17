var images = document.getElementsByTagName('img');
var nList = {};
nList = [];
for(var i = 0; i < images.length; i++) {
    if(! images[i].src) continue;
    var thisID = images[i].src.split('\\').pop().split('/').pop().split('.').shift().replace('topo-', '');
    images[i].id = thisID;
    images[i].onclick = makeModalClosure(thisID);
    var this_tag = thisID.split('-').pop();
    nList[this_tag] = 1;
}
var z = Object.keys(nList).length;
var theseColumns = document.getElementsByClassName("column");
for(i=0; i < theseColumns.length; i++) {
    theseColumns[i].style.width = 0;
    if( i < z) {
	theseColumns[i].style.width = 100 / z + "%";
    }
}

var markdown = document.getElementsByTagName('article')[0];
var modal = document.getElementById('Modal');
var modalImage = document.getElementById('image');
var captionText = document.getElementById('caption');

function makeModalClosure(thisID) {
    return function() {
        openModal(thisID);
    };
}
function openModal(thisID) {
    var thisImage = document.getElementById(thisID);
    modal.style.display = "block";
    modalImage.src = thisImage.src;
    captionText.innerHTML = thisImage.alt;
    modalImage.height = window.innerHeight;
    modal.style.left = (window.innerWidth - modal.clientWidth) / 2 - markdown.offsetTop;
    var z = Object.keys(nList).length;
    var thisCRS = thisImage.id.split('-').shift();
    for(var n in nList) {
	var thisImageID = thisCRS + "-" + n;
	var thisNID = n.split('_').pop();
        var thumbnail = document.getElementById('thumb-' + thisNID);
	thumbnail.src = "images/topo-" + thisImageID + ".png";
	thumbnail.onclick = makeModalClosure(thisImageID);
	thumbnail.alt = "thumbnail: " + document.getElementById(thisImageID).alt;
    };
}
var span = document.getElementsByClassName("close")[0];
span.onclick = function() {
    modal.style.display = "none";
    markdown.style.overflow = "auto";
}

