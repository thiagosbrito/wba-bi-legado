<!DOCTYPE html>
<html>
 <head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Controle de Checagem</title>


  <link   rel="stylesheet"        href ="/BibliotecaWBABI/WBABI-API-checagem/plugin/bootstrap-3.3.6-dist/css/bootstrap.min.css">
  <script type="text/javascript"  src  ="/BibliotecaWBABI/WBABI-API-checagem/plugin/jquery/1.11.3/jquery.min.js"></script>
  <script type="text/javascript"  src  ="/BibliotecaWBABI/WBABI-API-checagem/plugin/jquery-ui/jquery-ui.js"></script>
  <script type="text/javascript"  src  ="/BibliotecaWBABI/WBABI-API-checagem/plugin/bootstrap-3.3.6-dist/js/bootstrap.min.js"></script>
  <script type="text/javascript"  src  ="/BibliotecaWBABI/WBABI-API-checagem/plugin/Highcharts-4.2.4/js/highcharts.js"></script>
  <script type="text/javascript"  src  ="/BibliotecaWBABI/WBABI-API-checagem/plugin/Highcharts-4.2.4/js/modules/exporting.js"></script>
  <script type="text/javascript"  src  ="/BibliotecaWBABI/js/FuncoesBasicas.js"></script>


  <style>
  body {
    -webkit-font-smoothing: antialiased;
    overflow-x: hidden;
    background: url(/BibliotecaWBABI/WBABI-API-checagem/img/5.png) repeat;
    position: relative;
    direction: ltr;
  }

  .panel {
    box-shadow: 0 1px 0 #fff;
    margin-bottom: 25px;
    position: relative;
	min-height:180px;
	padding: 0px;
   }

   .panel panel-default{
      margin-bottom: 15px;
	  -webkit-border-radius: 5px;
      -moz-border-radius: 5px;
      border-radius: 5px;
	  padding: 20px;
  }
  
  .panel-heading {
    height: auto;
    position: relative;
    border: 1px solid #c4c4c4;
    border-top-left-radius: 2px;
    border-top-right-radius: 2px;
    box-shadow: 0 1px 0 #fff;
    padding: 0;
	color: #333;
  
 }


  .panel-heading h4 {
    padding-left: 15px;
    margin-bottom: 0;
    padding-top: 10px;
    padding-bottom: 9px;
    min-height: 37px;
    display: inline-block;

 }
 
 .panel-body {
    padding: 5px;
}

.nav
{
	padding-bottom:10px;
}

/*Cor Geral para cada painel*/
.panel-default>.panel-heading {
    color: #fff;
    background-color: #436AAD;
    border-color: #436AAD;
}

.panel-default {
    border-color: #436AAD;
}

.table tbody tr:hover td, .table tbody tr:hover th {
    background-color: #F0FFFF;
}


 .load {
 	min-height: 50px;
 	min-width: 50px;
    background: url(/BibliotecaWBABI/WBABI-API-checagem/img/load.gif) no-repeat;
 }

</style>


