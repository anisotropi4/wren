function update_svg(mTime, nCell) {
    var quantize = d3.scaleSequential([30, mTime], function(t) { return d3.interpolateViridis(1.0 - t)});

    var svg = d3.select("svg");      
    svg.append("g")
	.attr("class", "legend")
	.attr("transform", "translate(20, 20)");

    var legend = d3.legendColor()
	.labelFormat(d3.format("d"))
	.labelOffset(40)
	.cells(nCell)
	.scale(quantize);

    svg.select(".legend")
	.call(legend);
}
