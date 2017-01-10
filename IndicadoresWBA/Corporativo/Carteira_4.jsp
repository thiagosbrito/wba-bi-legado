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
	

	<style>
		.AreaGrafica
		{
			height:200px;
		}
	</style>
	
	
	<script type="text/javascript">
		function  loadData()
		{
	  ThemaDark(); //Aplica o Thema aos dashbord

	  var url   = window.location.search.replace("?", "");
	  var itens = url.split("&");
	  var empresa = itens[0].replace('empresa=','');
	  
	  
	  lerEmpresa(empresa);
	  ChamaPizza1(empresa);
	  ChamaPizza2(empresa);
	  chamaTabela(empresa);
	}

	function lerEmpresa(empresa)
	{ 
		if (empresa == "0")
		{
			$('#Empresa').html("Consolidada");
		}
		if (empresa == "1")
		{
			$('#Empresa').html("Factoring");
		}
		if (empresa == "2")
		{
			$('#Empresa').html("Fidc");
		}
	}
	function ChamaPizza1(empresa)
	{

		var categorias = new Array();


	if (empresa == "0") //Consolidada
	{ 
	//Captura retorno do JSON vindo de uma XACTION com query MDX
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=TipoProduto', function(data) {	

		$.each(data.result.data, function(key, val) {
			categorias[key] = new Array(val[0], parseFloat(val[1]));
		});

		CriarPizza(categorias, 'GraficoPizza1','0%');
	});
	
}

	if (empresa == "1") //Factoring
	{ 
	//Captura retorno do JSON vindo de uma XACTION com query MDX
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=TipoProdutoFactoring', function(data) {	

		$.each(data.result.data, function(key, val) {
			categorias[key] = new Array(val[0], parseFloat(val[1]));
		});

		CriarPizza(categorias, 'GraficoPizza1','0%');
	});
}

	if (empresa == "2") //Fidc
	{ 
	//Captura retorno do JSON vindo de uma XACTION com query MDX
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=TipoProdutoFidc', function(data) {	

		$.each(data.result.data, function(key, val) {
			categorias[key] = new Array(val[0], parseFloat(val[1]));

		});
		CriarPizza(categorias, 'GraficoPizza1' ,'0%');
	});
	
}
}

function ChamaPizza2(empresa)
{
	
	var categorias = new Array();

	var categoriasLabels = new Array();
	var categorias = new Array();
	var novoArray = new Array();
	
	if (empresa == "0") //Consolidada
	{ 
	//Captura retorno do JSON vindo de uma XACTION com query MDX
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=TipoRisco', function(data) {	


				//loop nas linhas do cabeçalho
				$.each(data.result.metadata.columns, function(key, val) {
						 if (key >0){  // Pegar <> de metrica
						//alimenta array com o resultado de acordo com a posição que vem no arquivo JSON
						categoriasLabels[key-1] =  val;
					}
				});

				//loop nas linhas
				$.each(data.result.data, function(key, val) {
					
					novoArray[0] = val[0];
					novoArray[1] = val[1];
				});
				
				//Monta array para grafico
				for (i=0; i < categoriasLabels.length; i++){

					categorias[i] =  new Array(categoriasLabels[i],parseFloat(novoArray[i]));
				}

				CriarPizza(categorias, 'GraficoPizza2' ,'40%');
				//chamaKPI_1(empresa);
				chamaKPI_2(empresa);
			});
	
}

	if (empresa == "1") //Factoring
	{ 
	//Captura retorno do JSON vindo de uma XACTION com query MDX
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=TipoRiscoFactoring', function(data) {	

			//loop nas linhas do cabeçalho
			$.each(data.result.metadata.columns, function(key, val) {
						 if (key >0){  // Pegar <> de metrica
						//alimenta array com o resultado de acordo com a posição que vem no arquivo JSON
						categoriasLabels[key-1] =  val;
					}
				});

				//loop nas linhas
				$.each(data.result.data, function(key, val) {
					
					novoArray[0] = val[0];
					novoArray[1] = val[1];
				});
				
				//Monta array para grafico
				for (i=0; i < categoriasLabels.length; i++){

					categorias[i] =  new Array(categoriasLabels[i],parseFloat(novoArray[i]));
				}

				CriarPizza(categorias, 'GraficoPizza2' ,'40%');
				//chamaKPI_1(empresa);
				chamaKPI_2(empresa);
			});
}

	if (empresa == "2") //Fidc
	{ 
	//Captura retorno do JSON vindo de uma XACTION com query MDX
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=TipoRiscoFidc', function(data) {	

			//loop nas linhas do cabeçalho
			$.each(data.result.metadata.columns, function(key, val) {
						 if (key >0){  // Pegar <> de metrica
						//alimenta array com o resultado de acordo com a posição que vem no arquivo JSON
						categoriasLabels[key-1] =  val;
					}
				});

				//loop nas linhas
				$.each(data.result.data, function(key, val) {
					
					novoArray[0] = val[0];
					novoArray[1] = val[1];
				});
				
				//Monta array para grafico
				for (i=0; i < categoriasLabels.length; i++){

					categorias[i] =  new Array(categoriasLabels[i],parseFloat(novoArray[i]));
				}
				
				CriarPizza(categorias, 'GraficoPizza2', '40%');
				//chamaKPI_1(empresa);
				chamaKPI_2(empresa);
			});
	
}


}

