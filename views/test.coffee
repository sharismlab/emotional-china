@title = 'Test import d3'
@scripts = [
             "d3/d3",
             "d3/d3.layout",
             "d3/d3.geom"
]

body ->
  p 'd3 library loaded...'
  div id: 'chart'
  script '''
var w = 960,
    h = 500,
    fill = d3.scale.category10(),
    nodes = d3.range(100).map(Object);

var vis = d3.select("#chart").append("svg")
    .attr("width", w)
    .attr("height", h);

var force = d3.layout.force()
    .nodes(nodes)
    .links([])
    .size([w, h])
    .start();

var node = vis.selectAll("circle.node")
    .data(nodes)
  .enter().append("circle")
    .attr("class", "node")
    .attr("cx", function(d) { return d.x; })
    .attr("cy", function(d) { return d.y; })
    .attr("r", 8)
    .style("fill", function(d, i) { return fill(i & 3); })
    .style("stroke", function(d, i) { return d3.rgb(fill(i & 3)).darker(2); })
    .style("stroke-width", 1.5)
    .call(force.drag);

vis.style("opacity", 1e-6)
  .transition()
    .duration(1000)
    .style("opacity", 1);

force.on("tick", function(e) {

  // Push different nodes in different directions for clustering.
  var k = 6 * e.alpha;
  nodes.forEach(function(o, i) {
    o.x += i & 2 ? k : -k;
    o.y += i & 1 ? k : -k;
  });

  node.attr("cx", function(d) { return d.x; })
      .attr("cy", function(d) { return d.y; });
});

d3.select("body").on("click", function() {
  nodes.forEach(function(o, i) {
    o.x += (Math.random() - .5) * 40;
    o.y += (Math.random() - .5) * 40;
  });
  force.resume();
});


'''    