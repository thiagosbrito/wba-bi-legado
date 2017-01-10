<!DOCTYPE HTML>
<html lang="pt-Br">
<head>
    <title>WBA BI - Risco</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    
	
	<!-- JQUERY -->
	<script src="/BibliotecaWBABI/POC/js/jquery.min.js"></script>
	
    <!-- TWITTER BOOTSTRAP CSS  thema Vermelho-->
    <link href="/BibliotecaWBABI/css/bootstrap/bootstrap_Preto.css"      rel="stylesheet"   type="text/css"/>
    <link rel="stylesheet" href="/BibliotecaWBABI/plugin/bootstrap/css/bootstrap.min.css">
    <!-- <link href="/BibliotecaWBABI/css/bootstrap/bootstrap-responsive.css" rel="stylesheet"   type="text/css"/> -->
	<link href="/BibliotecaWBABI/css/Dashboards/DashscreenBlack.css"     rel="stylesheet"   type="text/css"/>
	
	<!-- TWITTER BOOTSTRAP JS -->
     <script type="text/javascript" src  ="/BibliotecaWBABI/plugin/bootstrap/js/bootstrap.min.js"></script>
	<!--GRAFICO-->
	<script type="text/javascript" src=" /BibliotecaWBABI/js/betaHightChats/highcharts.js"></script>
	<script type="text/javascript" src=" /BibliotecaWBABI/js/FuncoesBasicas.js"></script>
	<script type="text/javascript" src=" /BibliotecaWBABI/js/GraficosWBA.js"></script>
	<script type="text/javascript" src=" /BibliotecaWBABI/plugin/BlockUI/jquery.blockUI.js"></script>
	
	
	
	
	
	<script type="text/javascript" src=" /BibliotecaWBABI/js/Generico_multidash.js"></script>
    
	
	
	<style>
	.AreaGrafica
	{
		height:200px;
	}
	</style>


<script type="text/javascript">
	
	function  loadData(){
		ThemaDark(); //Aplica o Thema aos dashbord
		ListaDeEmpresas("combo_empresa","selectEmpresa","clic_empresa");//chama combo com as empresas
		url = '/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:Risco.xaction/generatedContent?&getData=4&Ano='+getAno();
		Grafico_Top5CedentesConcentracao(url);
	}
	
	function clic_empresa()
	{
	   var empresa_id        = $("#selectEmpresa :selected").val();
	   var empresa_descricao = $('#selectEmpresa :selected').text();
	   var url ='/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:Risco.xaction/generatedContent?&getData=Top5CedentesConcentracaoEmpresa&Empresa='+empresa_descricao;
	   
	   if (empresa_id == 'TODOS')
	   {
	      url = '/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:Risco.xaction/generatedContent?&getData=4&Ano='+getAno();
	   }
	   
	   Grafico_Top5CedentesConcentracao(url);
	}
	
	
	function Grafico_Top5CedentesConcentracao(Url_Chamada)
	{
		var categorias = new Array();
		var SomaPercentual = 0;
		var url =Url_Chamada;
		
		$.getJSON(url, function(data) {	
			format: "json"
		}).done(function(data) {
			$.each(data.result.data, function(key, val) {
				categorias[key] =  new Array(val[0],parseFloat(val[1])); 
				SomaPercentual += parseFloat(val[1]);
			});
				
		})
		.always(function() {
		    SomaPercentual = SomaPercentual.toString().substring(0,4);
			categorias[5] =  new Array('OUTROS',100-parseFloat(SomaPercentual)); 
			
			if (SomaPercentual  == 0)
			{
			    $("#GraficoPizza").html("<h1>Não possui registros para essa consulta</h1>");
			    $("#GraficoLinha1").html("<h1>Não possui registros para essa consulta</h1>");
			    $("#GraficoBarra").html("<h1>Não possui registros para essa consulta</h1>");
			    $("#GraficoLinha").html("<h1>Não possui registros para essa consulta</h1>");
			  
			}else{
				CriarPizza(categorias);
			}
		});
	}
	
	
	
	
	

//***********************************GRAFICO DE PIZZA -*************************** TOP 5 CEDENTES - CONCENTRACAO***************
function CriarPizza(Categorias_)
{	



var chart;

    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'GraficoPizza',
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: true
            },
            title: {
                text: null
            },
            tooltip: {
                formatter: function() {
                    return '<b>'+ this.point.name +'</b>: '+ this.y.toString().substring(0,4)+'%';
			    }
            },
			 legend: {
				align: 'left',
				verticalAlign: 'left',
				layout: 'vertical',
				padding:10,
				y: 30,
			},
			credits: {
                enabled: false
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false,
                        color: '#000000',
						connectorColor: '#000000',
                        formatter: function() {
                            return '<b>'+ this.point.name +':</b><br> '+ this.y;
                        },
					}					
					,showInLegend: true,
					
					point: {
					    events: {
							click: function() {
								ChamaGraficoArea(this.name);
							}
					   }
				    }
		        }
			}, 
				series: [{
                type: 'pie',
                name: 'pie	',
                data: Categorias_
			}] 
		});
    });
	
	chart.series[0].data[1].select();
	ChamaGraficoArea(chart.series[0].data[1].name);
	

}

