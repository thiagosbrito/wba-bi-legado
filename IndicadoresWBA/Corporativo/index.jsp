<!DOCTYPE HTML>
<html lang="pt-Br">
<head>
    <meta charset="UTF-8">
    <title>WBA BI - Indicadores Chave de Desempenho</title>
	
	<script src="/BibliotecaWBABI/POC/js/jquery.min.js"></script>
	<link href="/BibliotecaWBABI/css/bootstrap/bootstrap_Preto.css"      rel="stylesheet"   type="text/css"/>
    <!-- <link href="/BibliotecaWBABI/css/bootstrap/bootstrap-responsive.css" rel="stylesheet"   type="text/css"/> -->
    <link rel="stylesheet" href="/BibliotecaWBABI/plugin/bootstrap/css/bootstrap.min.css">
	<link href="/BibliotecaWBABI/css/Dashboards/DashscreenBlack.css"     rel="stylesheet"   type="text/css"/>
	
    <script src="/BibliotecaWBABI/plugin/bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src=" /BibliotecaWBABI/js/betaHightChats/highcharts.js"></script>
	<script type="text/javascript" src=" /BibliotecaWBABI/js/FuncoesBasicas.js"></script>
	<script type="text/javascript" src=" /BibliotecaWBABI/js/GraficosWBA.js"></script>
    <script type="text/javascript" src=" /BibliotecaWBABI/plugin/BlockUI/jquery.blockUI.js"></script>

	<style>
	.AreaGrafica
	{
		height:235px;
		
	}
	</style>
	
	
<script type="text/javascript">
var EnderecoJsonPrincipal = "/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:DesempenhoOperacao.xaction/generatedContent?&";
function  loadData(){
    var categorias = new Array();
	var valores    = new Array(); 
	hoje = new Date()
	ano = hoje.getFullYear();
	
	ThemaDark(); //Aplica o Thema aos dashbord
		
		
	//Monta Grafico;
	$.getJSON(EnderecoJsonPrincipal+'getData=1&Ano='+ano, function(data) {	
		
		$.each(data.result.data, function(key, val) {
			//console.log(data.result.data);		
							// Serializando  variaveis
							categorias[key] =  val[0];
							valores[key]    =  parseFloat(val[1]);
							// fim serializando  variaveis	
						
						    //chama o grafico
						    CriarChart(categorias,valores);
								
					});
					
					
					ChamaLinha(categorias[categorias.length-1]);
	});	
		
			
}
function ChamaLinha(ano_){
	var Categorias    = new Array();
	var Dados         = new Array();
	var Empresas      = new Array();	
	
	$.getJSON(EnderecoJsonPrincipal+'getData=2&Ano='+ano_, function(data) {	
		
		}).done(function(data) {
		/*
		console.log(JSON.stringify(
			{
                name: 'Tokyo',
                data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
            }
			));
		*/
		
			//Categorias
			$.each(data.result.metadata.columns, function(key, val) {
				if (key >0){
					Categorias[key-1] = val;
				}
			});
			
			
			//Array de Empresas
			$.each(data.result.data, function(key, val) {
			       Empresas[key]  =  decodeURIComponent(val[0]);
			});
			
			
			//Dados
			$.each(data.result.data, function(key, val) {
				ArryAux = new Array();
				for (i=0; i <= Categorias.length-1 ; i++)
				{
					ArryAux[i] = getNum(parseFloat(val[i+2]));
				}
				Dados[key] = ArryAux;
			});
			console.log(Dados);
		
	}).always(function() {
		
		var RenderTo      = "GraficoLinha";
		var tituloGrafico ="";
		
		//monta series
		var Auxiliar = "";
		for (i=0; i< Empresas.length; i++)
		{
			Auxiliar=Auxiliar+'{"name":0,"data": 0},'
		}
		Auxiliar = Auxiliar.substr(0,Auxiliar.length-1);
		Auxiliar = "["+Auxiliar+"]";
		
		series = JSON.parse(Auxiliar);
		
		console.log(series);
			
		for (i=0; i< Empresas.length; i++)
		{
			series[i].name = 	Empresas[i];
			series[i].data =    Dados[i];
		}
		
		//Chama grafico
		GraficoDeLinhaMultiLinhas(RenderTo,tituloGrafico,Categorias,series);
	});			
}

function CriarChart (categorias_, valores_)
{
    var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'GraficoBarras',
                type: 'column'
				
            },
			colors: [
					'#4169E1'
			],
			title: {
                text: null//'Volume de Operações'
            },
            subtitle: {
                text: ''
            },
            xAxis: {
                categories: categorias_
            },
            yAxis: {
                min: 0,
                title: {
                    text: ''
                }
            },
            legend: {
                layout: 'horizontal',
                backgroundColor: '#FFFFFF',
                align: 'left',
                verticalAlign: 'top',
                x: 100,
                y: 70,
                floating: true,
                shadow: true,
				enabled: false	
            }
			
			, credits: {
                enabled: false
            }
			,
			tooltip: {
                formatter: function() {
                    return 'R$ '+ formatNumber(this.y);
                }
            },
            plotOptions: {
                column: {
                    pointPadding: 0,
                    borderWidth: 0.1,
					point: {
							events: {
								click: function() {
									console.log(this.category);
									ChamaLinha(this.category);
								}
							}
						}
			    }
            },
                series: [{
                name: 'geração atual',
                data: valores_
		    }]
        });
    });   
}





function GraficoDeLinhaMultiLinhas(RenderTo,Titulo,Categorias,Dados)
{
var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: RenderTo,
                type: 'line',
                marginRight: 120,
                marginBottom: 25
				
            },
            title: {
                text: Titulo,//'Geração Mensal',
                x: -20 //center
            },
            subtitle: {
                text: '',
                x: -20
            },
            xAxis: {
                categories: Categorias
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
                        return '<b>'+ this.series.name +'</b><br/>'+
                        this.x +': '+ 'R$ '+ formatNumber(this.y);
                }
            }
			,
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'top',
                x: 10,
                y: 60,
                borderWidth: 0,
				enabled: true				
            }
			
			, credits: {
                enabled: false
            }
			,
            series: Dados
        });
    });
}
</script>	
	
</head>
<body onload="javascript:loadData()" style="background-color:#414141">
  

<div  style="padding:0px 0px 0px 0px;  height:120%">

<div class="container" >
    <!-- CLASSE QUE DEFINE O CONTAINER COMO FLUIDO (100%) -->
    <div class="container-fluid" >
	    <div class="row">
	    	<div class="row" ><div class="span12">.</div></div>

            <!-- COLUNA OCUPANDO 10 ESPA&#231;OS NO GRID -->
            <div class="span12">
			 
		<div class="BordasArredondadas">			 
  			  <div class="TituloDash">Volume de Operações</div>
			  <div id="GraficoBarras" class="AreaGrafica">Grafico 1</div>
	    </div>
       <div style="padding:0.9%"></div>
		<div class="BordasArredondadas">
			  <div class="TituloDash">Geração Mensal</div>
			  <div id="GraficoLinha" class="AreaGrafica">Grafico 2</div>
		</div>	  
        

		</div>
			
         </div>
    </div>
	
	</div>
	
 
</div>
	
	
</body>
</html>
