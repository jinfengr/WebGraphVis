<!DOCTYPE html>
<meta charset="utf-8">
<style>

body {
  font: 10px sans-serif;
  shape-rendering: crispEdges;
}

.day {
  fill: #fff;
  stroke: #ccc;
}

.month {
  fill: none;
  stroke: #000;
  stroke-width: 2px;
}


.contrib-legend{font-size:11px;color:#999;position:fixed;
    bottom:160px;
    left:50%;
    margin-left:-200px;}
.contrib-legend .legend{display:inline-block;list-style:none;margin:0 5px;position:relative;bottom:-1px}
.contrib-legend .legend li{display:inline-block;width:10px;height:10px}
.RdYlGn .q0{fill:#eee}
.RdYlGn .q1{fill:#d6e685}
.RdYlGn .q2{fill:#8cc665}
.RdYlGn .q3{fill:#44a340}
.RdYlGn .q4{fill:#1e6823}

</style>
<body>
<script src="http://d3js.org/d3.v3.min.js"></script>
<script>

var width = 960,
    height = 136,
    cellSize = 17; // cell size

var day = d3.time.format("%w"),
    week = d3.time.format("%U"),
    percent = d3.format(".1%"),
    format = d3.time.format("%Y%m%d");

var color = d3.scale.quantize()
    .domain([-0.15, 0.5])
    .range(d3.range(4).map(function(d) { return "q" + d; }));

var svg = d3.select("body").selectAll("svg")
    .data(d3.range(2003, 2006))
  .enter().append("svg")
    .attr("width", width)
    .attr("height", height)
    .attr("class", "RdYlGn")
  .append("g")
    .attr("transform", "translate(" + ((width - cellSize * 53) / 2) + "," + (height - cellSize * 7 - 1) + ")");

svg.append("text")
    .attr("transform", "translate(-6," + cellSize * 3.5 + ")rotate(-90)")
    .style("text-anchor", "middle")
    .text(function(d) { return d; });

var rect = svg.selectAll(".day")
    .data(function(d) { return d3.time.days(new Date(d, 0, 1), new Date(d + 1, 0, 1)); })
  .enter().append("rect")
    .attr("class", "day")
    .attr("width", cellSize)
    .attr("height", cellSize)
    .attr("x", function(d) { return week(d) * cellSize; })
    .attr("y", function(d) { return day(d) * cellSize; })
    .datum(format);

rect.append("title")
    .text(function(d) { return d; });

svg.selectAll(".month")
    .data(function(d) { return d3.time.months(new Date(d, 0, 1), new Date(d + 1, 0, 1)); })
  .enter().append("path")
    .attr("class", "month")
    .attr("d", monthPath);

d3.csv("./data/c108-histogram.csv", function(error, csv) {
  var max = 0;	
  csv.forEach(function(d){
	  if(max < +d.Pages){
		  max = +d.Pages;
	  }
  })
  
  var data = d3.nest()
    .key(function(d) { return d.Date; })
    .rollup(function(d) { return +d[0].Pages; })
    .map(csv);

  rect.filter(function(d) { return d in data; })
      .attr("class", function(d) { return "day " + color(data[d]*1.0/max); })
    .select("title")
      .text(function(d) { return d + ": " + data[d]; });
});

function monthPath(t0) {
  var t1 = new Date(t0.getFullYear(), t0.getMonth() + 1, 0),
      d0 = +day(t0), w0 = +week(t0),
      d1 = +day(t1), w1 = +week(t1);
  return "M" + (w0 + 1) * cellSize + "," + d0 * cellSize
      + "H" + w0 * cellSize + "V" + 7 * cellSize
      + "H" + w1 * cellSize + "V" + (d1 + 1) * cellSize
      + "H" + (w1 + 1) * cellSize + "V" + 0
      + "H" + (w0 + 1) * cellSize + "Z";
}

d3.select(self.frameElement).style("height", "2910px");

</script>
<br></br>
<div class="contrib-legend" title="Page numbers crawled by each day.">
  <span>Less</span>
  <ul class="legend">
    <li style="background-color: #eee"></li>
    <li style="background-color: #d6e685"></li>
    <li style="background-color: #8cc665"></li>
    <li style="background-color: #44a340"></li>
    <li style="background-color: #1e6823"></li>
  </ul>
  <span>More</span>
</div>
</body>