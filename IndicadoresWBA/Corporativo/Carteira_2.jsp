<!DOCTYPE html>
<html lang="pt-Br">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>

    <link href="/BibliotecaWBABI/css/bootstrap/bootstrap_Preto.css"      rel="stylesheet"   type="text/css"/>
    <!-- <link href="/BibliotecaWBABI/css/bootstrap/bootstrap-responsive.css" rel="stylesheet"   type="text/css"/> -->
    <link rel="stylesheet" href="/BibliotecaWBABI/plugin/bootstrap/css/bootstrap.min.css">
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
    <script type="text/javascript" src  ="/BibliotecaWBABI/plugin/bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src=" /BibliotecaWBABI/plugin/BlockUI/jquery.blockUI.js"></script>
	
	
	
<script type="text/javascript">
function  loadData()
{
		ThemaDark(); //Aplica o Thema aos dashbord
//    	montaPizza();
//		MontaGraficoLinha();
	
	  var url   = window.location.search.replace("?", "");
	  var itens = url.split("&");
	  var empresa = itens[0].replace('empresa=','');
	  empresa = decodeURIComponent(empresa); //faz a codificação 
	  chamaTabela(empresa);
	  
	  chamaPizza(empresa);
	  
	  if (empresa == '0') {empresa = '1,2';}
	  ChamaGraficoArea(empresa);
	  
	  
}


function totalTabela()
{
var total = 0;
var num = 0;

$('#Tabela_Top5Cedentes tr').each(function(i) {
	if (i > 0 ){
		
	   var coluna = $(this).find('td:nth-child(3)').html();
	   num =  parseFloat(replaceAll(coluna,',','.'));
	   total += num;
	}
});

 $('#TotalSpan').html(total);
 
 formataTabela();
}

function formataTabela()
{

	$('#Tabela_Top5Cedentes thead tr').css("text-align","left");
	$('#Tabela_Top5Cedentes thead tr').css("font-size","14");
}

function chamaPizza(empresa)
{
	
	
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
	
	
	

var categoriasLabels = new Array();
var novoArray = new Array();
var categorias= new Array();


if (empresa == "0")
{
$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=EmAbertoVencido', function(data) {	



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
				for (i=0; i < novoArray.length; i++){
					categorias[i] =  new Array(categoriasLabels[i], Math.round(parseFloat(novoArray[i])));
				}
				
				//Chama função que gera o grafico e passa o array com os valores
				CriarPizza(categorias);


});

}


if (empresa == "1") //Factoring
{
$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=EmAbertoVencidoFactoring', function(data) {	


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
				for (i=0; i < novoArray.length; i++){
					categorias[i] =  new Array(categoriasLabels[i], Math.round(parseFloat(novoArray[i])));
				}
				
				//Chama função que gera o grafico e passa o array com os valores
				CriarPizza(categorias);


});

}



if (empresa == "2") //Fidc
{
$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=EmAbertoVencidoFidc', function(data) {	


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
				for (i=0; i < novoArray.length; i++){
					categorias[i] =  new Array(categoriasLabels[i], Math.round(parseFloat(novoArray[i])));
				}
				
				//Chama função que gera o grafico e passa o array com os valores
				CriarPizza(categorias);


});

}

}



function CriarPizza(categorias_)
{
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
                    return '<b>'+ this.point.name +'</b>: '+ Math.round(this.percentage) +' %';
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        color: '#000000',
                        connectorColor: '#000000',
                        formatter: function() {
                            return '<b>'+ this.point.name +'</b>: '+ Math.round(this.percentage) +' %';
                        }
                    }
                }
            }
			
			,
			credits: {
                enabled: false
            }
			,
             
				series: [{
                type: 'pie',
                name: 'pie	',
                data: categorias_  
			}] 
        });
    });
}

//--------------------------Grafico de Area

function ChamaGraficoArea(empresa)
{

	var valores    = new Array();
	var Categorias = new Array();
    var MesDesc;
	var Valor;
	
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=ContenciosoMes&Empresa='+empresa, function(data) {	


			//loop nas linhas 
				$.each(data.result.data, function(key, val) {
							MesDesc = val[1];
							Valor   = parseFloat(val[2]);
							
							
							
							Categorias[key] = MesDesc;
							valores[key] =  Valor;
					});	
				
				GraficoDelinha("GraficoDeLinha",Categorias,valores);
				
	});
				
}


function GraficoDelinha(renderTo_ , categorias_,valores_ )
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
                text: '',
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
                        return '<b>'+ this.series.name +'</b><br/>'+
                        this.x +': '+ moeda(this.y ,2,',','.');
                }
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'top',
                x: -10,
                y: 100,
                borderWidth: 0
            },
            series: [{
                name: 'CONTENCIOSO',
                data: valores_
            }]
        });
    });
	
	$.unblockUI();
}	
	



function MontaGraficoLinha()
{

 var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'GraficoDeLinha',
                type: 'line',
                marginRight: 130,
                marginBottom: 25
            },
            title: {
                text: null,
                x: -20 //center
            },
            subtitle: {
                text: null,
                x: -20
            },
            xAxis: {
                categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
            },
            yAxis: {
                title: {
                    text: 'Valor'
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
            },
			credits: {
                enabled: false
            }
			,
            series: [{
                name: 'titulos',
                data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
            }]
        });
    });
	
	
}

