$(function () {

    Highcharts.chart('container', {

        chart: {
            type: 'solidgauge',
 	    events: 
	    {
            	load: function(){
                	// show tooltip on 4th point
                	var p = this.series[0].points[0];
                	this.tooltip.refresh(p);  
            	}
            }
        },

        title: {
            text: null,
		style: {
                fontSize: '24px'
            }
        },

        tooltip: {
            borderWidth: 0,
	    hideDelay: 100000,
            backgroundColor: 'none',
            shadow: false,
            style: {
                fontSize: '16px'
            },
            pointFormat: '<span align="center">{series.name}:<br><span style="font-size:2em; color: {point.color}; font-weight: bold">{point.y}%</span></span>',
            positioner: function (labelWidth, labelHeight) {
                   	var ele = $("#container");
			var offset = ele.offset();
			var width = ele.width();
			var height = ele.height();
			return {
                   		x: width/2 - labelWidth/2,
                    		y: height/2 - labelHeight/2
                	};
            }
        },

        pane: {
            startAngle: 360,
            endAngle: 0,
            background: [{ // Track for Move
                outerRadius: '112%',
                innerRadius: '84%',
                backgroundColor: Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0.3).get(),
                borderWidth: 0
            }, { // Track for Exercise
                outerRadius: '75%',
                innerRadius: '55%',
                backgroundColor: Highcharts.Color(Highcharts.getOptions().colors[1]).setOpacity(0.3).get(),
                borderWidth: 0
            }
		]
        },

        yAxis: {
            min: 0,
            max: 100,
            lineWidth: 0,
            tickPositions: []
        },

        plotOptions: {
            solidgauge: {
                borderWidth: '34px',
                dataLabels: {
                    enabled: false
                },
                linecap: 'round',
                stickyTracking: false
            }
        },

        series: [{
            name: 'Your Score',
            borderColor: Highcharts.getOptions().colors[0],
            data: [{
                color: Highcharts.getOptions().colors[0],
                radius: '101%',
                innerRadius: '95%',
                y: 80
            }]
        }, {
            name: 'Normal',
            borderColor: Highcharts.getOptions().colors[1],
            data: [{
                color: Highcharts.getOptions().colors[1],
                radius: '65%',
                innerRadius: '65%',
                y: 65
            }]
        
        }]
    })


});
