var r1 = 650 / 2,
    r0 = r1 - 120;

// console.log(matrix);

var feelings = d3.scale.ordinal()
    .range ([
	'谨慎小心翼翼',
	'安详和美静谧',
	'恳切诚恳感谢',
	'感叹赞叹慨叹',
	'欣赏佩服羡慕',
	'好奇新鲜惊异',
	'想念愿望憧憬',
	'恍惚不定迷茫',
	'惭愧懊悔内疚',
	'轻蔑鄙视看不起',
	'喜爱爱慕好感',
	'嫉妒嫉恨妒恨',
	'凶狠强悍暴烈',
	'惧怕惊悚恐怖',
	'怪罪愤怒气恼',
	'悲伤哀恸痛心',
	'焦虑烦躁慌张',
	'愁苦郁闷难受',
	'忍耐厌恶怨恨',
	'不解疑惑疑问',
	'怜惜恻悯惋惜',
	'快乐欢欣愉悦'
])

var matrix = [
	[0,  3,  2,  3,  2,  2,  2,  3,  0,  0,  0, -2, -2, -2, -3, -3, -3, -3, -2, -2, -2, -1],
	[3,  0,  3,  2,  3,  1,  1,  2,  0,  0,  0, -1, -1, -1, -2, -2, -2, -2,  0, -1, -1, -1],
	[2,  3,  0,  1,  1,  1,  1,  1,  0,  0,  0, -1, -1, -1, -2, -2, -2, -2, -1, -1, -1, -1],
	[3,  2,  1,  0,  1,  1,  1,  1,  0,  0,  0, -1, -1, -1, -2, -2, -2, -2, -1, -1, -1, -1],
	[2,  3,  1,  1,  0,  1,  1,  1,  0,  0,  0, -1, -1, -1, -2, -2, -2, -2, -1, -1, -1, -1],
	[2,  1,  1,  1,  1,  0,  1,  1,  0,  0,  0, -1, -1, -1, -2, -2, -2, -2, -1, -1, -1, -1],
	[2,  1,  1,  1,  1,  1,  0,  1,  0,  0,  0, -1, -1, -1, -2, -2, -2, -2, -1, -1, -1, -1],
	[3,  2,  1,  1,  1,  1,  1,  0,  0,  0,  0, -2, -2, -2, -3, -3, -3, -3, -2, -2, -2, -2],
	[0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -2, -2, -2, -2, -1, -1, -1, -1],
	[0,  0,  0,  0,  0,  0,  0,  0, -1,  0, -1, -1, -1, -1, -2, -2, -2, -2, -1, -1, -1, -1],
	[0,  0,  0,  0,  0,  0,  0,  0, -1, -1,  0, -1, -1, -1, -2, -2, -2, -2, -1, -1, -1,  0],
	[-2, -1, -1, -1, -1, -1, -1, -2, -1, -1, -1,  0,  3,  3,  3,  3,  2,  2,  1,  1,  1,  0],
	[-2, -1, -1, -1, -1, -1, -1, -2, -1, -1, -1,  3,  0,  3,  3,  2,  2,  2,  1,  1,  1,  0],
	[-2, -1, -1, -1, -1, -1, -1, -2, -1, -1, -1,  3,  3,  0,  3,  2,  2,  2,  1,  1,  1,  0],
	[-3, -2, -2, -2, -2, -2, -2, -3, -2, -2, -2,  3,  3,  3,  0,  3,  3,  3,  1,  1,  1,  0],
	[-3, -2, -2, -2, -2, -2, -2, -3, -2, -2, -2,  3,  2,  2,  3,  0,  3,  3,  1,  1,  1,  0],
	[-3, -2, -2, -2, -2, -2, -2, -3, -2, -2, -2,  2,  2,  2,  3,  3,  0,  3,  1,  1,  0,  0],
	[-3, -2, -2, -2, -2, -2, -2, -3, -2, -2, -2,  2,  2,  2,  3,  3,  3,  0,  1,  1,  0,  0],
	[-2,  0, -1, -1, -1, -1, -1, -2, -1, -1, -1,  1,  1,  1,  1,  1,  1,  1,  0,  3,  0,  0],
	[-2, -1, -1, -1, -1, -1, -1, -2, -1, -1, -1,  1,  1,  1,  1,  1,  1,  1,  3,  0,  0,  0],
	[-2, -1, -1, -1, -1, -1, -1, -2, -1, -1, -1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  2],
	[-1, -1, -1, -1, -1, -1, -1, -2, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  2,  0]
    ];

matrix.forEach(function(element, i, array) {
	array[i].forEach(function(element, i, array) {
		//console.log(array[i]);
		array[i] = array[i]+3
	});
})

//console.log(matrix)


var chord = d3.layout.chord()
    .padding(.04)
    .sortSubgroups(d3.descending)
    .sortChords(d3.descending)
    .matrix(matrix);

var fill = d3.scale.category20();

var arc = d3.svg.arc()
    .innerRadius(r0)
    .outerRadius(r0 + 22);

var svg = d3.select("#chart").append("svg:svg")
    .attr("width", r1 * 2)
    .attr("height", r1 * 2)
  .append("svg:g")
    .attr("transform", "translate(" + r1 + "," + r1 + ")");


var g = svg.selectAll("g.group")
      .data(chord.groups)
    .enter().append("svg:g")
      .attr("class", "group");

 g.append("svg:path")
      .style("fill", function(d) { return fill(d.index); })
      .style("stroke", function(d) { return fill(d.index); })
      .attr("d", arc)
      .on("mousedown", function(d) {
		d3.select('#feeling-name').html(feelings(d.index));
	} )// 
      .on("mouseout", fade(1))
      .on("mouseover", fade(0.1));


 g.append("svg:text")
      .each(function(d) { d.angle = (d.startAngle + d.endAngle) / 2; })
      .attr("dy", "1em")
      .attr("text-anchor", function(d) { return d.angle > Math.PI ? "end" : null; })
      .attr("transform", function(d) {
        return "rotate(" + (d.angle * 180 / Math.PI - 90) + ")"
            + "translate(" + (r0 + 26) + ")"
            + (d.angle > Math.PI ? "rotate(180)" : "");
      })
      .text(function(d) { return feelings(d.index); });

 svg.selectAll("path.chord")
      .data(chord.chords)
    .enter().append("svg:path")
      .attr("class", "chord")
      .style("stroke", function(d) { return d3.rgb(fill(d.source.index)).darker(); })
      .style("fill", function(d) { return fill(d.source.index); })
      .attr("d", d3.svg.chord().radius(r0))


/** Returns an event handler for fading a given chord group. */
function fade(opacity) {
  return function(g, i) {
	//console.log('i : '+i);
    svg.selectAll("g path.chord")
        .filter(function(d) {
          return d.source.index != i && d.target.index != i;
        })
      .transition()
        .style("opacity", opacity);
  };
}




