/*
Titulo:Conjunto de Funções que facilita e automatiza a criação dos graficos
Autor: Rafael Franco Regio dos Passos
Data Criação: 30/11/2012
*/

/*Grafico de Pizza*/
function CriarPizza(categorias_ , renderTo_ , innerSize_)
{

//TravaTela(1);		
var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: renderTo_,
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: true
            },
            title: {
                text: null
            },
            tooltip: {
                formatter: function() {
                    return '<b>'+ this.point.name +'</b>: '+ 'R$'+moeda(this.y,2,',','.');
                }
            },
			 legend: {
				align: 'left',
  			    layout: 'vertical',
				verticalAlign: 'left',
				padding:10,
				y: 50
			},
			 credits: {
                enabled: false
            },
            plotOptions: {
                pie: {
                    allowPointSelect: false,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false,
                        color: '#000000',
                        connectorColor: '#000000',
                        formatter: function() {
                            return '<b>'+ this.point.name +':</b><br> '+ this.y;
                        },
					}					
					,showInLegend: true
					
					
		        }
			}, 
				series: [{
                type: 'pie',
                name: 'pie	',
                data: categorias_, 
			    innerSize: innerSize_
			}] 
		});
    });

}

/*Grafico de Area*/
function AreaTIME_SERIES(cedente_, valores_, start_ , renderTo_)  /*TIME SERIES*/
{			
var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: renderTo_,
                zoomType: 'x',
                spacingRight: 20
            },
		
            title: {
                text: cedente_
            },
            subtitle: {
                text: ''
            },
            xAxis: {
                type: 'datetime',
                maxZoom: 14 * 24 * 3600000, // fourteen days
	            title: {
                    text: null
				}
			},
            yAxis: {
                title:{
                text: ''
                },
                min: 0.6,
                startOnTick: false,
                showFirstLabel: true
			},
            tooltip: {
                shared: true
            },
            legend: {
                enabled: false
            }, credits: {
                enabled: false
            },
            plotOptions: {
                area: {
                    fillColor: {
                        linearGradient: { x1: 1, y1: 0, x2: 0, y2: 1},
                        stops: [
                            [0, Highcharts.getOptions().colors[1]],
                            [1, 'rgba(2,0,0,0)']
                        ]
                    },
                    lineWidth: 1,
                    marker: {
                        enabled: false,
                        states: {
                            hover: {
                                enabled: true,
                                radius: 3
                            }
                        }
                    },
                    shadow: true,
                    states: {
                        hover: {
                            lineWidth: 1
                        }
                    }
                }
            }, 
			series: [{
                type: 'area',
                name: 'VALOR TITULO',
	            pointStart:  start_,
                data: valores_				
	        }]
        });
		
    });
}

/*Grafico de Barras*/
function CriarBarra(categorias_,renderTo_ ,name_){

var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: renderTo_,
                type: 'column' 
            },
            title: {
                text: null
            },
            subtitle: {
                text: null
            },
            xAxis: {
                categories: categorias_,
                title: {
                    text: null
                }
            },
            yAxis: {
                min: 0,
                title: {
                    text: null,
                    align: 'high'
                },
                labels: {
                    overflow: 'justify'
                }
            },
            tooltip: {
                formatter: function() {
                    return ''+
                        this.series.name +': '+ this.y;
                }
            },
            plotOptions: {
                bar: {
                    dataLabels: {
                        enabled: true
                    }
			    }
				
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'top',
                x: 0,
                y: 0,
                floating: true,
                borderWidth: 1,
                backgroundColor: '#FFFFFF',
                shadow: true
            },
            credits: {
                enabled: false
            },
            series:[{
                name: name_,
                data:categorias_
					}
				]
        });
    });
	
}

