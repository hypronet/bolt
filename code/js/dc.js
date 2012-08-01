dc={version:"0.3.0",_charts:[]},dc.registerChart=function(e){dc._charts.push(e)},dc.hasChart=function(e){return dc._charts.indexOf(e)>=0},dc.deregisterAllCharts=function(){dc._charts=[]},dc.filterAll=function(){for(var e=0;e<dc._charts.length;++e)dc._charts[e].filterAll()},dc.renderAll=function(){for(var e=0;e<dc._charts.length;++e)dc._charts[e].render()},dc.redrawAll=function(){for(var e=0;e<dc._charts.length;++e)dc._charts[e].redraw()},dc.transition=function(e,t,n){if(t<=0)return e;var r=e.transition().duration(t);return n instanceof Function&&n(r),r},dc.units={},dc.units.integers=function(e,t){return new Array(Math.abs(t-e))},dc.round={},dc.round.floor=function(e){return Math.floor(e)},dc.baseChart=function(e){var t,n,r,i,s=200,o=200,u=function(e){return e.key},a=function(e){return e.value},f=750;return e.dimension=function(n){return arguments.length?(t=n,e):t},e.group=function(t){return arguments.length?(n=t,e):n},e.orderedGroup=function(){return n.order(function(e){return e.key})},e.filterAll=function(){return e.filter(null)},e.dataAreSet=function(){return t!=undefined&&n!=undefined},e.select=function(e){return i.select(e)},e.selectAll=function(e){return i.selectAll(e)},e.anchor=function(t){return arguments.length?(r=t,i=d3.select(r),e):r},e.root=function(t){return arguments.length?(i=t,e):i},e.width=function(t){return arguments.length?(s=t,e):s},e.height=function(t){return arguments.length?(o=t,e):o},e.svg=function(){return e.select("svg")},e.resetSvg=function(){e.select("svg").remove()},e.generateSvg=function(){return e.root().append("svg").attr("width",e.width()).attr("height",e.height())},e.turnOnReset=function(){e.select("a.reset").style("display",null)},e.turnOffReset=function(){e.select("a.reset").style("display","none")},e.transitionDuration=function(t){return arguments.length?(f=t,e):f},e.filter=function(t){return e},e.render=function(){return e},e.redraw=function(){return e},e.keyFunction=function(t){return arguments.length?(u=t,e):u},e.valueFunction=function(t){return arguments.length?(a=t,e):a},e},dc.coordinateGridChart=function(e){function p(e){}function d(t){var n=c.extent();e.round()&&(n[0]=n.map(e.round())[0],n[1]=n.map(e.round())[1],r.select(".brush").call(c.extent(n))),e.filter([c.extent()[0],c.extent()[1]]),dc.redrawAll()}function v(e){}var t=5;e=dc.baseChart(e);var n={top:10,right:50,bottom:30,left:20},r,i,s=d3.svg.axis(),o=dc.units.integers,u=d3.scale.linear().range([100,0]),a=d3.svg.axis(),f=!1,l,c=d3.svg.brush(),h;return e.generateG=function(){r=e.generateSvg().append("g").attr("transform","translate("+e.margins().left+","+e.margins().top+")")},e.g=function(t){return arguments.length?(r=t,e):r},e.margins=function(t){return arguments.length?(n=t,e):n},e.x=function(t){return arguments.length?(i=t,e):i},e.xAxis=function(t){return arguments.length?(s=t,e):s},e.renderXAxis=function(t){t.select("g.x").remove(),e.x().range([0,e.width()-e.margins().left-e.margins().right]),s=s.scale(e.x()).orient("bottom"),t.append("g").attr("class","axis x").attr("transform","translate("+e.margins().left+","+e.xAxisY()+")").call(s)},e.xAxisY=function(){return e.height()-e.margins().bottom},e.xAxisLength=function(){return e.width()-e.margins().left-e.margins().right},e.xUnits=function(t){return arguments.length?(o=t,e):o},e.renderYAxis=function(n){n.select("g.y").remove(),u.domain([e.yAxisMin(),e.yAxisMax()]).rangeRound([e.yAxisHeight(),0]),a=a.scale(u).orient("left").ticks(t),n.append("g").attr("class","axis y").attr("transform","translate("+e.margins().left+","+e.margins().top+")").call(a)},e.y=function(t){return arguments.length?(u=t,e):u},e.yAxis=function(t){return arguments.length?(a=t,e):a},e.elasticY=function(t){return arguments.length?(f=t,e):f},e.yAxisMin=function(){var t=d3.min(e.group().all(),function(t){return e.valueFunction()(t)});return t>0&&(t=0),t},e.yAxisMax=function(){return d3.max(e.group().all(),function(t){return e.valueFunction()(t)})},e.yAxisHeight=function(){return e.height()-e.margins().top-e.margins().bottom},e.round=function(t){return arguments.length?(h=t,e):h},e._filter=function(t){return arguments.length?(l=t,e):l},e.filter=function(t){return t?(e._filter(t),e.brush().extent(t),e.dimension().filterRange(t),e.turnOnReset()):(e._filter(null),e.brush().clear(),e.dimension().filterAll(),e.turnOffReset()),e},e.brush=function(t){return arguments.length?(c=t,e):c},e.renderBrush=function(t){c.on("brushstart",p).on("brush",d).on("brushend",v);var n=t.append("g").attr("class","brush").attr("transform","translate("+e.margins().left+",0)").call(c.x(e.x()));n.selectAll("rect").attr("height",e.xAxisY()),n.selectAll(".resize").append("path").attr("d",e.resizeHandlePath),l&&e.redrawBrush(t)},e._redrawBrush=function(t){e._filter()&&e.brush().empty()&&e.brush().extent(e._filter());var n=t.select("g.brush");n.call(e.brush().x(e.x())),n.selectAll("rect").attr("height",e.xAxisY())},e.resizeHandlePath=function(t){var n=+(t=="e"),r=n?1:-1,i=e.xAxisY()/3;return"M"+.5*r+","+i+"A6,6 0 0 "+n+" "+6.5*r+","+(i+6)+"V"+(2*i-6)+"A6,6 0 0 "+n+" "+.5*r+","+2*i+"Z"+"M"+2.5*r+","+(i+8)+"V"+(2*i-8)+"M"+4.5*r+","+(i+8)+"V"+(2*i-8)},e},dc.pieChart=function(e){function d(){return d3.layout.pie().value(function(e){return h.valueFunction()(e)})}function v(e){dc.transition(c,h.transitionDuration()).attr("transform",function(t){t.innerRadius=h.innerRadius(),t.outerRadius=i;var n=e.centroid(t);return isNaN(n[0])||isNaN(n[1])?"translate(0,0)":"translate("+n+")"}).attr("text-anchor","middle").text(function(e){var t=e.data;return h.valueFunction()(t)==0?"":p(e)})}function m(e){e.innerRadius=h.innerRadius();var t=this._current;g(t)&&(t={startAngle:0,endAngle:0});var n=d3.interpolate(t,e);return this._current=n(0),function(e){return u(n(e))}}function g(e){return e==null||isNaN(e.startAngle)||isNaN(e.endAngle)}function y(e){h.filter(h.keyFunction()(e.data)),dc.redrawAll()}var t,n="pie-slice",r=d3.scale.category20c(),i=0,s=0,o,u,a,f,l,c,h=dc.baseChart({}),p=function(e){return h.keyFunction()(e.data)};return h.transitionDuration(350),h.render=function(){return h.resetSvg(),h.dataAreSet()&&(o=h.generateSvg().append("g").attr("transform","translate("+h.cx()+","+h.cy()+")"),a=d(),u=h.buildArcs(),f=h.drawSlices(o,a,u),h.drawLabels(f,u),h.highlightFilter()),h},h.innerRadius=function(e){return arguments.length?(s=e,h):s},h.colors=function(e){return arguments.length?(r=d3.scale.ordinal().range(e),h):r},h.radius=function(e){return arguments.length?(i=e,h):i},h.cx=function(){return h.width()/2},h.cy=function(){return h.height()/2},h.buildArcs=function(){return d3.svg.arc().outerRadius(i).innerRadius(s)},h.drawSlices=function(e,t,i){return f=e.selectAll("g."+n).data(t(h.orderedGroup().top(Infinity))).enter().append("g").attr("class",function(e,t){return n+" "+t}),l=f.append("path").attr("fill",function(e,t){return r(t)}).attr("d",i),l.transition().duration(h.transitionDuration()).attrTween("d",m),l.on("click",y),f},h.drawLabels=function(e,t){c=e.append("text"),v(t),c.on("click",y)},h.hasFilter=function(){return t!=null},h.filter=function(e){return arguments.length?(t=e,h.dataAreSet()&&h.dimension().filter(t),e?h.turnOnReset():h.turnOffReset(),h):t},h.isSelectedSlice=function(e){return h.filter()==h.keyFunction()(e.data)},h.highlightFilter=function(){var e=1,t=3,r=.1,i=0;h.hasFilter()?h.selectAll("g."+n).select("path").each(function(n){h.isSelectedSlice(n)?d3.select(this).attr("fill-opacity",e).attr("stroke","#ccc").attr("stroke-width",t):d3.select(this).attr("fill-opacity",r).attr("stroke-width",i)}):h.selectAll("g."+n).selectAll("path").attr("fill-opacity",e).attr("stroke-width",i)},h.redraw=function(){h.highlightFilter();var e=a(h.orderedGroup().top(Infinity));return l=l.data(e),c=c.data(e),dc.transition(l,h.transitionDuration(),function(e){e.attrTween("d",m)}),v(u),h},h.label=function(e){return p=e,h},dc.registerChart(h),h.anchor(e)},dc.barChart=function(e){function s(){i=r.g().selectAll("rect.bar").data(r.group().all()),i.enter().append("rect").attr("class","bar").attr("x",function(e){return u(e)}).attr("y",r.xAxisY()).attr("width",function(){return o()}),dc.transition(i,r.transitionDuration()).attr("y",function(e){return a(e)}).attr("height",function(e){return f(e)}),dc.transition(i,r.transitionDuration()).attr("y",function(e){return a(e)}).attr("height",function(e){return f(e)}),dc.transition(i.exit(),r.transitionDuration()).attr("y",r.xAxisY()).attr("height",0)}function o(){var e=Math.floor(r.xAxisLength()/r.xUnits()(r.x().domain()[0],r.x().domain()[1]).length);if(isNaN(e)||e<t)e=t;return e}function u(e){return r.x()(r.keyFunction()(e))+r.margins().left}function a(e){return r.margins().top+r.y()(r.valueFunction()(e))}function f(e){return r.yAxisHeight()-r.y()(r.valueFunction()(e))-n}function l(){if(!r.brush().empty()&&r.brush().extent()!=null){var e=r.brush().extent()[0],t=r.brush().extent()[1];i.classed("deselected",function(n){var i=r.keyFunction()(n);return i<e||i>=t})}else i.classed("deselected",!1)}var t=1,n=1,r=dc.coordinateGridChart({}),i;return r.transitionDuration(500),r.render=function(){return r.resetSvg(),r.dataAreSet()&&(r.generateG(),r.renderXAxis(r.g()),r.renderYAxis(r.g()),s(),r.renderBrush(r.g())),r},r.redraw=function(){return s(),r.redrawBrush(r.g()),r.elasticY()&&r.renderYAxis(r.g()),r},r.redrawBrush=function(e){r._redrawBrush(e),l()},dc.registerChart(r),r.anchor(e)},dc.lineChart=function(e){function n(){t.g().datum(t.group().all());var e=t.selectAll("path.line");e.empty()&&(e=t.g().append("path").attr("class","line"));var n=d3.svg.line().x(function(e){return t.x()(t.keyFunction()(e))}).y(function(e){return t.y()(t.valueFunction()(e))});e=e.attr("transform","translate("+t.margins().left+","+t.margins().top+")"),dc.transition(e,t.transitionDuration(),function(e){e.ease("linear")}).attr("d",n)}function r(){}var t=dc.coordinateGridChart({});return t.transitionDuration(500),t.render=function(){return t.resetSvg(),t.dataAreSet()&&(t.generateG(),n(),t.renderXAxis(t.g()),t.renderYAxis(t.g()),t.renderBrush(t.g())),t},t.redraw=function(){return n(),t.redrawBrush(t.g()),t.elasticY()&&t.renderYAxis(t.g()),t},t.redrawBrush=function(e){t._redrawBrush(e),r()},dc.registerChart(t),t.anchor(e)},dc.dataCount=function(e){var t=d3.format(",d"),n=dc.baseChart({});return n.render=function(){return n.selectAll(".total-count").text(t(n.dimension().size())),n.selectAll(".filter-count").text(t(n.group().value())),n},n.redraw=function(){return n.render()},dc.registerChart(n),n.anchor(e)},dc.dataTable=function(e){function u(){var e=t.root().selectAll("div.group").data(a(),function(e){return t.keyFunction()(e)});return e.enter().append("div").attr("class","group").append("span").attr("class","label").text(function(e){return t.keyFunction()(e)}),e.exit().remove(),e}function a(){o||(o=crossfilter.quicksort.by(i));var e=t.dimension().top(n);return d3.nest().key(t.group()).sortKeys(s).entries(o(e,0,e.length))}function f(e){var t=e.order().selectAll("div.row").data(function(e){return e.values}),n=t.enter().append("div").attr("class","row");for(var i=0;i<r.length;++i){var s=r[i];n.append("span").attr("class","column "+i).text(function(e){return s(e)})}return t.exit().remove(),t}var t=dc.baseChart({}),n=25,r=[],i=function(e){return e},s=d3.ascending,o;return t.render=function(){return t.selectAll("div.row").remove(),f(u()),t},t.redraw=function(){return t.render()},t.size=function(e){return arguments.length?(n=e,t):n},t.columns=function(e){return arguments.length?(r=e,t):r},t.sortBy=function(e){return arguments.length?(i=e,t):i},t.order=function(e){return arguments.length?(s=e,t):s},dc.registerChart(t),t.anchor(e)};