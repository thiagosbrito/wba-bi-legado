<html>
<head>
<title></title>


	
	
    <link href="/BibliotecaWBABI/css/bootstrap/bootstrap_Preto.css"      rel="stylesheet"   type="text/css"/>
    <link href="/BibliotecaWBABI/css/bootstrap/bootstrap-responsive.css" rel="stylesheet"   type="text/css"/>
	<link href="/BibliotecaWBABI/css/Dashboards/DashscreenBlack.css"     rel="stylesheet"   type="text/css"/>
	<link   rel="stylesheet"       href="/BibliotecaWBABI/plugin/DataTables/media/css/jquery.dataTables.css" />
	<link   rel="stylesheet"       href ="/BibliotecaWBABI/plugin/chosen/chosen/chosen.css"/>
	
	<script src="/BibliotecaWBABI/js/jquery.min.js"></script>
	<script type="text/javascript" src="/BibliotecaWBABI/js/betaHightChats/highcharts.js"></script>
	<script type="text/javascript" src="/BibliotecaWBABI/js/betaHightChats/highcharts-more.js"></script> 
	<script type="text/javascript" src="/BibliotecaWBABI/js/FuncoesBasicas.js"></script>
	<script type="text/javascript" src="/BibliotecaWBABI/js/GraficosWBA.js"></script>
	<script type="text/javascript" src="/BibliotecaWBABI/plugin/DataTables/media/js/jquery.dataTables.js"></script>
	<script type="text/javascript" src  ="/BibliotecaWBABI/plugin/chosen/chosen/chosen.jquery.js"></script>
	<script type="text/javascript" src  ="/BibliotecaWBABI/plugin/jquery.selectboxes/jquery.selectboxes.js"></script>
    <script type="text/javascript" src  ="/BibliotecaWBABI/js/bootstrap.min.js"></script>
	<script type="text/javascript" src=" /BibliotecaWBABI/plugin/BlockUI/jquery.blockUI.js"></script>

	<style>
	.AreaGrafica
	{
		height:200px;
	}
	</style>
	

<script type="text/javascript">
	function  loadData(){
		ThemaDark(); //Aplica o Thema aos dashbord
		ChamarGraficoDePizza();
		ChamarGraficoDeBarra();
}

//Função que carrega a planilha de acordo com o gauge selecionado
function linkGauge(empresa)
{
	chamaTabela(empresa);
}

//Função que direciona para a pagina correspondente a fatia da pizza
function trocaDePagina(grafico, tipo, empresa)
{

	if (tipo == 'Contencioso')
	{
		window.location = RecuperaURL_Raiz()+"Carteira_2?empresa="+empresa;
	}
	else
	{
		window.location = RecuperaURL_Raiz()+"Carteira_4?empresa="+empresa;
	}	
}


//***********************************GRAFICO DE PIZZA -*************************** TOP 5 CEDENTES - CONCENTRACAO***************
function ChamarGraficoDePizza()
{
	var categoriasLabels = new Array();
	var categorias = new Array();
	var novoArray = new Array();
	
	//Captura retorno do JSON vindo de uma XACTION com query MDX
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=pizza1', function(data) {	
 			

			
				$.blockUI({ message: '<h1>Aguarde por favor...</h1>',css: {
					border: 'none', 
					padding: '15px', 
					backgroundColor: '#000', 
					'-webkit-border-radius': '20px', 
					'-moz-border-radius': '20px', 
					opacity: .9, 
					color: '#fff'
					}
	}); 	
	
	
				//loop nas linhas do cabeçalho
				$.each(data.result.metadata.columns, function(key, val) {
						 if (key >0){  // Pegar <> de metrica
						//alimenta array com o resultado de acordo com a posição que vem no arquivo JSON
							categoriasLabels[key-1] =  val;
						 }
				});
						
				//loop nas linhas
				$.each(data.result.data, function(key, val) {
					novoArray = val.toString().split(',');
				});
				
				//Monta array para grafico
				for (i=0; i < novoArray.length-1; i++){
					categorias[i] =  new Array(categoriasLabels[i],parseFloat(novoArray[i+1]));
				}
				
				//Chama função que gera o grafico e passa o array com os valores
				CriarPizza(categorias);
				
				
	});
	
	
}

