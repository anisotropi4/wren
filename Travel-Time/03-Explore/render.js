function svgLegendClosure(legend, parameters) {
  var [mTime, mDuration, mHeight, mUnit] = parameters;
  return (async function() {
	  const instance = await phantom.create();
	  const page = await instance.createPage();
	  await page.property('viewportSize', { width: 100, height: 600 });
	  const status = await page.open('legend.html');
	  console.log(`Page opened with status [${status}].`);
	  const fs = require('fs');
    console.log(`Set SVG height ${mHeight}.`);

    await page.evaluate(function(h) {
      setSVGheight(h);      
    }, mHeight);    
    console.log(`Set time unit ${mUnit}.`);
    await page.evaluate(function(u) {
      setSVGunit(u);
    }, mUnit);
    console.log(`Render SVG legend ${mTime} in ${mDuration} ${mUnit} blocks.`);
    await page.evaluate(function(t, n) {
      updateSVG(t, n);
      return document.getElementById('legend-svg').innerHTML;
    }, mTime, mDuration).then(function(html){
	    console.log(`Writing ${legend}_legend.svg`);
	    var fp = fs.createWriteStream(`${legend}_legend.svg`, {'flags': 'w+'});
	    fp.write(html, (err) => {
		    if (err) throw err;
	    });
	  });
	  await instance.exit();
  })();
}

const phantom = require('phantom');
const legends = {"HW": [450, 30, 340, 'm'], "PT": [720, 30, 530, 'm'], "HW2": [7.5, 0.5, 340, 'h'], "PT2": [12, 0.5, 530, 'h']};
for (var k in legends) {
  svgLegendClosure(k, legends[k]);
}