<script>
  

  popular_Painel();

  function Carregando(local)
  {
  	$(local).html("<h1 class='load'></h1>");
  }

  function popular_Painel()
  {	
  	//Caminho XACTION
	var caminhoXaction = "/pentaho/api/repos/:_WBA-FI:ControleChecagem.xaction/generatedContent?&";
  
	//Configura Objetos
	var registros  = "";
	var registros2 = "";
	var registros3 = "";
	var registros4 = "";
	var registros5 = "";
	var registros6 = "";
	var registros7 = "";
	var registros8 = "";
	var registros9 = "";
    

 
    
	//console.log('<%=request.getContextPath() %>');
	//CarteiraTotal
	console.log(caminhoXaction+'getData=CarteiraTotal');
	$.getJSON(caminhoXaction+'getData=CarteiraTotal', function(data) {
		    
		    //Carregando("#CarteiraTotal");
		    //Carregando("#ResumoDaChecagem");
		    //Carregando("#TitulosAVencer");
		    //Carregando("#TitulosVencidos");
		    Carregando("#SituacaoChecagemTop15");
		    Carregando("#CedenteEmAlerta");
		    Carregando("#ContratosProximosAoVencimento");
			//Carregando("#TitulosPorBancoLiquidacao");
		    

			//console.log(dump(data));
			registros="";
			$.each(data.result.data, function(key, val) {
				registros = registros +"<tr>";
				registros = registros +"<td>"+TrataTipoDeDocumento(val[0])+"</td>";
				registros = registros +"<td>R$ "+val[1]+"</td>";
				registros = registros +"<td>"+parseFloat(val[2]*100).toFixed(2)+"%</td>";
				registros = registros +"</tr>"; 
			});


	 }).always(function() {
	        //Alimenta Grafico de Carteira Total
			$("#CarteiraTotal" ).html(registros+"<tr style='color:transparent'><td colspan='3'>A</td></tr><tr style='color:transparent'><td colspan='3'>A</td></tr>");
			$("#tempo").html(dataAtualFormatada());
			ToolTip('#CarteiraTotal','carteira Total - 040,041,043 e 046 da carteira em aberto');
	});
	
	
	//ResumoDaChecagem
	$.getJSON(caminhoXaction+'getData=ResumoDaChecagem', function(data) {
		 //console.log(dump(data));
	     registros2="";
	     $.each(data.result.data, function(key, val) {
		    registros2 = registros2 +"<tr>";
		    registros2 = registros2 +"<td>"+val[0]+"</td>";
		    registros2 = registros2 +"<td>"+val[1]+"</td>";
		    registros2 = registros2 +"<td>R$ "+formatNumber(val[2])+"</td>";
		    registros2 = registros2 +"<td>"+parseFloat(val[3]*100).toFixed(2)+"%</td>";
		    registros2 = registros2 +"</tr>"; 
	 });
	}).always(function() {
	        //Alimenta Grafico
	      	$("#ResumoDaChecagem").html(registros2);
	      	ToolTip("#ResumoDaChecagem",'Resumo da Checagem');
	});

    
    //TitulosAVencer
	$.getJSON(caminhoXaction+'getData=TitulosAVencer', function(data) {
	     //console.log(dump(data));
	     registros3="";
	     $.each(data.result.data, function(key, val) {
		    registros3 = registros3 +"<tr>";
		    registros3 = registros3 +"<td>"+TrataTipoDeDocumento(val[0])+"</td>";
		    registros3 = registros3 +"<td>"+val[1]+"</td>";
		    registros3 = registros3 +"<td>"+val[2]+"</td>";
		    registros3 = registros3 +"<td>"+val[3]+"</td>";
		    registros3 = registros3 +"<td>"+val[4]+"</td>";
		    registros3 = registros3 +"<td>"+val[5]+"</td>";
		    registros3 = registros3 +"<td>"+val[6]+"</td>";
		    registros3 = registros3 +"<td>"+val[7]+"</td>";
		    registros3 = registros3 +"<td>"+val[8]+"</td>";
		    registros3 = registros3 +"<td>"+val[9]+"</td>";
		    registros3 = registros3 +"</tr>"; 
	 });
	}).always(function() {
	        //Alimenta Grafico
	      	$("#TitulosAVencer").html(registros3);
	});

	
	//TitulosVencidos
	$.getJSON(caminhoXaction+'getData=TitulosVencidos', function(data) {
	     //console.log(dump(data));
	     registros4="";
	     $.each(data.result.data, function(key, val) {
		    registros4 = registros4 +"<tr>";
		    registros4 = registros4 +"<td>"+TrataTipoDeDocumento(val[0])+"</td>";
		    registros4 = registros4 +"<td>"+val[1]+"</td>";
		    registros4 = registros4 +"<td>"+val[2]+"</td>";
		    registros4 = registros4 +"<td>"+val[3]+"</td>";
		    registros4 = registros4 +"<td>"+val[4]+"</td>";
		    registros4 = registros4 +"<td>"+val[5]+"</td>";
		    registros4 = registros4 +"<td>"+val[6]+"</td>";
		    registros4 = registros4 +"<td>"+val[7]+"</td>";
		    registros4 = registros4 +"<td>"+val[8]+"</td>";
		    registros4 = registros4 +"<td>"+val[9]+"</td>";
		    registros4 = registros4 +"<td>"+val[10]+"</td>";
		    registros4 = registros4 +"</tr>"; 
	 });
	}).always(function() {
	        //Alimenta Grafico
	      	$("#TitulosVencidos").html(registros4);
	});

     
    //SituacaoChecagemTop15
	$.getJSON(caminhoXaction+'getData=SituacaoChecagemTop15', function(data) {
	     //console.log(dump(data));
	     registros5="";
	     $.each(data.result.data, function(key, val) {
		    registros5 = registros5 +"<tr>";
		    registros5 = registros5 +"<td>"+val[0].substring(0, 10);+"</td>";
		    registros5 = registros5 +"<td>"+val[1]+"</td>";
		    registros5 = registros5 +"<td>"+val[2]+"</td>";
		    registros5 = registros5 +"<td>"+val[3]+"</td>";
		    registros5 = registros5 +"</tr>"; 
	 });
	}).always(function() {
	        //Alimenta Grafico
	      	$("#SituacaoChecagemTop15").html(registros5);
	});
	

   console.log(caminhoXaction+'getData=ContratosProximosAoVencimento');
   //ContratosProximosAoVencimento
	$.getJSON(caminhoXaction+'getData=ContratosProximosAoVencimento', function(data) {
	     registros7="";
	     $.each(data.result.data, function(key, val) {
		    registros7 = registros7 +"<tr>";
		    registros7 = registros7 +"<td>"+val[0].substring(0, 10);+"</td>";
		    registros7 = registros7 +"<td>"+val[1]+"</td>";
		    registros7 = registros7 +"<td>"+val[2]+"</td>";
		    registros7 = registros7 +"<td>"+val[3]+"</td>";
		    registros7 = registros7 +"<td>"+val[4]+"</td>";
		    registros7 = registros7 +"<td>"+val[5]+"</td>";
		    registros7 = registros7 +"</tr>"; 
	 });
	}).always(function() {
	        //Alimenta Tabela
	      	$("#ContratosProximosAoVencimento").html(registros7);
	});
     

	//TitulosPorBancoLiquidacao
	var categorias= new Array();
	$.getJSON(caminhoXaction+'getData=TitulosPorBancoLiquidacao', function(data) {
	     //console.log(dump(data));
	     registros6="";
	     $.each(data.result.data, function(key, val) {
		    registros6 = registros6 +"<tr>";
		    registros6 = registros6 +"<td>"+val[0]+"</td>";
		    registros6 = registros6 +"<td>"+val[1]+"</td>";
		    registros6 = registros6 +"<td>"+parseFloat(val[2]*100).toFixed(2)+"</td>";
		    registros6 = registros6 +"</tr>"; 

			categorias[key] =  new Array(val[0], Math.round(parseFloat(val[1])));
	 });
	}).always(function() {
	        //Alimenta Grafico
	      	$("#TitulosPorBancoLiquidacao").html(registros6);
	      	//Cria grafico de Pizza
		    CriarPizza(categorias);
		    
   });    


	//CedenteEmAlerta
	$.getJSON(caminhoXaction+'getData=CedenteEmAlerta', function(data) {
	     registros7="";
	     $.each(data.result.data, function(key, val) {
		    registros7 = registros7 +"<tr>";
		    registros7 = registros7 +"<td>"+val[0].substring(0, 10);+"</td>";
		    registros7 = registros7 +"<td>"+val[2]+"</td>";
		    registros7 = registros7 +"<td>"+val[1]+"</td>";
		    registros7 = registros7 +"</tr>"; 
	 });
	}).always(function() {
	        //Alimenta Grafico
	      	$("#CedenteEmAlerta").html(registros7);
	});
	


  }	

 

