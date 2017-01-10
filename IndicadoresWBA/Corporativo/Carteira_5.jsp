<!DOCTYPE html>
<html lang="pt-Br">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <title>Painel Carteira</title>

  <!-- <link href="/BibliotecaWBABI/css/bootstrap/bootstrap_Preto.css"      			 rel="stylesheet"  type="text/css"/>
  <link href="/BibliotecaWBABI/css/bootstrap/bootstrap-responsive.css" 			 rel="stylesheet"  type="text/css"/> -->
  <link rel="stylesheet" href="/BibliotecaWBABI/plugin/bootstrap/css/bootstrap.min.css">
	<link href="/BibliotecaWBABI/plugin/DataTables/media/css/jquery.dataTables.css"  rel="stylesheet"  type="text/css"/>
	<link href ="/BibliotecaWBABI/plugin/chosen/chosen/chosen.css"                   rel="stylesheet"  type="text/css"/>
	
	<script type="text/javascript" src  ="/BibliotecaWBABI/js/jquery.min.js"></script>
	<script type="text/javascript" src  ="/BibliotecaWBABI/js/betaHightChats/highcharts.js"></script>
	<script type="text/javascript" src  ="/BibliotecaWBABI/js/betaHightChats/highcharts-more.js"></script> 
	<script type="text/javascript" src  ="/BibliotecaWBABI/js/FuncoesBasicas.js"></script>
	<script type="text/javascript" src  ="/BibliotecaWBABI/js/GraficosWBA.js"></script>
	<script type="text/javascript" src  ="/BibliotecaWBABI/plugin/DataTables/media/js/jquery.dataTables.js"></script>
	<script type="text/javascript" src  ="/BibliotecaWBABI/plugin/chosen/chosen/chosen.jquery.js"></script>
	<script type="text/javascript" src  ="/BibliotecaWBABI/plugin/jquery.selectboxes/jquery.selectboxes.js"></script>
  <script type="text/javascript" src  ="/BibliotecaWBABI/plugin/bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src  ="/BibliotecaWBABI/plugin/BlockUI/jquery.blockUI.js"></script>

	<style>
	.TituloDash
	{
	font-weight:bold;
	color:#fff;
	}
	.AreaGrafica
	{
	height:200px;
	}
	</style>
	
<script type="text/javascript">
function  loadData()
{
		ThemaDark(); //Aplica o Thema aos dashbord
		//Monta Aba Geral
		OcultaAbas();
   	    AbaVisivel("div#Aba_Geral");
	    MontaComboEmpresa();
 }



function CarregaPagina(pagina)
{

        OcultaAbas();
		
		if (pagina=='Geral')
		{
		    AbaVisivel("div#Aba_Geral")
			//MontaComboEmpresa();
		}
		
		if (pagina=='Duplicatas')
		{
		    AbaVisivel("div#Aba_Duplicatas")
			//MontaComboEmpresa();
			ChamaPizzaTipoCobranca();
		    ChamaPizzaChecagem();
		    GraficoDebarrasIndiceDeliquidez();
		}
		
		if (pagina=='Sacado')
		{
		    AbaVisivel("div#Aba_Sacado");
   		    $("#comboCedente").fadeOut();
 		    $("#comboSacado").fadeIn();
			
		}
		
		
		
		if (pagina=='Monitore')
		{
		    AbaVisivel("div#Aba_Monitore");
   		    //$("#comboCedente").fadeOut();
 		    //$("#comboSacado").fadeIn();

			$('#optionsRadios1').attr("checked",true);
			MonitoreGrafico("B");
		}
}

function OcultaAbas()
{
			
  $("div#Aba_Geral").fadeOut(); // ou slideUp()
  $("div#Aba_Duplicatas").fadeOut(); // ou slideUp()
  $("div#Aba_Sacado").fadeOut(); // ou slideUp()
  $("div#Aba_Monitore").fadeOut(); // ou slideUp()
  
  $("#comboCedente").fadeIn();
  $("#comboSacado").fadeOut();
}
function AbaVisivel(Aba)
{
	$(Aba).fadeIn(); // ou slideDown()
}


