var thisCaption;
var thisModal;
var closeSpan;
var thisScrollX;
var thisScrollY;
var modalImage;
var thisImage;
var nList = {};

window.onload = function () {
  console.log('starting now...');
  initialize();
  console.log('off to go...');
};

function makeModalClosure(thisID) {
    return function() {
      openModal(thisID);
    };
}

function makeThumbnailClosure(thisSource, thisText) {
    return function() {
      modalImage.src = thisSource;
      thisImage.src = thisSource;
      thisCaption.innerText = thisText;
      thisCaption.appendChild(closeSpan);
    };
}

function openModal(thisID) {
  thisScrollX = window.scrollX;
  thisScrollY = window.scrollY;
  var body = document.getElementsByTagName('body')[0];
  body.style.overflow = "hidden";
  window.scrollTo(0, 0);
  thisModal.style.display = "block";
  thisModal.style.width = "100%";
  thisModal.style.height = "100%";
  thisImage = document.getElementById(thisID);
  modalImage = document.getElementById('modalImage');
  thisCaption.innerText = thisImage.alt;
  thisCaption.appendChild(closeSpan);
  modalImage.src = thisImage.src;

  var thisCRS = thisID.split("-").shift();
  var thumbnails = document.getElementById("thumbnails");
  for (var i in nList) {
    var modalTD = document.createElement('td');
    var modalIMG = document.createElement('img');
    var thisText = document.getElementById(thisCRS + "-" + i).alt;
    var thisSource = "images/topo-" + thisCRS + "-" + i + ".png";
    modalTD.className = "thumbnail";
    modalIMG.id = "tn-" + nList[i];
    modalIMG.src = thisSource;
    modalIMG.onclick = makeThumbnailClosure(thisSource, thisText);
    modalTD.appendChild(modalIMG);
    thumbnails.appendChild(modalTD);
  }
  var firstChild = thisModal.firstElementChild;
  firstChild.style.marginTop = ((window.innerHeight - firstChild.clientHeight) / 2) + "px";
  firstChild.style.marginLeft = ((window.innerWidth - firstChild.firstElementChild.clientWidth) / 2) + "px";
}

function initialize() {
    var images = document.getElementsByTagName('img');
    for (var i = 0; i < images.length; i++) {
	if(! images[i].src || images[i].src == "") continue;
	var thisID = images[i].src.split('\\').pop().split('/').pop().split('.').shift().replace('topo-', '');
	images[i].id = thisID;
	images[i].onclick = makeModalClosure(thisID);
	var this_tag = thisID.split('-').pop();
	if (! (this_tag in nList)) nList[this_tag] = 1 + Object.keys(nList).length;
    }

    var n = Object.keys(nList).length;
    var m = this_tag.split('_').shift()
    var markdown = document.getElementsByTagName('article')[0];
    var modalHTML  = document.createElement('div');
    modalHTML.id = "modal";
    modalHTML.className = 'modal-container';
    modalHTML.innerHTML = `<table>
    <tr>
        <th colspan="`+n+`">
            <div id="modal-caption"><span id="modal-close">&times;</span></div>
        </th>
    </tr>
    <tr class="modal-image">
        <td colspan="`+n+`">
            <div><img id="modalImage"></div>
        </td>
    </tr>
    <tr id="thumbnails">
    </tr>
</table>
<div id="legend-container">
   <img id="legendImage" src="`+m+`_legend.svg">
</div>`;

    markdown.appendChild(modalHTML);

    var body = document.getElementsByTagName('body')[0];
    thisCaption = document.getElementById('modal-caption');
    thisModal = document.getElementById('modal');
    thisImage = document.getElementById("modalImage");
    var thumbnails = document.getElementById("thumbnails");
    closeSpan = document.getElementById('modal-close');
    closeSpan.onclick = function() {
	body.style.height = "100%";
	body.style.overflow = "auto";
	thisModal.style.display = "none";
	markdown.style.overflow = "auto";
	window.scrollTo(thisScrollX, thisScrollY);
	while (thumbnails.firstElementChild)
	    thumbnails.removeChild(thumbnails.firstElementChild);
    };
}