</script> 
  
 <head>
<body>


<div class="container-fluid" style="margin-top:20px">
      

	<ul class="nav nav-tabs">
     <li class="active"><a data-toggle="tab" href="#menu1">Carteira</a></li>
     <li><a data-toggle="tab" href="#menu2">Cedente</a></li>
     <li><a data-toggle="tab" href="#menu3">Financeiro</a></li>
    </ul>
  
	
	  <div class="tab-content">
	   <div id="menu1" class="tab-pane fade in active">
 	     <div class="row " id="draggablePanelList">
	      <div class="col-md-6">
		  <div class="panel panel-default">
		  <div class="panel-heading">
		     <h4 class="panel-title">
			   <i class="s16 glyphicon glyphicon-paperclip"></i> <span>Carteira Total</span>
			 </h4>
		   </div>
		  <div class="panel-body">
		    <table class="table table-bordered table-hover table-condensed table-striped"> 
		    <thead> 
			   <tr> 
			     <th>Tipo</th> 
				 <th>Valor</th> 
				 <th>%</th> 
			   </tr> 
			 </thead> 
			  <tbody id="CarteiraTotal"> 
			  </tbody> 
			</table>
		  </div>
		 </div> 
		</div>
		  <div class="col-md-6">
		 <div class="panel panel-default"> 
		  <div class="panel-heading">
		     <h4 class="panel-title">
			   <i class="s16 glyphicon glyphicon-paperclip"></i> <span>Resumo da Checagem</span>
			 </h4>
		   </div>
		  <div class="panel-body">
		    <table class="table table-bordered table-hover table-condensed table-striped"> 
		    <thead> 
			   <tr> 
			     <th>Checagem</th> 
				 <th>Quantidade</th> 
				 <th>Valor</th> 
				 <th>%</th> 
			   </tr> 
			 </thead>  
			  <tbody id="ResumoDaChecagem"> 
			  </tbody> 
			</table>
		  </div>
		  </div>
		</div>
	    </div>
	     <div id="draggablePanelList2">
	     <div class="row">
	      <div class="col-sm-12">
		 <div class="panel panel-default"> 
           <div class="panel-heading">
		     <h4 class="panel-title">
			   <i class="s16 glyphicon glyphicon-paperclip"></i> <span>Titulos A Vencer</span>
			 </h4>
		   </div>
		  <div class="panel-body">
		    <table class="table table-bordered table-hover table-condensed table-striped"> 
		    <thead> 
			   <tr> 
			     <th>Tipo</th> 
				 <th>D-0</th> 
				 <th>D-1</th> 
				 <th>D-2</th> 
				 <th>D-3</th> 
				 <th>D-4</th> 
				 <th>D-5</th> 
				 <th>D-6</th> 
				 <th>D-7</th> 
				 <th>Total</th> 
			   </tr> 
			 </thead> 
			  <tbody id="TitulosAVencer"> 
			  </tbody> 
			</table>
		  </div>
		 </div>
		</div>
	    </div>
	     <div class="row">
	      <div class="col-md-12">
		  <div class="panel panel-default"> 
		   <div class="panel-heading">
		     <h4 class="panel-title">
			   <i class="s16 glyphicon glyphicon-paperclip"></i> <span>Titulos Vencidos</span>
			 </h4>
		   </div>
		  <div class="panel-body">
		   <table class="table table-bordered table-hover table-condensed table-striped"> 
		    <thead> 
			   <tr> 
			     <th>Tipo</th> 
				 <th>Até 5 Dias</th> 
				 <th>Venc. 6 a 15</th> 
				 <th>Venc. 16 a 30</th> 
				 <th>Venc. 31 a 60 </th>
				 <th>Mais de 60 </th> 
				 <th>Total</th> 
				 <th>% Venc.</th> 
				 <th>% Venc. Sob. Carteira</th> 
				 <th>Em cartorio</th> 
				 <th>Protesto</th> 
			   </tr> 
			 </thead> 
			  <tbody id="TitulosVencidos"> 
			  </tbody> 
			</table>
		  </div>
		</div>
		</div>
	   </div>	
	    </div>
	   </div>
	  	  
	   
	   <div id="menu2" class="tab-pane fade">
	     <div class="row"  id="draggablePanelList3">
	       <div class="col-md-3">
		     <div class="panel panel-default">
		       <div class="panel-heading">
		         <h4 class="panel-title">
			       <i class="s16 glyphicon glyphicon-paperclip"></i> <span>Situação Checagem (Top 15)</span>
			     </h4>
		       </div>
		       <div class="panel-body">
		        
		  <table class="table table-bordered table-hover table-condensed table-striped"> 
		    <thead> 
			   <tr> 
			     <th>Cedente</th> 
				 <th>Valor Carteira</th> 
				 <th>Valor C/Prob.</th> 
				 <th>%</th> 
			   </tr> 
			 </thead> 
			  <tbody id="SituacaoChecagemTop15"> 
			  </tbody> 
			</table>
		  
		       </div>
		    </div>
		  </div>
		   <div class="col-md-3">
		     <div class="panel panel-default">
		       <div class="panel-heading">
		         <h4 class="panel-title">
			       <i class="s16 glyphicon glyphicon-paperclip"></i> <span>Cedentes em Alerta</span>
			     </h4>
		       </div>
		       <div class="panel-body">
		        
		  <table class="table table-bordered table-hover table-condensed table-striped"> 
		    <thead> 
			   <tr> 
			     <th>Cedente</th> 
				 <th>Em Alerta por</th> 
				 <th>Situação</th>
			   </tr> 
			 </thead> 
			  <tbody id="CedenteEmAlerta"> 
			  </tbody> 
			</table>
		  
		       </div>
		    </div>
		  </div>
		   <div class="col-md-6">
		     <div class="panel panel-default">
		       <div class="panel-heading">
		         <h4 class="panel-title">
			       <i class="s16 glyphicon glyphicon-paperclip"></i> <span>Contratos Proximos ao Vencimento</span>
			     </h4>
		       </div>
		       <div class="panel-body">
		        
		  <table class="table table-bordered table-hover table-condensed table-striped"> 
		    <thead> 
			   <tr> 
			     <th>Cedente</th> 
				 <th>DT. Contrato</th> 
				 <th>A Venc.60d</th>
				 <th>A Venc.30d</th>
				 <th>A Venc.10d</th>
				 <th>Vencidos</th>
			   </tr> 
			 </thead> 
			  <tbody id="ContratosProximosAoVencimento"> 
			  </tbody> 
			</table>
		  
		       </div>
		    </div>
		  </div>
		  </div>
	   </div>
	   
	   <div id="menu3" class="tab-pane fade">
	     
		 
		  <div class="row"  id="draggablePanelList4">
	       <div class="col-md-5">
		     <div class="panel panel-default">
		       <div class="panel-heading">
		         <h4 class="panel-title">
			       <i class="s16 glyphicon glyphicon-paperclip"></i> <span>Caixa</span>
			     </h4>
		       </div>
		       <div class="panel-body">
		        
			   <table class="table table-bordered table-hover table-condensed table-striped"> 
			    <thead> 
				   <tr> 
				     <th>Conta</th> 
					 <th>Valor</th> 
					 <th>%</th> 
				   </tr> 
				 </thead> 
				  <tbody id="TitulosPorBancoLiquidacao"> 
				  </tbody> 
				</table>
		  
		       </div>
		    </div>
		  </div>
		   <div class="col-md-7">
		     <div class="panel panel-default">
		       <div class="panel-heading">
		         <h4 class="panel-title">
			       <i class="s16 glyphicon glyphicon-signal"></i> <span>Saldo em Caixa</span>
			     </h4>
		       </div>
		       <div class="panel-body">
				   <div id="Pizza" style=" height: 400px;margin: 0 auto" align="center"></div>
		       </div>
		    </div>
		  </div>
		  </div>


		 
	   </div>