function CriarPizza(categorias_)
{	
//TravaTela(1);		
var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'GraficoPizza1',
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
					
					,
					 point: {
					    events: {
					
							click: function() {
								 
							     //trocaDePagina('pizza',this.name,'consolidado');
								trocaDePagina('pizza',this.name,'0');
							}
					   }
				    }
		        }
			}, 
				series: [{
                type: 'pie',
                name: 'pie	',
                data: categorias_  
			}] 
		});
    });
	

}


function ChamarGraficoDeBarra()
{
	var categoriasEmpresa = new Array();
	var valoresContencioso = new Array();
	var valoresRecebiveis = new Array();

	//Captura retorno do JSON vindo de uma XACTION com query MDX
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=bar', function(data) {	
			
				//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
				
				$.each(data.result.data, function(key, val) {

								categoriasEmpresa[key]  = val[0];  //1=Factoring 2=Fidc
								valoresContencioso[key] = parseFloat(val[2]);
								valoresRecebiveis[key]  = parseFloat(val[1]);
				});
				
				
				//Chama função que gera o grafico e passa o array com os valores
				CriarGraficoBarraDupla(categoriasEmpresa,valoresContencioso,valoresRecebiveis);
				
				
				 ChamarGraficoGauge("0"); //Consolidado
				 ChamarGraficoGauge("1"); //Factoring
				 ChamarGraficoGauge("2"); //Fidc
				 chamaTabela("0");//Inicia tabela com Consolidado
				 
				 				
				
				
	});
	
	
}


function CriarGraficoBarraDupla(categoriasEmpresa_, valoresContencioso_, valoresRecebiveis_){

var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'GraficoDeBarrasLateral',
                type: 'bar' 
            },
            title: {
                text: null
            },
            subtitle: {
                text: null
            },
            xAxis: {
                categories: categoriasEmpresa_,
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
					
					
					,
					 point: {
					    events: {
					
							click: function() {
								
//								trocaDePagina('bar',this.series.name,this.series.data[this.x].category);
								trocaDePagina('bar',this.series.name,this.x+1);

								
							}
					   }
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
                name: 'Contencioso',
                data: valoresContencioso_				
                }, 
				{
                name: 'Recebiveis',
                data: valoresRecebiveis_
               }]
        });
    });
	
	
}

function ChamarGraficoGauge(empresa)
{
  if (empresa == "0") //Consolidada
  {      
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=gaugeConsolidado', function(data) {	
				//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
			$.each(data.result.data, function(key, val) {
					  montaKPI(parseFloat(val[1].toString().substring(4,0)),'KPI_Top5Cedentes');
				});
	});	  	  
  }
  if (empresa == "1") //Factoring 
  {	
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=gaugeFactoring', function(data) {	
				//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
				$.each(data.result.data, function(key, val) {
					 montaKPI(parseFloat(val[1].toString().substring(4,0)),'KPI_Top5_Cedentes');
				});
	});	
  }
  if (empresa == "2") //Fidc
  {
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=gaugeFidc', function(data) {	
				//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
				$.each(data.result.data, function(key, val) {
					montaKPI(parseFloat(val[1].toString().substring(4,0)),'KPI_Concentracao_Carteira');
				});
	});
  }
}



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
            max: 5,
            
            minorTickInterval: 'auto',
            minorTickWidth: 1,
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
                to: 2,
                color: '#55BF3B' // green
            }, {
                from: 2,
                to: 3,
                color: '#DDDF0D' // yellow
            }, {
                from: 3,
                to: 5,
                color: '#DF5353' // red
            }] 



			
        },
    
        series: [{
            name: '%',
            data: [valor_],
            tooltip: {
                valueSuffix: null
            }
		}]
    
    }
	
	
	
	
	);
	$.unblockUI();
}
function chamaTabela(empresa)
{


//limpa tabela
		$('#tabela').html();
		
		$('#tabela').html("<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\"  id=\"Tabela_Top5Cedentes\" width=\"100%\"><thead><tr><th style='width:100%'>CEDENTE </th><th>% CONCENTRAÇÃO</th><th>VALOR TITULO</th></tr></table>"); 
					
					$.extend( $.fn.dataTable.defaults, {
						"bFilter": false,
						"bSort": false,
						"bLengthChange":false,
						"bInfo":false,
						"oLanguage":{
							"sProcessing":   "Processando...",
							"sLengthMenu":   "Mostrar _MENU_ registros",
							"sZeroRecords":  "N&atilde;o foram encontrados resultados",
							"sInfo":         "Mostrando de _START_ at&eacute; _END_ de _TOTAL_ registros",
							"sInfoEmpty":    "Mostrando de 0 at&eacute; 0 de 0 registros",
							"sInfoFiltered": "(filtrado de _MAX_ registros no total)",
							"sInfoPostFix":  "",
							"sSearch":       "Buscar:",
							"sUrl":          "",
							"oPaginate": {
								"sFirst":    "Primeiro",
								"sPrevious": "Anterior",
								"sNext":     "Seguinte",
								"sLast":     "&Uacute;ltimo"
							}
						}
    					} );
						
					table = $('#Tabela_Top5Cedentes').dataTable();		
										
					  if (empresa == "0") //Consolidada
					  {      
							$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=tabelaCedente', function(data) {	
									$('#Empresa').html("Consolidada");
									//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
									$.each(data.result.data, function(key, val) {
										 
										table.fnAddData( [
											val[0],
											(parseFloat(val[1])*100).toString().substring(4,0)	,
											 moeda(val[2],2,',','.')
											]
										); 
										
									  
formataTabela();
										 
										 
									});
						});	  	  
					  }
					  
					  if (empresa == "1") //Factoring
					  {      
							$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=tabelaCedenteFactoring', function(data) {	
									
									
								
									$('#Empresa').html("Factoring");
									//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
									$.each(data.result.data, function(key, val) {
										 
										
										 
										table.fnAddData( [
											val[0],
											(parseFloat(val[1])*100).toString().substring(4,0)	,
											moeda(val[2],2,',','.')
											]
										); 
										 
	formataTabela();									 
									});
						});	  	  
					  }
					  
					  if (empresa == "2") //FIDC
					  {      
							$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=tabelaCedenteFidc', function(data) {	
							$('#Empresa').html("Fidc");	
									//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
									$.each(data.result.data, function(key, val) {
										 
										table.fnAddData( [
											val[0],
											(parseFloat(val[1])*100).toString().substring(4,0)	,
											 moeda(val[2],2,',','.')
											]
										); 
										 
formataTabela();																		
									
									});
									
									
						});	  	  
					  }

					  
}

