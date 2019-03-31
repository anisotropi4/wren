const header = `<?xml version="1.0" encoding="utf-8"?>\
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">`;

function svgClosure(legend) {
    return (async function() {
	const instance = await phantom.create();
	const page = await instance.createPage();
	await page.property('viewportSize', { width: 100, height: 600 });
	const status = await page.open(`${legend}_legend.html`);
	console.log(`Page opened with status [${status}].`);
	const fs = require('fs');
	await page.evaluate(function() {
	    return document.getElementById('legend-svg').innerHTML;
	}).then(function(html){
	    console.log(`Writing ${legend}_legend.svg`);
	    var fp = fs.createWriteStream(`${legend}_legend.svg`, {'flags': 'w+'});
	    fp.write(header, (err) => {
		if (err) throw err;
	    });
	    fp.write(html, (err) => {
		if (err) throw err;
	    });
	});
	await instance.exit();
    })();
}

const phantom = require('phantom');
const legends = ["HW", "PT"];
for (var i=0; i < legends.length; i++) {
    var thisLegend = legends[i];
    svgClosure(thisLegend);
}