<!--Geral-->
function MontaComboEmpresa()
{


	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=empresas',function(data){
			
			/*$.blockUI({ message: '<h1>Aguarde por favor...</h1>',css: {
					border: 'none', 
					padding: '15px', 
					backgroundColor: '#000', 
					'-webkit-border-radius': '20px', 
					'-moz-border-radius': '20px', 
					opacity: .9, 
					color: '#fff'
					}
			});
		   */
	
		
		var options = "";
		options += '<option value="1,2">CONSOLIDADO</option>';
			
		$.each(data.result.data, function(key, val) {
				options += '<option value="' + val[0] + '">' + val[1] + '</option>';
		});
		
		$("#selectEmpresa").html(options);
    	$("#selectEmpresa").addClass("chzn-select"); 
		
		
		
		AcaoComboEmpresa();
	});
}

function AcaoComboEmpresa()
{
	var empresaCombo = $("#selectEmpresa").val();
	console.log('Empresa selecionada(s): '+empresaCombo);
	
	MontaComboCedenteEmpresa(empresaCombo);
	
}

function MontaComboCedenteEmpresa(empresaCombo)
{
	
	
   $.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=empresasCedente&Empresa='+empresaCombo,function(data){
	    
	}).done(function(data) {
	
		console.log("Acessou a lista de cedentes")
		var options = "";
		options += "<option value='0'>TODOS</option>";
		
		$.each(data.result.data, function(key, val) {
				options += '<option value="' + val[0] + '">' + val[1] + '</option>';
		});
		
		$("#selectCedente").html(options);
    	$("#selectCedente").addClass("chzn-select"); 
		AcaoComboCedente();
		
	}).fail(function(jqxhr, textStatus, error) {
    
		 var err = textStatus + ", " + error;
		 console.log( "Request Failed: " + err );
	
	}).always(function() {
		
		console.log("Completou consulta:empresasCedente")
		
  
   });
   
   
   /*
   
   $.ajax({
    type: "GET",
    url: "/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=empresasCedente&Empresa='+empresaCombo",
    contentType: "application/json; charset=utf-8",
    dataType: "jsonP",
    success: function(json) {
   
				console.log(json);
        
    },
    error: function (xhr, textStatus, errorThrown) {
        console.log(xhr.responseText);
	   // console.log(errorThrown);
    }
});
*/
}

function AcaoComboCedente(){
		
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
			

		
		var empresaCombo = $("#selectEmpresa").val();
		var cedenteCombo = $("#selectCedente").val();
				
		if (empresaCombo == '1,2') 
		{
			empresaComboAux = '0';
		}
		
	
		
		ChamaPizza1(empresaCombo,cedenteCombo);
		chamaTabela(empresaCombo,cedenteCombo);
		ChamaGraficoArea(empresaComboAux);
		
		
		
		ChamaPizzaTipoCobranca();
		ChamaPizzaChecagem();
		GraficoDebarrasIndiceDeliquidez();
	    
		
		$('#optionsRadios1').attr("checked",true);
		MonitoreGrafico("B");
			
		
		
		$("#Empresa").html($("#selectEmpresa").find(':selected').text());
		$("#Cedente").html($("#selectCedente").find(':selected').text());
}

function ChamaPizza1(empresa, cedente)
{
	var categorias = new Array();
	//Captura retorno do JSON vindo de uma XACTION com query MDX
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=TipoProdutoCedenteEmpresa&Empresa='+empresa+"&Cedente="+cedente, function(data) {	
 	
			$.each(data.result.data, function(key, val) {
					categorias[key] = new Array(val[0], parseFloat(val[1]));
			});
				
			CriarPizza(categorias, 'GraficoPizza1','0%');
	});
}