function totalTabela()
{
	var total = 0;
	var num = 0;

	$('#Tabela_Top5Cedentes tr').each(function(i) {
		if (i > 0 ){

			var coluna = $(this).find('td:nth-child(2)').html();
			num =   parseFloat(replaceAll(coluna,',','.'));
			total += num;
		}

	});

	$('#total').html(total);

	formataTabela();
}

function formataTabela()
{

	$('#Tabela_Top5Cedentes thead tr').css("text-align","left");
	$('#Tabela_Top5Cedentes thead tr').css("font-size","14");
	$('#Tabela_Top5Cedentes tbody tr').css("font-size","11");
}

function chamaTabela(empresa)
{
//limpa tabela
$('#tabela').html();

$('#tabela').html("<table  cellpadding=\"0\" cellspacing=\"0\" border=\"0\"  id=\"Tabela_Top5Cedentes\" width=\"100%\"><thead>		<tr><th>CEDENTE</th><th>VALOR</th><th>%RECEBIVEIS</th></tr></table>"); 

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
			$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=10Maiores', function(data) {	
				$('#Empresa').html("Consolidada");

						//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
						$.each(data.result.data, function(key, val) {

							table.fnAddData( [
								val[0],
								formatNumber(val[1]),
								val[2]+"%"	
								]
								); 
							
							
							
							$('#Tabela_Top5Cedentes tbody tr').css("font-size","12");


									/*	
									$('#Tabela_Top5Cedentes tbody tr').click( function () {
										
										chamaKPI_1($(this).find('td:nth-child(3)').html(),$(this).find('td:nth-child(1)').html());
										
									} );
																		
									
									$('#Tabela_Top5Cedentes tbody tr').mouseover( function () {
										$(this).css("color","blue");
										$(this).css("font-weight","bold");
									} ).mouseout(function() {
									
										$(this).css("color","black");
										$(this).css("font-weight","normal");
								
									});
									*/
									
									
									

								});
						
						totalTabela();
					});	  	  
		}
		
	    if (empresa == "1") //Factoring
	    {  
	    	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=10MaioresFactoring', function(data) {	
					   //loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
					   $.each(data.result.data, function(key, val) {

					   	table.fnAddData( [
					   		val[0],
					   		formatNumber(val[1]),
					   		val[2]+"%"	
					   		]
					   		); 

					   	$('#Tabela_Top5Cedentes tbody tr').css("font-size","12");

									/*	
									$('#Tabela_Top5Cedentes tbody tr').click( function () {
										
										chamaKPI_1($(this).find('td:nth-child(3)').html(),$(this).find('td:nth-child(1)').html());
										
									} );
																		
									
									$('#Tabela_Top5Cedentes tbody tr').mouseover( function () {
										$(this).css("color","blue");
										$(this).css("font-weight","bold");
									} ).mouseout(function() {
									
										$(this).css("color","black");
										$(this).css("font-weight","normal");
								
									});	
									*/									
								});

					   totalTabela();
					 });	  	  
	    }

   	     if (empresa == "2") //FIDC
   	     {  
   	     	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=10MaioresFidc', function(data) {	
						//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
						$.each(data.result.data, function(key, val) {

							table.fnAddData( [
								val[0],
								formatNumber(val[1]),
								val[2]+"%"	
								]
								); 
							
							$('#Tabela_Top5Cedentes tbody tr').css("font-size","12");

								/*		
									$('#Tabela_Top5Cedentes tbody tr').click( function () {
										
										chamaKPI_1($(this).find('td:nth-child(3)').html(),$(this).find('td:nth-child(1)').html());
										
									} );
																		
									
									$('#Tabela_Top5Cedentes tbody tr').mouseover( function () {
										$(this).css("color","blue");
										$(this).css("font-weight","bold");
									} ).mouseout(function() {
									
										$(this).css("color","black");
										$(this).css("font-weight","normal");
								
									});		
									*/									
								});
						
						totalTabela();
					});	  	  
   	     }		


   	   }

   	   function chamaKPI_1(valor_, cedente_)
   	   {

	//montaKPI_1(parseFloat(valor_.replace('%','')));
	montaKPI(parseFloat(valor_.replace('%','')),"KPI_1");

	$('#CedenteRisco').css('font-size','60%');
	$('#CedenteRisco').html(cedente_);
}

