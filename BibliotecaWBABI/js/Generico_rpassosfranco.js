/*Funções genericas usadas por todo o produto
  by  Rpassosfranco  
*/




function ListaDeEmpresas(render_to,id_objeto,funcao_clic)
{
    var UrlGenericaParaJson ="/pentaho/ViewAction?solution=_WBA-FI&path=JSP_DASH/Corporativo&action=Empresa.xaction&getData=2";
	var combo    = "<select  style='width:100%' id='"+id_objeto+"' onchange='javascript: "+funcao_clic+"();'>CONTEUDO_COMBO</select>";
	var options  = "<option value='TODOS'>TODOS</option>";

	$.getJSON( UrlGenericaParaJson, {
		format: "json"
    })
	.done(function(data) {
       $.each(data.result.data, function(key, val) {
			options += '<option value="' + val[0] + '">' + val[1] + '</option>';			
	   });
	   
	    combo = combo.replace('CONTEUDO_COMBO',options);
	
	   	$("#"+render_to).html(combo);
    	$("#"+id_objeto).addClass("chzn-select"); 
	});
}