function chamaTabela(empresa)
{
						

//limpa tabela
		$('#tabela').html();
		
		$('#tabela').html("<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\"  id=\"Tabela_Top5Cedentes\" width=\"100%\"><thead><tr><th style='width:100%;'>CEDENTE</th><th>%CONCENTRAÇÃO</th><th>VL. TITULO</th></tr></table>"); 
					
					$.extend( $.fn.dataTable.defaults, {
						"bFilter": false,
						"bSort": false,
						"bLengthChange":false,
						"bInfo":false,
						"bPaginate":false,
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
											 moeda(val[2],2,',','.'),
											formatNumber(val[2])
											]
										); 
									
																
									$('#Tabela_Top5Cedentes tbody tr').css("font-size","12");
																								
										
									$('#Tabela_Top5Cedentes tbody tr').click( function () {
										//alert($('td', this).html() );
										window.location = RecuperaURL_Raiz()+"Carteira_3?id="+$('td', this).html();
									} );
									
									
									
									$('#Tabela_Top5Cedentes tbody tr').mouseover( function () {
										$(this).css("color","blue");
										$(this).css("font-weight","bold");
									} ).mouseout(function() {
									
										$(this).css("color","black");
										$(this).css("font-weight","normal");
								
									});
									
									 
									});
									
									totalTabela();
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
											 moeda(val[2],2,',','.'),
											formatNumber(val[2])
											]
										); 
										
									$('#Tabela_Top5Cedentes tbody tr').css("font-size","12");
									$('#Tabela_Top5Cedentes tbody tr').css("text-align","justify");
									
									
									
										
									$('#Tabela_Top5Cedentes tbody tr').click( function () {
										//alert($('td', this).html() );
										window.location = RecuperaURL_Raiz()+"Carteira_3?id="+$('td', this).html();
									} );
									
									
									
									$('#Tabela_Top5Cedentes tbody tr').mouseover( function () {
										$(this).css("color","blue");
										$(this).css("font-weight","bold");
									} ).mouseout(function() {
									
										$(this).css("color","black");
										$(this).css("font-weight","normal");
								
									});
									
									
									});
									
									totalTabela();
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
											 moeda(val[2],2,',','.'),
											formatNumber(val[2])
											]
										); 
										
									$('#Tabela_Top5Cedentes tbody tr').css("font-size","12");
									$('#Tabela_Top5Cedentes tbody tr').css("text-align","justify");
									
									
										
									$('#Tabela_Top5Cedentes tbody tr').click( function () {
										//alert($('td', this).html() );
										window.location = RecuperaURL_Raiz()+"Carteira_3?id="+$('td', this).html();
									} );
									
									
									
									$('#Tabela_Top5Cedentes tbody tr').mouseover( function () {
										$(this).css("color","blue");
										$(this).css("font-weight","bold");
									} ).mouseout(function() {
									
										$(this).css("color","black");
										$(this).css("font-weight","normal");
								
									});
									
									});
									
									totalTabela();
						});	  	  
						
						

					  }
					  
					  
}
</script>

	
</head>
<body  onload="javascript: loadData()" style="background-color:#414141">







<div  style="padding:0px 0px 0px 0px">
   <div class="container" >
    <div class="container-fluid" >
	    <div class="row-fluid">
	    			
			   <div class="row">
			     <div class="col-md-12">
			       <div class="TituloDash" width="98%">15 Maiores Cedentes</div>
			     </div>
			   </div>
			   
			   <div class="row">
			    <div class="col-md-6">
            <div class="panel panel-default">
              <div class="panel-body">
				        <div id="tabela" style="width:96%;padding:10px"></div>
      					</br>
      					<span style="color:#ffffff">Total: <span id="TotalSpan"></span></span>
              </div>
            </div>
				</div>
				<div class="col-md-6">
          <div class="panel panel-default">
            <div class="panel-body">
  					  <div id="GraficoPizza1" class="AreaGrafico" style="height:400px"></div>
  					  <div style="padding:0.5%"></div>
  					  <div id="GraficoDeLinha" class="AreaGrafico" style="height:400px"></div>
            </div>
          </div>
				</div>
			   </div>

			   
					
					
					
		</div>
	</div>
  </div>	
</div>		




<!--
	
<div id="content-outer" style="padding:20px">
<div class="BordasArredondadasFULL" style="padding:0px 0px 10px 10px">

			<div class="TituloDash">CONTENCIOSO - <span id="Empresa"></span></div>
			<table border="0" width="100%" height="100%" cellspacing="10" >
						<tr>
						  <td  valign="top" style="width:500px">
							  </div>						      
							  <div class="TituloDash">
							  15 Maiores Cedentes</div>
						       <div id="tabela" style="width:96%;padding:10px"></div>
							   <br>
							   <span style="color:#ffffff">Total: <span id="TotalSpan"></span></span>
							
						  </td>
						  <td valign="top">
						
							<br>
							<table class="BordasArredondadas">
									<tr>
									  <td align="center" valign="midle" class="AreaGraficoTD">
										 <div id="GraficoPizza1" class="AreaGrafico" style="height:400px"></div>
									  </td>
									</tr>
							</table>
							<br><br>
							<table class="BordasArredondadas">
									<tr>
									  <td align="center" valign="midle" class="AreaGraficoTD">
									   <div id="GraficoDeLinha" class="AreaGrafico" style="height:400px"></div>
									  </td>
									</tr>
									
							</table>
								
						</td>
						</tr>
							
			</table>
			
			
	

</div>
</div>

-->

</body>
</html>
