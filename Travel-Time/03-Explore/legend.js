function setSVGheight(h) {
  console.log(h);
  var thisSVG = document.getElementById('legend-svg').firstElementChild;
  thisSVG.setAttribute('height', h);
  return h;
}

function setSVGunit(u) {
  var thisSVG = document.getElementById('legend-txt');
  thisSVG.setAttribute('x', 64);
  thisSVG.setAttribute('y', 15);
  thisSVG.textContent = 'Time [' + u + ']';
  return true;
}

function updateSVG(mTime, mDuration) {
  var quantize = d3.scaleSequential([mDuration, mTime], function(t) { return d3.interpolateViridis(1.0 - t)});
  var nCell = mTime / mDuration;
  var svg = d3.select("svg");      
  svg.append("g")
	  .attr("class", "legend")
	  .attr("transform", "translate(20, 20)");

  var fString = "d";
  if (mDuration < 1.0) {
    fString = ".01f";
  }
  var legend = d3.legendColor()
	    .labelFormat(d3.format(fString))
	    .labelOffset(30)
	    .cells(nCell)
	    .scale(quantize);
  svg.select(".legend")
	  .call(legend);
  return true;
}
