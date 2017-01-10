<!DOCTYPE html>
<html lang="pt-Br">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>WBA BI - Concentração por Cedente</title>
	
	<!-- JQUERY -->
	<script src="/BibliotecaWBABI/POC/js/jquery.min.js"></script>
	
    <!-- TWITTER BOOTSTRAP CSS  thema Vermelho-->
    <link href="/BibliotecaWBABI/css/bootstrap/bootstrap_Preto.css"      rel="stylesheet"   type="text/css"/>
    <!-- <link href="/BibliotecaWBABI/css/bootstrap/bootstrap-responsive.css" rel="stylesheet"   type="text/css"/> -->
    <link rel="stylesheet" href="/BibliotecaWBABI/plugin/bootstrap/css/bootstrap.min.css">
	<link href="/BibliotecaWBABI/css/Dashboards/DashscreenBlack.css"     rel="stylesheet"   type="text/css"/>
	
	<!-- TWITTER BOOTSTRAP JS -->
    <script src="/BibliotecaWBABI/plugin/bootstrap/js/bootstrap.min.js"></script>
	<!--GRAFICO-->
	<script type="text/javascript" src=" /BibliotecaWBABI/js/betaHightChats/highcharts.js"></script>
	<script type="text/javascript" src=" /BibliotecaWBABI/js/FuncoesBasicas.js"></script>
	<script type="text/javascript" src=" /BibliotecaWBABI/js/GraficosWBA.js"></script>
	<script type="text/javascript" src=" /BibliotecaWBABI/plugin/BlockUI/jquery.blockUI.js"></script>
	
	
	<script type="text/javascript" src=" /BibliotecaWBABI/compartilhamento/Funcoes.js"></script>
		
		

	<style>
	.AreaGrafica
	{
		height:200px;
	}
	</style>

	
<script type="text/javascript">
$(document).ready(function() {
			$("h1#mostra").toggle(
				function() {
					$("div#oculto").fadeIn(); // ou slideDown()
				},
				function() {
					$("div#oculto").fadeOut(); // ou slideUp()
				}
			);
});

function  loadData()
{
	ThemaDark(); //Aplica o Thema aos dashbord
	MontaComboPosicoesHistoricas("selectPosicoesHistoricas","AcaoComboHistorico()");
}

function AcaoComboHistorico()
{
	var ValorHist = $("#selectPosicoesHistoricas").val();
	MontaComboEmpresa("selectEmpresa","AcaoComboEmpresa()");	

	
}



function AcaoComboEmpresa()
{
	var ValorCombo = $("#selectEmpresa").val();	
	MontaComboCedentePorEmpresa("selectCedente",ValorCombo,"AcaoComboCedente()");
}

function AcaoComboCedente()
{

	var cedenteCombo = $("#selectCedente").val();	
	ChamarGraficoDePizza(cedenteCombo);
	ChamarGraficoArea(cedenteCombo);
}

//***********************************GRAFICO DE PIZZA -*************************** TOP 5 CEDENTES - CONCENTRACAO***************
function ChamarGraficoDePizza(cedenteCombo_)
{
		var ValorComboDataFoto  = $("#selectPosicoesHistoricas").val();	
		var ValorComboCedente   = $("#selectCedente").val();	
		var NomeCedente         = $('#selectCedente :selected').text();
		
        var categoriasTitulos = new Array();

        var categoriasValores = new Array();
		var categorias = new Array();

		console.log('/pentaho/getDataWBA?getData=PosicoesHistoricasRecebiveisDoCedente&getCedente='+ValorComboCedente+'&getDataFoto='+ValorComboDataFoto);






		
		$.getJSON('/pentaho/getDataWBA?getData=PosicoesHistoricasRecebiveisDoCedente&getCedente='+ValorComboCedente+'&getDataFoto='+ValorComboDataFoto, function(data) {
			console.log(data);
		}).done(function(data) {
			$.each(data, function(key, val) {
				categorias[key] =  new Array(val.TIPORECEBIVEIS,parseFloat(val.VALORTITULO));
			});
		}).always(function() {
			   CriarPizza(categorias,NomeCedente);
		});

}

function CriarPizza(categorias_,cedenteCombo_)
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
                text: cedenteCombo_
            },
            tooltip: {
                formatter: function() {
                    return '<b>'+ this.point.name +'</b>: '+ 'R$'+moeda(this.y,2,',','.');;
                }
            },
			 legend: {
				align: 'left',
  			    layout: 'vertical',
				verticalAlign: 'left',
				padding:10,
				y: 50
			}
			
			,
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
					,showInLegend: true
		        }
			}, 
				series: [{
                type: 'pie',
                name: 'pie	',
                data: categorias_  
			}] 
		});
    });
	
	//chart.series[0].data[0].select();
	//ChamarGraficoArea(chart.series[0].data[0].name);
}




