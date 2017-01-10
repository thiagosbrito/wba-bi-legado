<!DOCTYPE html>
<html lang="pt-Br">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Painel Carteira</title>
    <link href="/BibliotecaWBABI/css/bootstrap/bootstrap_Preto.css"      rel="stylesheet"   type="text/css"/>
    <!-- <link href="/BibliotecaWBABI/css/bootstrap/bootstrap-responsive.css" rel="stylesheet"   type="text/css"/> -->
	<link href="/BibliotecaWBABI/css/Dashboards/DashscreenBlack.css"     rel="stylesheet"   type="text/css"/>
	<link href="/BibliotecaWBABI/plugin/DataTables/media/css/jquery.dataTables.css"  rel="stylesheet"/>
	<link href ="/BibliotecaWBABI/plugin/chosen/chosen/chosen.css"       rel="stylesheet"       />
	
	<script src="/BibliotecaWBABI/js/jquery.min.js"></script>
	<script type="text/javascript" src="/BibliotecaWBABI/js/betaHightChats/highcharts.js"></script>
	<script type="text/javascript" src="/BibliotecaWBABI/js/betaHightChats/highcharts-more.js"></script> 
	<script type="text/javascript" src="/BibliotecaWBABI/js/FuncoesBasicas.js"></script>
	<script type="text/javascript" src="/BibliotecaWBABI/js/GraficosWBA.js"></script>
	<script type="text/javascript" src="/BibliotecaWBABI/plugin/DataTables/media/js/jquery.dataTables.js"></script>
	<script type="text/javascript" src  ="/BibliotecaWBABI/plugin/chosen/chosen/chosen.jquery.js"></script>
	<script type="text/javascript" src  ="/BibliotecaWBABI/plugin/jquery.selectboxes/jquery.selectboxes.js"></script>
    <script type="text/javascript" src  ="/BibliotecaWBABI/plugin/bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src=" /BibliotecaWBABI/plugin/BlockUI/jquery.blockUI.js"></script>

	<style>
	.AreaGrafica
	{
		height:40%;
	}
	</style>
	