function ChamaGraficoArea(empresa)
{

	var valores = new Array();
	var mes = new Array();
	var dia = new Array();
	var ano = new Array();
	

	//var cedenteCombo = $("#selectCedente").find('option').filter(':selected').text(); //Pega valor(texto) selecionado 
	
	var empresaCombo = $("#selectEmpresa").val();
	var cedenteCombo = $("#selectCedente").val();
		

	
$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=VopCedenteEmpresa&Empresa='+empresaCombo+"&Cedente="+cedenteCombo,  function(data) {	
 
 
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

				AreaTIME_SERIES('', valores , (Date.UTC(ano[0], mes[0]-1, dia[0])),'GraficoArea');		
	
	
	$.unblockUI();
	
	});
	
	

}	

function chamaTabela(empresa, cedente)
{

		//limpa tabela
		$('#tabela').html();
		
		$('#tabela').html("<table  cellpadding=\"0\" cellspacing=\"0\" border=\"0\"  id=\"Tabela_Top5Cedentes\" width=\"100%\"><thead>		<tr><th>DATA</th><th>VOP</th><th>FATOR</th><th> AD-VALOREM</th><th>TARIFA</th></tr></table>"); 
					
					$.extend( $.fn.dataTable.defaults, {
						"bFilter": false,
						"bSort": false,
						"bLengthChange":false,
						"bInfo":true,
						"bPaginate":true,
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
					
					
						

			$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=VopCedenteEmpresaDESC&Empresa='+empresa+"&Cedente="+cedente,  function(data) {	
			
			
						
						//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
						$.each(data.result.data, function(key, val) {
							 
							table.fnAddData( [
								val[0],
								'R$ '+moeda(val[1].toFixed(2) ,2,',','.'),
								val[2],
								parseFloat(val[3]).toFixed(2),
								'R$ '+moeda(val[4].toFixed(2) ,2,',','.')
								]
							); 
							
							
							
									//$('#Tabela_Top5Cedentes tbody tr').css("font-size","12");
						});
						
						totalTabela();
						formataTabela('#Tabela_Top5Cedentes');
			
			
			$.unblockUI();
			});	  	  	    			    			
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
 
}

<!--Duplicatas-->
function ChamaPizzaTipoCobranca()
{
	var empresaCombo = $("#selectEmpresa").val();
	var cedenteCombo = $("#selectCedente").val();
	var categorias = new Array();

		
	
	

	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=TipoCobranca&Empresa='+empresaCombo+"&Cedente="+cedenteCombo, function(data) {	
			$.each(data.result.data, function(key, val) {
					categorias[key] = new Array(val[0], parseFloat(val[1]));
			});
			
			CriarPizza(categorias, 'GraficoPizzaTipoCobranca','0%');
	});
	
	
	/*
	var categorias = new Array();
	
	for (i = 0; i<= 5; i++)
	{
		categorias[i] = new Array(i,i);
	}
	*/
	//CriarPizza(categorias, 'GraficoPizzaTipoCobranca','0%');

}

function ChamaPizzaChecagem()
{
	var empresaCombo = $("#selectEmpresa").val();
	var cedenteCombo = $("#selectCedente").val();
	var categorias = new Array();
	var CategoriaAux;

	//Captura retorno do JSON vindo de uma XACTION com query MDX
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=Checagem&Empresa='+empresaCombo+"&Cedente="+cedenteCombo, function(data) {	
			$.each(data.result.data, function(key, val) {
					
					CategoriaAux = val[0];
					if (val[0] == "Nao Identificado"){CategoriaAux = "A Confirmar"}
					               
					categorias[key] = new Array(CategoriaAux, parseFloat(val[1]));
			});
			
			
			CriarPizza(categorias, 'GraficoPizzaChecagem','50%');
	});
}

