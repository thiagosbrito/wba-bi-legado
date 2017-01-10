<!DOCTYPE html>
<html lang="pt-Br">
<head>

	<title></title>



	<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1" />

	<!--<link rel="stylesheet" href="/BibliotecaWBABI/css/Dashboards/Dashscreen.css" /> LAYOU CROMADO-->
	<!-- <link rel="stylesheet" href="/BibliotecaWBABI/css/Dashboards/DashscreenBlack.css"/> -->
	<link rel="stylesheet" href="/BibliotecaWBABI/plugin/bootstrap/css/bootstrap.min.css">
	<script type="text/javascript" src="/BibliotecaWBABI/js/jquery.js"></script>
	<script type="text/javascript" src="/BibliotecaWBABI/js/betaHightChats/highcharts.js"></script>
	<script type="text/javascript" src="/BibliotecaWBABI/js/betaHightChats/highcharts-more.js"></script> <!--Nescessario para o KPI-->
	<script type="text/javascript" src="/BibliotecaWBABI/js/jquery.blockUI.js"></script>
	<script type="text/javascript" src="/BibliotecaWBABI/js/FuncoesBasicas.js"></script>


	<!--DATATABLE COMPONENT-->
	<link rel="stylesheet" href="/BibliotecaWBABI/plugin/DataTables/media/css/jquery.dataTables.css" />
	<script type="text/javascript" src="/BibliotecaWBABI/plugin/DataTables/media/js/jquery.dataTables.js"></script>

	<!--chosen-->	
	<link rel="stylesheet" href="/BibliotecaWBABI/plugin/chosen/chosen/chosen.css"/>
	<script type="text/javascript" src="/BibliotecaWBABI/plugin/chosen/chosen/chosen.jquery.js"></script>
	<script type="text/javascript" src="/BibliotecaWBABI/plugin/jquery.selectboxes/jquery.selectboxes.js"></script>


	<script type="text/javascript">
		function  loadData()
		{
		ThemaDark(); //Aplica o Thema aos dashbord
		pegaCedente();
		
	}

	function pegaCedente(){

		var url   = window.location.search.replace("?", "");
		var itens = url.split("&");
		var id = itens[0].replace('id=','');
	  id = decodeURIComponent(id); //faz a codificação 
	  $('#cendenteSpan').html(id);
	  

	  
	  chamaTabela(id);
	}

	function totalTabela()
	{
		var total = 0;
		var num = 0;

		$('#Tabela_Top5Cedentes tr').each(function(i) {
			if (i > 0 ){

				var coluna = $(this).find('td:nth-child(6)').html();

				num =   parseFloat(coluna);
				total += num;
			}

		});

		$('#TotalSpan').html(moeda(total,2,',','.'));
		formataTabela();
	}

	function formataTabela()
	{

		$('#Tabela_Top5Cedentes thead tr').css("text-align","left");
		$('#Tabela_Top5Cedentes thead tr').css("font-size","14");

	}

	function destacarLinha()
	{

		$('#Tabela_Top5Cedentes tr').each(function(i) {

			if (i > 0 ){
				var secondCol = $(this).find('td:nth-child(2)').html();


				var hoje_ = new Date();
  	   //var ano_  = hoje_.getFullYear();
	   //var Mes_  = hoje_.getMonth();
	   //var Dia_  = hoje_.getDate();
	   
	   var dataVcto = secondCol;

	   var ano = dataVcto.substring(6,10);
	   var mes = dataVcto.substring(3,5);
	   var dia = dataVcto.substring(0,2);
	   var dataAux = new Date(ano,mes-1,dia);


	   
	   if (dataAux < hoje_){
			//add color red
			$(this).css("color","red");
			//$(this).find('td:nth-child(2)').css("color","red");
			
		}
		else
		{
			//add color blue
			$(this).css("color","blue");
			//$(this).find('td:nth-child(2)').css("color","blue");
		}
	}

});


	}

	function chamaTabela(Cedente_)
	{
//limpa tabela
$('#tabela').html();

$('#tabela').html("<table  cellpadding=\"0\" cellspacing=\"0\" border=\"0\"  id=\"Tabela_Top5Cedentes\" width=\"100%\"><thead>		<tr><th>SACADO</th><th>VCTO</th><th>EMISSÃO</th><th>NºDOC</th><th>TIPO</th><th>VALOR</th></tr></table>"); 

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



$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=TitulosCedente&Cedente='+Cedente_, function(data) {	

							//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
							$.each(data.result.data, function(key, val) {



								table.fnAddData( [
									val[0],
									val[1],
									val[2],
									val[3],
									val[4].replace('�','ã'),
									val[5]
									]
									); 

								$('#Tabela_Top5Cedentes tbody tr').css("font-size","12");


							});						
							totalTabela();
							destacarLinha();

						});




						//$("#Tabela_Top5Cedentes").html(options);
    					//$("#Tabela_Top5Cedentes").addClass("chzn-select"); 
						//$(".chzn-select").chosen(); 




					}
				</script>


			</head>
<body  onload="javascript: loadData()">
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<table class="table table-striped">
					<tbody>
						<tr>
							<td  valign="top">
								<div class="TituloDash">Cedente: <span id="cendenteSpan"></span></div>
								<div id="tabela" style="width:96%;padding:10px"></div>
							</td>
						</tr>
						<tr>
							<td style="color:#fff">Total: <span id="TotalSpan"></span></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>

</body>
</html>