function chamaKPI_2(empresa)
{

	var total = 0;

  	    if (empresa == "0") //Consolidada
  	    {  
  	    	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=10Maiores', function(data) {

						//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
						$.each(data.result.data, function(key, val) {
							total +=	parseFloat(val[2]);	
						});
						

						montaKPI(Math.round(total),"KPI_2");
					});	  	  
  	    }

		if (empresa == "1") //Factoring
		{  
			$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=10MaioresFactoring', function(data) {

						//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
						$.each(data.result.data, function(key, val) {
							total +=	parseFloat(val[2]);	
						});
						

						montaKPI(Math.round(total),"KPI_2");
					});	  	  
		}

		if (empresa == "2") //FIDC
		{  
			$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=10MaioresFidc', function(data) {

						//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
						$.each(data.result.data, function(key, val) {
							total +=	parseFloat(val[2]);	
						});
						

						montaKPI(Math.round(total),"KPI_2");
					});	  	  
		}

		$(".dataTable").css({
			"table-layout": "fixed",
			"width": "80%"

		});

	}
</script>
</head>
<body  onload="javascript: loadData()">
	<div class="row">
		<div class="container">
			<div class="row">
				<div class="col-md-12">
					<div class="panel panel-primary">
						<div class="panel-heading">
							<h3 class="panel-title">Recebíveis</h3>
						</div>
						<div class="panel-body">
							<div class="row">
								<div class="col-md-6">
									<div class="panel panel-default">
										<div class="panel-heading">
											<h3 class="panel-title">
												Tipo de Produto
											</h3>
										</div>
										<div class="panel-body">
											<div id="GraficoPizza1" class="AreaGrafica"></div>
										</div>
									</div>
								</div>
								<div class="col-md-6">
									<div class="panel panel-default">
										<div class="panel-heading">
											<h3 class="panel-title">
												Tipo de Risco
											</h3>
										</div>
										<div class="panel-body">
											<div id="GraficoPizza2" class="AreaGrafica"></div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-6">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h3 class="panel-title">10 Maiores</h3>
						</div>
						<div class="panel-body">
							<div id="tabela" style="width:98%;padding:10px"></div>
							<span style="color:#fff">Total:<span id="total"></span></span>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h3 class="panel-title">
								10 Maiores
							</h3>
						</div>
						<div class="panel-body">
							<div id="KPI_2" class="AreaGrafico" style="width:550px; height:350px;padding:10px"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- <div class="container">

			<div class="container-fluid" >
				<div class="row-fluid">

					
					<div class="col-md-12">

						<div class="row">
							<div class="col-md-12">
								<div class="TituloDash" width="98%">RECEBÍVEIS</div>
							</div>
						</div>

						<div style="padding:0.2%"></div>

						<div class="row">
							<div class="col-md-6">

								<div class="TituloDash">Tipo de Produto</div>
								
							</div>
							<div class="col-md-6">

								<div class="TituloDash">Tipo de Risco</div>
								
							</div>
						</div>

						<div style="padding:0.9%"></div>





						<div class="row">
							<div class="col-md-6">
								<div class="TituloDash">10 Maiores</div>
								
							</div>


							<div class="col-md-6">
								<div class="TituloDash">10 Maiores</div>
								
							</div>

						</div>			   





					</div>

				</div>
			</div>



		</div>
	</div> -->
</body>
</html>