function GraficoDebarrasIndiceDeliquidez()
{
	var empresaCombo = $("#selectEmpresa").val();
	var cedenteCombo = $("#selectCedente").val();

	
	var categoriasEmpresa = new Array();
	var valorPontual = new Array();
	var valorRegresado = new Array();

	//Captura retorno do JSON vindo de uma XACTION com query MDX
		$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=LiquidezHistorica&Empresa='+empresaCombo+"&Cedente="+cedenteCombo, function(data) {		
				//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
				
				$.each(data.result.data, function(key, val) {
								categoriasEmpresa[key]  = val[0];  
								valorPontual[key] = parseFloat(val[3]);
								valorRegresado[key]  = parseFloat(val[9]);
				});
				
				//Chama função que gera o grafico e passa o array com os valores
				CriarGraficoBarraDupla(categoriasEmpresa,valorPontual,valorRegresado);
					
				
	});

}
function CriarGraficoBarraDupla(categoriasEmpresa_, valorPontual_, valorRegresado_)
{

var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'GraficoAreaLiquidez',
                type: 'column' 
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
                name: 'Pontual',
                data: valorPontual_
					},
					{
                name: 'Regressado',
                data: valorRegresado_				
					}	
				]
        });
    });
	
}

function Aba(aba){
	if (aba != 3){
		$('#linhaOculta').css("visibility","hidden");
		$('#linhaOcultaCedente').css("visibility","visible");
	}
	else{  //Aba 3 -Sacado
	   $('#linhaOculta').css("visibility","visible");
	   $('#linhaOcultaCedente').css("visibility","hidden");
	}
}

<!--Sacado-->
function CarregaComboSacadoNome()
{
    var empresaCombo = $("#selectEmpresa").val();
	var cedenteCombo = $("#LikeSacado").val();
   		
				
  	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=SacadosNome&Empresa='+empresaCombo+"&Cedente='"+cedenteCombo+"'", function(data) {	

	var options = "";
		
		$.each(data.result.data, function(key, val) {
				
		options += '<option value="' + val[0] + '">' + val[0] + '</option>';
				
		
		
		});
		
		$("#selectSacadoNome").html(options);
    	
		$("#selectSacadoNome").addClass("chzn-select"); 
		//$(".chzn-select").chosen(); 
		AcaoComboSacadoNome();
	});
}

function AcaoComboSacadoNome()
{


    var empresaCombo = $("#selectEmpresa").val();
	var cedenteCombo = $("#selectCedente").val();
	var SacadoCombo = $("#selectSacadoNome").val();

   	
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=SacadosCGC&Empresa='+empresaCombo+"&Cedente="+cedenteCombo+"&Sacado='"+SacadoCombo+"'", function(data) {	
	
	
		var options = "";
					
		$.each(data.result.data, function(key, val) {
				options += '<option value="' + val[0] + '">' + val[0] + '</option>';
		});
		
		$("#selectSacadoCNPJ").html(options);
    	$("#selectSacadoCNPJ").addClass("chzn-select"); 
		//$(".chzn-select").chosen(); 
		listar();
		
	});
}

function listar()
{
	var empresaCombo    = $("#selectEmpresa").val();
	var cedenteCombo    = $("#selectCedente").val();
	var SacadoCombo     = $("#selectSacadoNome").val();
	var SacadoComboCNPJ = $("#selectSacadoCNPJ").val();
    
	var Pontual = new Array();
	var Regressado = new Array();
	
	
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=LiquidezCGC&Empresa='+empresaCombo+"&Cedente="+cedenteCombo+"&CNPJ='"+SacadoComboCNPJ+"'", function(data) {	
	
	
				//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
				$.each(data.result.data, function(key, val) {
					Pontual[key]  = new Array(val[0], parseFloat(val[2]));  
					Regressado[key]  = new Array(val[0], parseFloat(val[3]));  
				});
				
				//Chama função que gera o grafico e passa o array com os valores
				CriarBarra(Pontual,'GraficoPontual','Pontual');
				CriarBarra(Regressado,'GraficoRegressado','Regressado');
				
				
				$('#GraficoPontual tspan').css("font-size","8");
				$('#GraficoRegressado tspan').css("font-size","8");
					
	TabelaGeral();
	
	});
	
	
}