//***********************************GRAFICO DE TIME SERIES -*************************** CEDENTES - EVOLUCAO DE OPERACAO***************
function ChamarGraficoArea(cedente_)
{

	var ValorComboDataFoto  = $("#selectPosicoesHistoricas").val();	
	var ValorComboCedente   = $("#selectCedente").val();	
	var NomeCedente         = $('#selectCedente :selected').text();
	
	var valores = new Array();

	$.getJSON('/pentaho/getDataWBA?getData=PosicoesHistoricasEvolucaoOperacaoDataVencimento&getDataFoto='+ValorComboDataFoto+'&getCedente='+ValorComboCedente, function(data) {
		console.log(data);
	}).done(function(data) {
		$.each(data, function(key, val) {
			valores[key] = new Array(Date.UTC(val.ANODATAVENCIMENTO,val.MESDATAVENCIMENTO,val.DIADATAVENCIMENTO), parseFloat(val.VOP)); //Matrix XY Dia(UTC)/ Valor(Float)
		});
	}).always(function() {
			CriarGraficoDeAreaTimeSeries(NomeCedente, valores);
			ChamaLinha(cedente_);
	});

}

	
function CriarGraficoDeAreaTimeSeries(cedente_, valores_)  /*TIME SERIES*/
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
                text: null
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
	            pointStart:  valores_[0],
                data: valores_				
	        }]
        });
		
    });
}

//************************************GRAFICO DE LINHAS -************ TOP 5 SACADOS NO CEDENTE - EVOLUCAO DE OPERACAO***************
function ChamaLinha(cedente_){
	var NomeCedente         = $('#selectCedente :selected').text();
	var categoriasMensal_ = new Array();
	var c1 = new Array();

		//Captura retorno do JSON vindo de uma XACTION com query MDX
			$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:getData.xaction/generatedContent?&getData=6&Cedente='+NomeCedente+'&Ano='+getAno()+'&Mes='+getMesAtual(), function(data) {	
			
					//loop nos cabeçalhos
					$.each(data.result.metadata.columns, function(key, val) {
								if (key >0){
									categoriasMensal_[key-1] = val
								}
					});
					
					//loop nas linhas
					$.each(data.result.data, function(key, val) {
						
						//alimenta array com o resultado de acordo com a posição que vem no arquivo JSON
						c1[key] = 
						{
						  name: val[0] ,
						  data:[ new Array(0,parseFloat(val[1])), new Array(1,parseFloat(val[2])) , new Array(2,parseFloat(val[3])), new Array(3,parseFloat(val[4])), new Array(4,parseFloat(val[5])),new Array(5,parseFloat(val[6])),new Array(6,parseFloat(val[7])), new Array(7,parseFloat(val[8])),new Array(8,parseFloat(val[9])),new Array(9,parseFloat(val[10])),new Array(10,parseFloat(val[11])),new Array(11,parseFloat(val[12]))]
						}
						
											
					});
						//Chama função que gera o grafico e passa o array com os valores
						CriarChartLinhaPorCedente(categoriasMensal_,c1, NomeCedente);
			});
}

function CriarChartLinhaPorCedente(categorias_, series_, cedente_)
{
var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'GraficoLinhaBaixo',
                type: 'line',
                 marginRight: 350
  
            },
            title: {
                text: cedente_,
                x: -20 //center
				
            },
            subtitle: {
                text: '',
                x: -20
            },
            xAxis: {
               categories: categorias_
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
                y: 54,
				x: -30,
                borderWidth: 0,
				enabled: true				
            }
			
			,
            credits: {
                enabled: false
            },
        
			
		    series:series_
		});
    });
	
$.unblockUI();
}

</script>

</head>
<body onload="javascript: loadData()" style="background-color:#414141">
  

<div style="padding:0px 0px 0px 0px; height:120%">

<div class="container" >
    <!-- CLASSE QUE DEFINE O CONTAINER COMO FLUIDO (100%) -->
    <div class="container-fluid" >
	    <div class="row-fluid">
	    			
            <!-- COLUNA OCUPANDO 10 ESPA&#231;OS NO GRID -->
            <div class="col-md-12">
			
			
			<div class="row">
				   <div class="col-md-12">
				   
					<h1 id="mostra">
						<div class="BordaFiltro" align="center">
							<img src="/BibliotecaWBABI/img/Dashboards/edit.png" width="20px" class="ImagenFiltro">
						</div>
					</h1>

					<div id="oculto" style="display: none;" class="Filtros" >
						<div id="filtros">
						
						
									<label style="color:white">Posição</label><br>
									  <select  style="width:100%;" id="selectPosicoesHistoricas" onchange="javascript: AcaoComboHistorico();">
									</select>
									
									<label style="color:white">Empresa</label><br>
									  <select  style="width:100%;" id="selectEmpresa" onchange="javascript: AcaoComboEmpresa();">
									</select>
									
									<label style="color:white">Cedente</label><br>
									  <select  style="width:100%;" id="selectCedente" onchange="javascript: AcaoComboCedente();">
									</select>
						</div>
						
					</div>
			
			     </div>
			</div>	 

			
			
				
				<div class="row">
				   <div class="col-md-6">
					  <div  class="BordasArredondadas">
					  <div class="TituloDash">Recebiveis Carteira - CEDENTE </div>
					  <div id="GraficoPizza" class="AreaGrafica"></div></div>
				   </div>
				   <div class="col-md-6">
					  <div  class="BordasArredondadas">
					  <div class="TituloDash">Evolução de Operação</div>
					  <div id="GraficoLinha1" class="AreaGrafica"></div></div>
				   </div>
				</div>

				<div style="padding:0.9%"></div>


				<div class="row">
	  			    <div class="col-md-12">
						<div  class="BordasArredondadas" style="width:99%">
							<div class="TituloDash">Evolução de Operação - Top 5 Sacados</div>
							<div id="GraficoLinhaBaixo" class="AreaGrafica"></div>
						</div>
					</div>
				</div>
				
				
				

			</div>
			
         </div>
    </div>
	
	</div>
	
 
</div>
	
	
</body>
</html>