<script type="text/javascript">
function  loadData()
{
		ThemaDark(); //Aplica o Thema aos dashbord
		ChamarGraficoDePizza();
		ChamarGraficoDeBarra();
		ChamarGraficosKPI(); //KPI_rpassos_Dinamicos
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
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=RecebiveisEVencidos', function(data) {	 			

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
	var Barra1 = new Array();
	var Barra2 = new Array();

	//Captura retorno do JSON vindo de uma XACTION com query MDX
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=RecebiveisEVencidosPorEmpresa', function(data) {	
			
				//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
				
				$.each(data.result.data, function(key, val) {
								categoriasEmpresa[key]  = val[0];  //Empresa   1=Factoring 2=Fidc
								Barra1[key] = parseFloat(val[1]); //Recebiveis
								Barra2[key]  = parseFloat(val[2]); //Vencidos
				});
				//Chama função que gera o grafico e passa o array com os valores
				CriarGraficoBarraDupla(categoriasEmpresa,Barra1,Barra2);
	});
}
function CriarGraficoBarraDupla(categoriasEmpresa_, barra1_, barra2_)
{

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
                name: 'Recebiveis',
                data: barra1_				
                }, 
				{
                name: 'Vencidos',
                data: barra2_
               }]
        });
    });
	
	
}
function ChamarGraficosKPI()
{
	var HTMLDinamico_rpassosfranco = "<div class='span_nspan'> <div class='TituloDash'>_EMPRESA_</div><a  href='javascript:linkGauge(0);'><div id='KPI_Top5Cedentes'></div></a></div>";
	var HTMLDinamico_rpassosfranco2;
	var ValorConsolidado=0;
	var nEmpresasReal=0;
	var nEmpresas=0;
	var nomeEmpresa;
	var Aux =0;
	
	//Captura retorno do JSON vindo de uma XACTION com query MDX
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=RecebiveisEVencidosPorEmpresa', function(data) {	
			
				//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
				
				//Numero de Empresas
				$.each(data.result.data, function(key, val) {
				    nEmpresas = nEmpresas+1;
				    nEmpresasReal = nEmpresasReal+1;
					ValorConsolidado = ValorConsolidado+parseFloat(val[2]);
				    nomeEmpresa = val[0];
				 });
				 
				 if (nEmpresas == 1)
				 {
				    nEmpresas = 12;
				 }
				 if (nEmpresas == 2)
				 {
				    nEmpresas = 4;
				 }
				

				$.each(data.result.data, function(key, val) {
				    
                       					
				    var elem = val[0].split(' '); //Converte nome da empresa em Array
				    var nomeEmpresaTratado = elem[0]+' '+elem[1]; //Retorna os 2 primeiros nomes da empresa

			
				 
					 var aux= (Math.round(((parseFloat(val[2])/parseFloat(ValorConsolidado))*100)));
					 //Monta HTML Dinamico
					 HTMLDinamico_rpassosfranco2 = HTMLDinamico_rpassosfranco.replace('KPI_Top5Cedentes',val[0]);
					 HTMLDinamico_rpassosfranco2 = HTMLDinamico_rpassosfranco2.replace('_EMPRESA_',nomeEmpresaTratado);
					 HTMLDinamico_rpassosfranco2 = HTMLDinamico_rpassosfranco2.replace('_nspan',nEmpresas);
					 HTMLDinamico_rpassosfranco2 = HTMLDinamico_rpassosfranco2.replace('0','"'+val[0]+'"');
					 $('#KPI_rpassos_Dinamicos').html($('#KPI_rpassos_Dinamicos').html()+HTMLDinamico_rpassosfranco2);
						
						//Adiciona valores no KPI	
						
						
						setTimeout(function() {montaKPI(aux,val[0]);},0);				
						
						
						
				 });
				
				
				
				if (nEmpresasReal > 1){
				 
					 //Gera Consolidado
					 HTMLDinamico_rpassosfranco2 = HTMLDinamico_rpassosfranco.replace('KPI_Top5Cedentes','KPI_Top5Cedentes_Consolidado');
					 HTMLDinamico_rpassosfranco2 = HTMLDinamico_rpassosfranco2.replace('_EMPRESA_','CONSOLIDADO');
					 HTMLDinamico_rpassosfranco2 = HTMLDinamico_rpassosfranco2.replace('_nspan',nEmpresas);
					 $('#KPI_rpassos_Dinamicos').html($('#KPI_rpassos_Dinamicos').html()+HTMLDinamico_rpassosfranco2);
					 montaKPI(((parseFloat(ValorConsolidado)/ValorConsolidado)*100),'KPI_Top5Cedentes_Consolidado');
				}

				
				 chamaTabela(nomeEmpresa);//Inicia tabela com Consolidado
				
	});
				
}
function chamaTabela(empresa)
{


//limpa tabela
		$('#tabela').html();

		
		$('#tabela').html("<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\"  id=\"Tabela_Top5Cedentes\" width=\"100%\"><thead><tr><th style='width:100%'>CEDENTE </th><th>VALOR TITULO</th><th>% CONCENTRAÇÃO</th></tr></table>"); 
					
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
										
					$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=tabelaCedentePorEmpresa&Empresa='+empresa, function(data) {

					
					if (empresa=="0"){$('#Empresa').html("CONSOLIDADO");}else{$('#Empresa').html(empresa);}
									
									
									
									//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
									$.each(data.result.data, function(key, val) {
									 
									 if (key > 0){
										table.fnAddData( [
											val[0],
											moeda(val[1],2,',','.'),
											(parseFloat(val[2])*100).toString().substring(4,0)
											]
										);
																			
									}	
											
										formataTabela();
										 
										 
									});
						});	

}
function formataTabela()
{
	$('#Tabela_Top5Cedentes thead tr').css("text-align","left");
	$('#Tabela_Top5Cedentes thead tr').css("font-size","14");
	
	
	
	$(".dataTable").css({
	"table-layout": "auto",
	"width": "100%"
	
	});

	
	
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
			    <div class="col-md-12">
					<div class="TituloDash" width="98%">Qualidade da Carteira</div>
				</div>
			   </div>

			   <div style="padding:0.2%"></div>
	
				<div class="row">
				   <div class="col-md-6">
					  <div class="TituloDash">Carteira - Consolidado</div>
					  <div id="GraficoPizza1" class="AreaGrafica"></div>
				   </div>
				   <div class="col-md-6">
					  
					  <div class="TituloDash">Carteira - Empresa</div>
					  <div id="GraficoDeBarrasLateral" class="AreaGrafica"></div>
				   </div>
				</div>
				
			   <div style="padding:0.9%"></div>

			   <div class="row">
			    <div class="col-md-12">
					<div class="TituloDash">KPI - Concentração Vencidos</div>
				</div>
			   </div>

			   <div style="padding:0.2%"></div>

			   <div class="row" id="KPI_rpassos_Dinamicos">
   			   </div>
				
				<div style="padding:0.9%"></div>
			
			<div class="row">
				   <div class="col-md-12">
						<div class="TituloDash">Top Cedentes - <span id="Empresa"></span></div>
						<div id="tabela" ></div>
				   </div>
			</div>  
         </div>
    </div>
</div>
	


 
</body>
</html>