//***********************************GRAFICO DE TIME SERIES -*************************** CEDENTES - EVOLUCAO DE OPERACAO***************
function CompareForSort(first, second)
{
    if (first == second)
        return 0;
    if (first < second)
        return -1;
    else
        return 1; 
}


function ChamaGraficoArea(cedente_)
{
	var valores = new Array();
	var mes = new Array();
	var dia = new Array();
	var ano = new Array();

	
	//Captura retorno do JSON vindo de uma XACTION com query MDX
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:Risco.xaction/generatedContent?&getData=5&Cedente='+"'"+cedente_+"'", function(data) {	

	
			//loop nas linhas 
				$.each(data.result.data, function(key, val) {
					        //alimenta array com o resultado de acordo com a posição que vem no arquivo JSON
							var dataInclusaoContabil = val[0]; //DD_MM_AAAA
							var valor  = parseFloat(val[1]);
							
							dia[key] = dataInclusaoContabil.substring(0,2)
							mes[key] = dataInclusaoContabil.substring(3,5)
						    ano[key] = dataInclusaoContabil.substring(6,10);

							valores[key] = new Array(Date.UTC(ano[key],mes[key]-1,dia[key]), parseFloat(valor)); //Matrix XY Dia(UTC)/ Valor(Float)
				});	

				
				

				
				AreaTIME_SERIES(cedente_, valores.sort(CompareForSort) , (Date.UTC(ano[0], mes[0]-1, dia[0])));		
	
	
	/*
	var a = new Array(4, 11, 2, 10, 3, 1);
	alert(a);
	var b = a.sort(CompareForSort);
    alert(b);
	*/
	
	
	});
				ChamaGrfaicoDeBarras(cedente_);
}	
	
function AreaTIME_SERIES(cedente_, valores_, start_)  /*TIME SERIES*/
{			
var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'GraficoLinha1',
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
            },
			
			credits: {
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
                                radius: 4
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

//************************************GRAFICO DE BARRAS -************ TOP 5 SACADOS NO CEDENTE ***************
function ChamaGrfaicoDeBarras(cedente_)
{
	var categorias = new Array();
	var valores = new Array();

	//Captura retorno do JSON vindo de uma XACTION com query MDX
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:Risco.xaction/generatedContent?&getData=7&Cedente='+cedente_, function(data) {	
				
				//loop nas linhas
				$.each(data.result.data, function(key, val) {
							//alimenta array com o resultado de acordo com a posição que vem no arquivo JSON
							
							if (key > 0){
							
								categorias[key-1] =  val[0];//new Array(val[0],parseFloat(val[1])); 
								valores[key-1]    =  parseFloat(val[1]);
							
							}
							
				});
				
				//Chama função que gera o grafico e passa o array com os valores
				CriarGraficoDeBarras(cedente_,categorias,valores );
				ChamaLinha(categorias[0]);
				
	});
}