/*2014: Melhorias dos dashbord WBA-BI by Rpassosfranco ---> WBABI-170*/
function GraficoDeBarrasSimplesComCliqueNaBarra(categorias_,valores_,Nome_,renderTo_){
         
var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: renderTo_,
                type: 'column' 
            },
            title: {
                text: null
            },
            subtitle: {
                text: null
            },
            xAxis: {
                categories: categorias_,
                title: {
                    text: null
                }
            },
            yAxis: {
                min: 0,
                title: {
                    text: null,
                    align: 'high'
                },
                labels: {
                    overflow: 'justify'
                }
            },
            tooltip: {
                formatter: function() {
                    return ''+
                        this.series.name +': '+'R$ '+ formatNumber(this.y);
                }
            },
            plotOptions: {
                bar: {
                    dataLabels: {
                        enabled: true
                    }
                }
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'top',
                x: 0,
                y: 0,
                floating: true,
                borderWidth: 1,
                backgroundColor: '#FFFFFF',
                shadow: true
            },
            credits: {
                enabled: false
            },
            series:[{
                name: Nome_,
                data: valores_
				
				,point: {
					    events: {
					
							click: function() {
								ChamarGraficoDrillDown(categorias_[this.x] , Nome_);
								
							}
					   }
				    }

				
                }
  			   ]
        });
    });
}

function GraficoDeBarrasDuplasComCliqueNasBarras(categorias_,valores_1,valores_2,Nome_1,Nome_2,renderTo_){


var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: renderTo_,
                type: 'column' 
            },
            title: {
                text: null
            },
            subtitle: {
                text: null
            },
            xAxis: {
                categories: categorias_,
                title: {
                    text: null
                }
            },
            yAxis: {
                min: 0,
                title: {
                    text: null,
                    align: 'high'
                },
                labels: {
                    overflow: 'justify'
                }
            },
            tooltip: {
                formatter: function() {
                    return ''+
                        this.series.name +': '+'R$ '+ formatNumber(this.y);
                }
            },
            plotOptions: {
                bar: {
                    dataLabels: {
                        enabled: true
                    }
                }
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'top',
                x: 0,
                y: 0,
                floating: true,
                borderWidth: 1,
                backgroundColor: '#FFFFFF',
                shadow: true
            },
            credits: {
                enabled: false
            },
            series:[{
                name: Nome_1,
                data: valores_1
				,point: {
					    events: {
					
							click: function() {
								ChamarGraficoDrillDown(categorias_[this.x] , Nome_1);
							}
					   }
				    }
                }, 
				{
                name: Nome_2,
                data: valores_2
				,point: {
					    events: {
					
							click: function() {
								ChamarGraficoDrillDown(categorias_[this.x] , Nome_2);
							}
					   }
				    }
		       }
  			   ]
        });
    });
//by Rpassosfraco
}


//Gauge
function montaKPI(valor_, renderTo_)
{
    var chart = new Highcharts.Chart({
        chart: {
            renderTo: renderTo_,
            type: 'gauge',
            plotBackgroundColor: null,
            plotBackgroundImage: null,
            plotBorderWidth: 0,
            plotShadow: false
        },
        
        title: {
            text: ''
        },
        
        pane: {
            startAngle: -150,
            endAngle: 150,
            background: [{
                backgroundColor: {
                    linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
                    stops: [
                        [0, '#FFF'],
                        [1, '#333']
                    ]
                },
                borderWidth: 0,
                outerRadius: '109%'
            }, {
                backgroundColor: {
                    linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
                    stops: [
                        [0, '#333'],
                        [1, '#FFF']
                    ]
                },
                borderWidth: 1,
                outerRadius: '107%'
            }, {
                // default background
            }, {
                backgroundColor: '#DDD',
                borderWidth: 0,
                outerRadius: '105%',
                innerRadius: '103%'
            }
			]
		  },
            credits: {
                enabled: false
            },
        // the value axis
        yAxis: {
            min: 0,
            max: 100,
            
            minorTickInterval: 'auto',
            minorTickWidth: 2,
            minorTickLength: 10,
            minorTickPosition: 'inside',
            minorTickColor: '#666',
    
            tickPixelInterval: 30,
            tickWidth: 2,
            tickPosition: 'inside',
            tickLength: 10,
            tickColor: '#666',
            labels: {
                step: 2,
                rotation: 'auto'
            },
            title: {
                text: null
            },
            plotBands: [{
                from: 0,
                to: 34,
                color: '#55BF3B' // green
            }, {
                from: 34,
                to: 68,
                color: '#DDDF0D' // yellow
            }, {
                from: 68,
                to: 100,
                color: '#DF5353' // red
            }] 
	    },
    
        series: [{
            name: '%', data: [valor_]
		}]
    
    }
	
	
	);
	
	
}