function TabelaGeral()
{
	var empresaCombo    = $("#selectEmpresa").val();
	var cedenteCombo    = $("#selectCedente").val();
	var SacadoCombo     = $("#selectSacadoNome").val();
	var SacadoComboCNPJ = $("#selectSacadoCNPJ").val();
    
	var Pontual = new Array();
	var Regressado = new Array();
	
	
	
	
	//limpa tabela
		$('#TabelaGeral').html();
		
		$('#TabelaGeral').html("<table  align=\"center\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"  id=\"Tabela_\" width=\"100%\" class=\"Tabela_Top5Cedentes\"><thead><th>MES</th><th>ABERTO</th><th>VENCIDO</th><th>AVENCER</th><th>CONFIRMADO</th><th>TOTAL LIQUIDADO</th><th>PONTUAL</th><th>EM ATRASO</th><th>REGRESSO</th><th>PDD</th></tr></table>"); 
					
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
    					});
						
		table = $('#Tabela_').dataTable();		
					
		
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=LiquidezGeral&Empresa='+empresaCombo+"&CNPJ='"+SacadoComboCNPJ+"'", function(data) {	

		

	

	$.each(data.result.data, function(key, val) {
	
	
	//MES	MESNUMERICO	ABERTO	VENCIDO	AVENCER	CONFIRMADO	TOTAL_LIQUIDADO	PONTUAL	EM_ATRAZO	REGRESSO	PDD
				

							table.fnAddData( [
								
								
								val[0],
								val[2],
								val[3],
								val[4],
								val[5],
								val[6],
								val[7],
								val[8],
								val[9],
								val[10]
								]
							);
							
	/*
							table.fnAddData( [
								
								
								'R$'+moeda(val[0].toFixed(2) ,2,',','.'),
								val[1],
								val[2],
								val[3],
								'R$'+moeda(val[4].toFixed(2) ,2,',','.'),
								val[5],
								val[6],
								val[7],
								val[8]
								]
							); 
*/		
		$('#Tabela_ tbody tr').css("font-size","11");
									formataTabela("#Tabela_");
									FormatarLinhaTabela();
									
						});
	
	});

}

function formataTabela(TabelaID)
{
	$(TabelaID+' thead tr').css("text-align","left");
	$(TabelaID+' thead tr').css("font-size","11");
}

function FormatarLinhaTabela()
{
	$('#Tabela_ tr').each(function(i) {
	
	if (i > 0 ){
		
		$(this).find('td:nth-child(2)').css("color","blue");
	    $(this).find('td:nth-child(6)').css("color","blue");
	}
	});
	
	
	$("#Tabela_").find('tr.odd').css("background-color","ccc");
	$("#Tabela_").find('td').css("text-align","left");
}


<!--Monitoring-->
function MonitoreGrafico(Escolha)
{
		
	var cedenteCombo    = $("#selectCedente").val();
	
	var categorias = new Array();
	var Protesto   = new Array();
	var Cheque     = new Array();
	var Falencia   = new Array();

	

	
	
		$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelCarteira.xaction/generatedContent?&getData=BoaVista&Cedente='+cedenteCombo+"&TipoConsulta='"+Escolha+"'",function(data){

			
			//alert(dump(data));
			
			$.each(data.result.data, function(key, val) {
			
			//0 Tipo 1 Ano 2 Mes 3 "VLRPROTESTO" 4  "QTDEPROTESTO"  5 "QTDEFALENCIA" 6 "QTDECHEQUE"
			
				//categorias[key] = NomeMes_(val[2]);
				categorias[key] = val[2];
				Protesto[key]   = val[4];
				Falencia[key]   = val[5];
				Cheque[key]     = val[6];
					
			
			});
			
			MontaGrafico_Monitoring(categorias,Protesto,Falencia,Cheque)
			
	 
	 
	 
	 });

	 
	 }