function formataTabela()
{
	$('#Tabela_Top5Cedentes thead tr').css("text-align","left");
	$('#Tabela_Top5Cedentes thead tr').css("font-size","14");
}
</script>

</head>
<body  onload="javascript: loadData()" style="background-color:#414141">
	
<div  style="padding:0px 0px 0px 0px">
<div class="container" >
    <!-- CLASSE QUE DEFINE O CONTAINER COMO FLUIDO (100%) -->
    <div class="container-fluid" >
	    <div class="row-fluid">
	    			
            
			   <div class="row">
			    <div class="span12">
					<div class="TituloDash" width="98%">Qualidade da Carteira</div>
				</div>
			   </div>

			   <div style="padding:0.2%"></div>
	
				<div class="row">
				   <div class="span6">
					  <div class="TituloDash">Carteira - Consolidado</div>
					  <div id="GraficoPizza1" class="AreaGrafica"></div>
				   </div>
				   <div class="span6">
					  
					  <div class="TituloDash">Carteira - Empresa</div>
					  <div id="GraficoDeBarrasLateral" class="AreaGrafica"></div>
				   </div>
				</div>
				
			   <div style="padding:0.9%"></div>

			   <div class="row">
			    <div class="span12">
					<div class="TituloDash">KPI - Concentração Contencioso</div>
				</div>
			   </div>

			   <div style="padding:0.2%"></div>

			   <div class="row">
   			       <div class="span4">
					  <div class="TituloDash">Consolidado</div>
					  	<a  href='javascript:linkGauge(0);'><div id="KPI_Top5Cedentes" class="AreaGrafico" style="height:50%"></div></a>
				   </div>
				   <div class="span4">
					  <div class="TituloDash">FIDC</div>
					    <a href='javascript:linkGauge(2);'><div id="KPI_Concentracao_Carteira" class="AreaGrafico" style="height:50%" ></div></a>
				   </div>
   				   <div class="span4">
					  <div class="TituloDash">Factoring</div>
					  <a href='javascript:linkGauge(1);'><div id="KPI_Top5_Cedentes" class="AreaGrafico" style="height:50%"></div></a>
				   </div>
				</div>
				
				<div style="padding:0.9%"></div>
			
			<div class="row">
				   <div class="span12">
						<div class="TituloDash">Top 20 - Cedente - <span id="Empresa"></span></div>
						<div id="tabela" ></div>
				   </div>
			</div>  
         </div>
    </div>
</div>
	


 
</body>
</html>