</div>

 <div class="row"  id="draggablePanelList4">
	   <div class="col-md-10">
	       <i class="s16 glyphicon glyphicon-refresh" onclick="popular_Painel()"></i> 
	   </div>
	   <div class="col-md-2">
	        <div id="tempo" align="right"></div>
	   </div>
 </div>



  </div>
	  </div>	  
</div>

</body>
</html>

<script>
jQuery(function($) 
{
        var panelList = $('#draggablePanelList');
		var panelList2 = $('#draggablePanelList2');
		var panelList3 = $('#draggablePanelList3');
		var panelList4 = $('#draggablePanelList4');

        panelList.sortable({
            // Only make the .panel-heading child elements support dragging.
            // Omit this to make then entire <li>...</li> draggable.
            handle: '.panel-heading', 
            update: function() {
                $('.panel', panelList).each(function(index, elem) {
                     var $listItem = $(elem),
                         newIndex = $listItem.index();
                          console.log(elem);
                     // Persist the new indices.
                });
            }
        });
		
		
		
        panelList2.sortable({
            // Only make the .panel-heading child elements support dragging.
            // Omit this to make then entire <li>...</li> draggable.
            handle: '.panel-heading', 
            update: function() {
                $('.panel', panelList2).each(function(index, elem) {
                     var $listItem = $(elem),
                         newIndex = $listItem.index();

                     // Persist the new indices.
                });
            }
        });
		
		
		   panelList3.sortable({
	        // Only make the .panel-heading child elements support dragging.
            // Omit this to make then entire <li>...</li> draggable.
            handle: '.panel-heading', 
            update: function() {
                $('.panel', panelList3).each(function(index, elem) {
                     var $listItem = $(elem),
                         newIndex = $listItem.index();

                     // Persist the new indices.
                });
            }
        });


		 panelList4.sortable({
	        // Only make the .panel-heading child elements support dragging.
            // Omit this to make then entire <li>...</li> draggable.
            handle: '.panel-heading', 
            update: function() {
                $('.panel', panelList4).each(function(index, elem) {
                     var $listItem = $(elem),
                         newIndex = $listItem.index();

                     // Persist the new indices.
                });
            }
        });
});