function MontaGrafico_Monitoring(categoria_, Protesto_ ,Falencia_ ,Cheque_)
{

 var chart;
    $(document).ready(function() {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'GraficoMonitore',
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
                categories: categoria_
            },
            yAxis: {
                title: {
                    text: 'Monitore'
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
                        this.x +': '+ this.y ;
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
                name: 'Protesto',
                data: Protesto_
            },
			{
                name: 'Cheques s/Fundo',
                data: Cheque_
            }
			,
			{
                name: 'Falencia',
                data: Falencia_
            }
			]
        });
    });
	
}



<!--Auxiliar-->

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
</script>

	
</head>
<body  onload="javascript: loadData()" style="background-color:#414141">





<div class="container" >
    <!-- CLASSE QUE DEFINE O CONTAINER COMO FLUIDO (100%) -->
    <div class="container-fluid" >
	  <!-- CLASSE PARA DEFINIR UMA LINHA -->
        <div class="row-fluid">
		
	 <div class="row">
			<div class="col-md-12">
			   <!--MENU SUPERIOR -->
				   <!-- NAVBAR
				================================================== -->
				<div class="navbar-wrapper">
				  <!-- Wrap the .navbar in .container to center it within the absolutely positioned parent. -->
				  <div class="container">
  
					<div class="navbar navbar"> <!---inverse">-->
					  <div class="navbar-inner">
						<!-- Responsive Navbar Part 1: Button for triggering responsive navbar (not covered in tutorial). Include responsive CSS to utilize. -->
						<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
						  <span class="icon-bar"></span>
						  <span class="icon-bar"></span>
						  <span class="icon-bar"></span>
						</a>
						<a class="brand" href="javascript:void(0);"  onclick="CarregaPagina('Apresentacao.html');">WBA BI</a>
						<!-- Responsive Navbar Part 2: Place all navbar contents you want collapsed withing .navbar-collapse.collapse. -->
						<div class="nav-collapse collapse">
						  <ul class="nav">
						   <li><a href="javascript:void(0);" onclick="CarregaPagina('Geral');">Geral</a></li>
						   <li><a href="javascript:void(0);" onclick="CarregaPagina('Duplicatas');">Duplicatas</a></li>
						   <li><a href="javascript:void(0);" onclick="CarregaPagina('Sacado');">Sacado</a></li>
						   <li><a href="javascript:void(0);" onclick="CarregaPagina('Monitore');">Monitore</a></li>
						  </ul>
						</div><!--/.nav-collapse -->
					  </div><!-- /.navbar-inner -->
					</div><!-- /.navbar -->

				  </div> <!-- /.container -->
				</div><!-- /.navbar-wrapper -->
			</div>		
		</div>

		<!--Filtros-->	
		<div class="row" id="Filtros">	
		<div class="col-md-12" style="width:100%;left:-30px;position:relative">
		  
		  <div class="row">
		    <div class="col-md-12">
				<span>Empresa:<select  style="width:100%;" id="selectEmpresa" onchange="javascript: AcaoComboEmpresa();"></select></span>
			</div>
		  </div>
		  <div class="row">
		    <div class="col-md-12">
			    <span id="comboCedente">Cedente:<select  style="width:100%;" id="selectCedente" onchange="javascript: AcaoComboCedente();"></select></span>
			</div>
		  </div>
					  
			<div id="comboSacado">
					  <div class="row">
						<div class="col-md-4">
						Sacado:<br>
						<input type="text" id="LikeSacado" class="col-md-8"/>
						<input type="button" value="Listar Sacados" onClick="CarregaComboSacadoNome();" class="btn"/>
						</div>
						<div class="col-md-8"><br>
						<select  style="width:100%;" id="selectSacadoNome" onchange="javascript: AcaoComboSacadoNome();"></select>
						</div>
					  </div>
					  <div class="row">
						<div class="col-md-10">
						 CNPJ:<br> <select  style="width:80%;" id="selectSacadoCNPJ" onchange="javascript: AcaoComboSacadoCnpj();"></select>
						 <a href="#" onClick='javascript:listar();'><span class="btn">Atualizar</span></a>
						</div>
					  </div>
			  </span>		  
			</div>
		</div>	
			
		<!---Geral-->
		<div class="row" id="Aba_Geral">
			<div class="col-md-12" align="center">
		    	<div class="row">
				  <div class="col-md-4">
				    <div class="TituloDash">Tipo de Produto</div></br>
				    <div id="GraficoPizza1" class="AreaGrafica"></div>
				  </div>
				  <div class="col-md-8">
				    <div class="TituloDash">Últimas Operações</div>
				    <div id="tabela" class="AreaGrafica"></div>
				  </div>
				</div>
				<div class="row">
				  <div class="col-md-12">
				    <div class="TituloDash">VOP</div>
				  </div>
				</div>
				<div class="row">
				  <div class="col-md-12">
				    <div id="GraficoArea" class="AreaGrafica"></div>
				  </div>
				</div>				
			</div>
		</div>			
			
		<!--Duplicatas-->
		<div class="row" id="Aba_Duplicatas">
			<div class="col-md-12" align="center">
				<div class="row">
				  <div class="col-md-6">
				    <div class="TituloDash">Tipo de Cobrança</div>
				    <div id="GraficoPizzaTipoCobranca" class="AreaGrafica"></div>
				  </div>
				  <div class="col-md-6">
				    <div class="TituloDash">Checagem</div>
				    <div id="GraficoPizzaChecagem" class="AreaGrafica"></div>
				  </div>
				</div>
				<div class="row">
				  <div class="col-md-12">
				    <div class="TituloDash">Liquidez Historica</div>
				  </div>
				</div>
				<div class="row">
				  <div class="col-md-12">
				    <div id="GraficoAreaLiquidez" class="AreaGrafica"></div>
				  </div>
				</div>
			</div>
		</div>
		
		<!--Sacado-->
		<div class="row" id="Aba_Sacado">
			<div class="col-md-12" align="center">
				<div class="row">
				  <div class="col-md-6">
				    <div class="TituloDash">Pontual</div>
				    <div id="GraficoPontual" class="AreaGrafica"></div>
				  </div>
				  <div class="col-md-6">
				    <div class="TituloDash">Regresso</div>
				    <div id="GraficoRegressado" class="AreaGrafica"></div>
				  </div>
				</div>
				<div class="row">
				  <div class="col-md-12">
				    <div class="TituloDash">Liquidez Geral</div>
				  </div>
				</div>
				<div class="row">
				  <div class="col-md-12">
				    <div id="TabelaGeral" class="AreaGrafica"></div>
				  </div>
				</div>
			</div>
		</div>
		
		<!--Monitore-->
		<div class="row" id="Aba_Monitore">
			<div class="col-md-12">
				<div class="row">
				  <div class="col-md-12">
						<label class="radio inline">
							  <input type="radio" name="optionsRadios" id="optionsRadios1" value="option1" checked onclick="MonitoreGrafico('B')">
							  Boa Vista
						</label> 
						<label class="radio inline">
							  <input type="radio" name="optionsRadios" id="optionsRadios2" value="option2" onclick="MonitoreGrafico('S')">
							  Serasa
						</label>
				   </div>
				</div>
				<div class="row">
				  <div class="col-md-12">
				    <div id="GraficoMonitore" class="AreaGrafica" style="height:100%"></div>
				  </div>
				</div>
			
			</div>
		</div>	
		

		
    </div>
    </div>
	</div>

</body>
</html>