function CriarGraficoDeBarras(cedente_,categorias_, valores_)
{
var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'GraficoBarra',
                type: 'column',
                margin: [ 40, 10, 105, 40]
            }
			
			,
			
			
            title: {
                text: cedente_
            },
            xAxis: {
                categories: categorias_,
                labels: {
                    rotation: 0,
                    align: 'center',
                    style: {
                        fontSize: '9px',
                        fontFamily: 'Verdana, sans-serif'
                    }
					
                }
            },
            yAxis: {
                min: 0,
                title: {
                    text: ''
                }
            },
            legend: {
                enabled: false
            },
			
			credits: {
                enabled: false
            },

			
            tooltip: {
                formatter: function() {
                    return '<b>'+ this.x +'</b><br/>'+
                        'Valor do Titulo: '+'R$ '+ Highcharts.numberFormat(this.y, 2);
                }
            },
                series: [{
                name: 'Population',
                data: valores_,
                dataLabels: {
                    enabled: false,
                    rotation: 0,
                    color: '#FFFFFF',
                    align: 'center',
                    x: -3,
                    y: 10,
                    formatter: function() {
                        return this.y;
                    },
                    style: {
                        fontSize: '13px',
                        fontFamily: 'Verdana, sans-serif'
                    }
                }
							
				 ,point: {
                        events: {
                            click: function() {
                                ChamaLinha(categorias_[this.x]);
                            }
                        }
                    }
				
            }]
        });
    });
}
//************************************GRAFICO DE LINHAS -************ COMPORTAMENTO DE PAGAMENTO - SACADO 1***************
function ChamaLinha(sacado_){
	
	
	if (sacado_ == undefined){
	sacado_ = "OUTROS";
	}  

	
	var categoriasMensal_ = new Array();
	var c1 = new Array();

		//Captura retorno do JSON vindo de uma XACTION com query MDX
			$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:Risco.xaction/generatedContent?&getData=8&Sacado='+sacado_+'&Ano='+getAno()+'&Mes='+getMesAtual(), function(data) {	
			
					//loop nos cabeçalhos
					$.each(data.result.metadata.columns, function(key, val) {
								if (key >0){
									categoriasMensal_[key-1] = val
								}
					});
					
					//loop nas linhas
					$.each(data.result.data, function(key, val) {
						
						//alimenta array com o resultado de acordo com a posição que vem no arquivo JSON
						c1[key] = {name: val[0] ,data:[ new Array(0,parseFloat(val[1])), new Array(1,parseFloat(val[2])) , new Array(2,parseFloat(val[3])), new Array(3,parseFloat(val[4])), new Array(4,parseFloat(val[5])),new Array(5,parseFloat(val[6])),new Array(6,parseFloat(val[7])), new Array(7,parseFloat(val[8])),new Array(8,parseFloat(val[9])),new Array(9,parseFloat(val[10])),new Array(10,parseFloat(val[11])),new Array(11,parseFloat(val[12])) ] }
											
					});
						//Chama função que gera o grafico e passa o array com os valores
						
						
						CriarChartLinhaPorSacado(categoriasMensal_,c1, sacado_);
						


			});
}

function CriarChartLinhaPorSacado(categorias_, series_, sacado_)
{
var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'GraficoLinha',
                type: 'line',
                marginRight: 100,
                marginBottom: 45
            },
            title: {
                text: sacado_,
                x: -20 //center
            },
            subtitle: {
                text: '',
                x: -20
            },
            xAxis: {
               categories: categorias_,
                labels: {
                    rotation: 15,
                    align: 'center',
                    style: {
                        fontSize: '9px',
                        fontFamily: 'Verdana, sans-serif'
                    }
                }
					
					
			   
		    },
            yAxis: {
                title: {
                    text: ''
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
				
            },
            tooltip: {
                formatter: function() {
                        return '<b>'+ this.series.name +'</b><br>'+ 'R$ '+ formatNumber(this.y);
                }
            }
			,
            legend: {
                layout: 'vertical',
				align: 'right',
                verticalAlign: 'top',
                x: -10,
                y: 20,
                borderWidth: 0,
				enabled: true				
            },
			
			credits: {
                enabled: false
            },

			
		    series:series_
		});
   


	$.unblockUI();

   });



}

</script>

</head>
<body onload="javascript: loadData()" style="background-color:#414141">
  

<div style="padding:0px 0px 0px 0px;  height:120%">

<div class="container" >
    <!-- CLASSE QUE DEFINE O CONTAINER COMO FLUIDO (100%) -->
    <div class="container-fluid" >
	    <div class="row">
	    			
            <!-- COLUNA OCUPANDO 10 ESPA&#231;OS NO GRID -->
            <div class="col-md-12">

			<div class="row" ><div class="col-md-12"><span id="combo_empresa"></span></div></div>
				<div class="row" >
				  
				   
				   <div class="col-md-6">
					  <div  class="BordasArredondadas">
					  <div class="TituloDash">Concentração Carteira - Top 5 Cedentes</div>
					  <div id="GraficoPizza" class="AreaGrafica"></div></div>
				   </div>
				   <div class="col-md-6">
					  <div  class="BordasArredondadas">
					  <div class="TituloDash">Evolução de Operação<span style="color:black"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></div>
					  <div id="GraficoLinha1" class="AreaGrafica"></div></div>
				   </div>
				</div>

				<div style="padding:0.8%"></div>


				<div class="row">
				   <div class="col-md-6">
					  <div  class="BordasArredondadas">
					  <div class="TituloDash">Concentração Carteira - Top 5 Sacados</div>
					  <div id="GraficoBarra" class="AreaGrafica"></div></div>
				   </div>
				   <div class="col-md-6">
					  <div  class="BordasArredondadas">
					  <div class="TituloDash">Comportamento de Pagamento<span style="color:black"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></div>
					  <div id="GraficoLinha" class="AreaGrafica"></div></div>
				   </div>
				</div>
				
				
				

			</div>
			
         </div>
    </div>
	
	</div>
	
 
</div>
	
	
</body>
</html>
