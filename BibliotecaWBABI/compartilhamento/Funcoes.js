/*
Titulo:Conjunto de Funções que facilita e automatiza a criação dos graficos baseado em getData.jsp
Autor: Rafael Franco Regio dos Passos
Data Criação:06/02/2015
*/

var EnderecoAPIjson = "/pentaho/getDataWBA?";

function MontaComboPosicoesHistoricas(RenderTo,chamarFuncaoAoTerminar)
{
		var options = "";
		
		$.getJSON(EnderecoAPIjson+'&getData=PosicoesHistoricas', function(data) {
			console.log(EnderecoAPIjson+'&getData=PosicoesHistoricas');
		}).done(function(data) {
			$.each(data, function(key, val) {
				options += '<option value="' + val.SK_DATA_CARGA + '">' + val.MESANO + '</option>';
			});
		}).always(function() {
			$("#"+RenderTo).html(options);
			
			 if (chamarFuncaoAoTerminar != "")
			 {
			   eval(chamarFuncaoAoTerminar);
			 }
		});
}

function MontaComboEmpresa(RenderTo,chamarFuncaoAoTerminar)
{
		var options = "<option value='1,2'>TODOS</option>";
		
		$.getJSON(EnderecoAPIjson+'&getData=empresa', function(data) {
			console.log(EnderecoAPIjson+'&getData=empresa');
		}).done(function(data) {
			$.each(data, function(key, val) {
				options += '<option value="' + val.ID_EMPRESA + '">' + val.EMPRESA + '</option>';
			});
		
			$("#"+RenderTo).html(options);
		     
			if (chamarFuncaoAoTerminar != "")
			 {
			   eval(chamarFuncaoAoTerminar);
			 }
		
		}).always(function() {
			$("#"+RenderTo).html(options);
			
			
			if (chamarFuncaoAoTerminar != "")
			 {
			   eval(chamarFuncaoAoTerminar);
			 }
			 
		});
}

function MontaComboCedentePorEmpresa(RenderTo,Empresa,chamarFuncaoAoTerminar)
{

		var options = "<option value='TODOS'>TODOS</option>";
		var UrlChamada = EnderecoAPIjson+'&getData=CedentesDaEmpresa&getEmpresa='+Empresa;	
			
		console.log(UrlChamada);	
		$.getJSON(UrlChamada, function(data) {
			$.each(data, function(key, val) {
			   options += '<option value="' + val.IDCEDENTE + '">' + val.NOMECEDENTE + '</option>';
			});
		}).done(function(data) {
			$("#"+RenderTo).html(options);
			
			if (chamarFuncaoAoTerminar != "")
			 {
			   eval(chamarFuncaoAoTerminar);
			 }
			 
		});
}