function dataAtualFormatada()
{
    var data = new Date();
    var dia = data.getDate();
    if (dia.toString().length == 1)
      dia = "0"+dia;
    var mes = data.getMonth()+1;
    if (mes.toString().length == 1)
      mes = "0"+mes;
    var ano = data.getFullYear(); 

	var hora    = data.getHours();          // 0-23
	var min     = data.getMinutes();        // 0-59
	var seg     = data.getSeconds();        // 0-59
	var mseg    = data.getMilliseconds();   // 0-999
	var tz      = data.getTimezoneOffset(); // em minutos

    return dia+"/"+mes+"/"+ano+" - "+hora+":"+min+":"+seg;
  }

function TrataTipoDeDocumento(Tipo)
{

	var TipoDesc;

	switch (Tipo) {
	    case "040":
	        TipoDesc = "Duplicatas";
	        break;
	    case "041":
	        TipoDesc = "Cheques";
	        break;
	    case "043":
	        TipoDesc = "NP";
	        break;
	    case "046":
	        TipoDesc = "Adiantamento";
	        break;        
	    default: 
	        TipoDesc = Tipo;
	 }

	 return TipoDesc }

function ToolTip(local,Tooltip)
{
	$(local).tooltip({
		placement: "top",
		title: Tooltip
	});
 }

function CriarPizza(categorias_)
	{
	var chart;
	    $(document).ready(function() {
	        chart = new Highcharts.Chart({
	            chart: {
	                renderTo: 'Pizza',
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
</script>




