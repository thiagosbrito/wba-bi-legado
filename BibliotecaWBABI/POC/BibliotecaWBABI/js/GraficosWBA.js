/*
Titulo:Conjunto de Funções que facilita e automatiza a criação dos graficos
Autor: Rafael Franco Regio dos Passos
Data Criação: 30/11/2012
*/

/*Grafico de Pizza*/
function CriarPizza(categorias_ , renderTo_ , innerSize_, Name_)
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
                text: Name_
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


/*Grafico de Barras*/
function CriarBarra(categorias_, Valores_,renderTo_ ,name_){

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
                data:Valores_
					}
				]
        });
    });
	
}

//Grafico de Barras Vertical
function CriaBarraVertical(categorias_, Valores_,renderTo_ ,name_)
{

var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: renderTo_,
                type: 'bar'
            },
            title: {
                text: name_
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
                }
            },
            tooltip: {
                formatter: function() {
                    return ''+
                        this.series.name +': '+ this.y +' millions';
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
                x: -100,
                y: 100,
                floating: true,
                borderWidth: 1,
                backgroundColor: '#FFFFFF',
                shadow: true
            },
            credits: {
                enabled: false
            }
			
			,
            series:[{
                name: name_,
                data:Valores_
					}
				]
				
        });
    });
    
}


function CriaGraficoDeLinha(categorias_, renderTo_ ,name_ , Serie1)
{

   var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: renderTo_,
                type: 'line',
                marginRight: 130,
                marginBottom: 25
            },
            title: {
                text: name_,
                x: -20 //center
            },
            subtitle: {
                text: null,
                x: -20
            },
            xAxis: {
                categories: categorias_
            },
            yAxis: {
                title: {
                    text: null
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            tooltip: {
                formatter: function() {
                        return '<b>'+ this.series.name +'</b><br/>'+
                        this.x +': '+ this.y +'°C';
                }
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'top',
                x: -10,
                y: 100,
                borderWidth: 0
            }
			
			, credits: {
                enabled: false
            }
			,
            series: [
			{
					name: Serie1[0][0],
					data: Serie1[0][1]
			},
			{
					name: Serie1[1][0],
					data: Serie1[1][1]
			},
			{
					name: Serie1[2][0],
					data: Serie1[2][1]
			}
			,
			{
					name: Serie1[3][0],
					data: Serie1[3][1]
			}
			,
			{
					name: Serie1[4][0],
					data: Serie1[4][1]
			}
			,
			{
					name: Serie1[5][0],
					data: Serie1[5][1]
			}
			]
        });
    });
 

}	
