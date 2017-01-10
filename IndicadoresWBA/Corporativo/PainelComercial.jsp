<!DOCTYPE HTML>
<html lang="pt-Br">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>WBA BI - Painel Comercial</title>
	
	<!-- JQUERY -->
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
function  loadData(){
	ThemaDark(); //Aplica o Thema aos dashbord
	chamaGraficoVOP();
}

//---------------------------------------------------------CHAMA GRAFICO DE COMPORTAMENTO POR EMPRESA
function chamaGraficoVOP(){
	var categoriasMes  = new Array();
	var Empresa1       = new Array();
	var Empresa2       = new Array();
	var NomeEmpresa1;
	var NomeEmpresa2;
	//carregaNomeEmpresa();	
	//alert(dump(data.result.metadata.columns[1]));
	
	//Captura retorno do JSON vindo de uma XACTION com query MDX
	$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelComercial.xaction/generatedContent?&getData=VopComparativoEmpresa12Meses&Mes='+getMesAtual(), function(data) {	
				
	var ColunasRetorno = data.result.metadata.cols-1; // Pega o numero de empresa **-1** pq a primeira coluna é descarte
	
			
	if (ColunasRetorno == 1) // 1 Empresa
    {
		//Pega o nome da 1º Empresa
	    NomeEmpresa1 = data.result.metadata.columns[1];
	
    	//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
		$.each(data.result.data, function(key, val) {
				categoriasMes[key]    = val[0];  //1=Factoring 2=FIDC
				Empresa1[key] = parseFloat(val[1]);
		});
		
		GraficoDeBarrasSimplesComCliqueNaBarra(categoriasMes,Empresa1,NomeEmpresa1, "Superior");
	}
	
	if (ColunasRetorno == 2) // 2 Empresa
    {
    
    	NomeEmpresa1 = data.result.metadata.columns[1];
		NomeEmpresa2 = data.result.metadata.columns[2];
		
		
		//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
		$.each(data.result.data, function(key, val) {
				categoriasMes[key]    = val[0];  //1=Factoring 2=FIDC
				Empresa1[key] 		  = parseFloat(val[1]);
				Empresa2[key]         = parseFloat(val[2]);
		});
		
		GraficoDeBarrasDuplasComCliqueNasBarras(categoriasMes,Empresa1,Empresa2,NomeEmpresa1,NomeEmpresa2,"Superior");
		
	}
	
		ChamarGraficoDrillDown(categoriasMes[0] , data.result.metadata.columns[1]);
	
	});
}





//----------------------------------------------------------------------------------GRAFICO TOP 5 GERENTE
function ChamarGraficoDrillDown(mesAno_, empresa_)
{
	 var gerentes = new Array();
     var gerenteString = "";

	 mesAno_ = mesAno_.replace(' ','-');
	 $.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelComercial.xaction/generatedContent?&getData=Top5GerentesPorEmpresaMesParametro&Mes='+mesAno_+"&Empresa="+empresa_, function(data) {	
					
					//alert(dump(data));
					
				
					$.each(data.result.data, function(key, val) {
							gerenteString = val[1];
   
							if (gerenteString ==" "){
							    gerenteString = "Nome não definido";
							}
							gerentes[key]  = new Array(gerenteString,parseFloat(val[2]));
							
							
					});
					
					
					if (gerentes.length < 5)
					{
					
					    for (i=gerentes.length; i<5; i++)
						{
						   gerentes[i] = new Array(" ".toString(),parseFloat(0));
						}
					}

					//Chama função que gera o grafico e passa o array com os valores
					CriarGraficoDrillDown(gerentes,mesAno_,empresa_,empresa_);
	});
}


		

function CriarGraficoDrillDown(gerentes_,mesAno_,empresaAux_, EmpresaNumber)
{



 var chart;
    $(document).ready(function() {
        var colors = Highcharts.getOptions().colors,
            categories = [gerentes_[0][0],gerentes_[1][0],gerentes_[2][0],gerentes_[3][0],gerentes_[4][0]],
            name = 'Gerentes',
            data = [ 
					{	
				    y:gerentes_[0][1], //Valor DrillUP
                    color: colors[0],
                	drilldown: { //Valor DriwDOWN
                        name: gerentes_[0][0],
                        color: colors[0] 
                    }
					}
					,{
				    y:gerentes_[1][1], //Valor DriwUP
                    color: colors[1],
                	drilldown: { //Valor DriwDOWN
                        name: gerentes_[1][0],
                        color: colors[1] 
                    }
					}
					,{
				    y:gerentes_[2][1], //Valor DriwUP
                    color: colors[2],
                	drilldown: { //Valor DriwDOWN
                        name: gerentes_[2][0],
                        color: colors[2] 
                    }
        			}
										,{
				    y:gerentes_[3][1], //Valor DriwUP
                    color: colors[3],
                	drilldown: { //Valor DriwDOWN
                        name: gerentes_[3][0],
                        color: colors[3] 
                    }
        			}
										,{
				    y:gerentes_[4][1], //Valor DriwUP
                    color: colors[4],
                	drilldown: { //Valor DriwDOWN
                        name: gerentes_[4][0],
                        color: colors[4] 
                    }
					}
				
					];
    
        function setChart(name, categories, data, color) {
			chart.xAxis[0].setCategories(categories, false);
			chart.series[0].remove(false);
			chart.addSeries({
				name: name,
				data: data,
				color: color || 'white'
			}, false);
			chart.redraw();
        }
		
	


    
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'Inferior',
                type: 'column'
            },
            title: {
                text: mesAno_
            },
            subtitle: {
                text: empresaAux_
            },
            xAxis: {
                categories: categories
            },
            yAxis: {
                title: {
                    text: null
                }
            },
            plotOptions: {
                column: {
                    cursor: 'pointer',
                    point: {
                        events: {
                            click: function() {

							
	

							   var drilldown = this.drilldown;
                                
								//mesAno_ = mesAno_.replace('-',' ')
								if (drilldown) { // drill down
                                    
									//alert(gerentes_[this.x][0]);


								
										var cedentesAux = new Array();
										//alert('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelComercial.xaction/generatedContent?&getData=11&Mes='+mesAno_+"&Gerente="+gerentes_[this.x][0]+"&Empresa="+EmpresaNumber);
									$.getJSON('/pentaho/api/repos/:_WBA-FI:JSP_DASH:Corporativo:PainelComercial.xaction/generatedContent?&getData=11&Mes='+mesAno_+"&Gerente="+gerentes_[this.x][0]+"&Empresa="+EmpresaNumber, function(data) {	
													
													//console.log(data);
													
													//loop nos registros para pegar o registro[0] = descrição do mes e seus valores por Empresa
													$.each(data.result.data, function(key, val) {
														cedentesAux[key]  = new Array(val[0], parseFloat(val[1]));	
													});
								
														setChart(drilldown.name, cedentesAux, cedentesAux, drilldown.color);
								
									});
									
                                } else { // restore
                                    setChart(name, categories, data);
                                }
                            }
                        }
                    },
                    dataLabels: {
                        enabled: true,
                        color: colors[0],
                        style: {
                            fontWeight: 'bold'
                        },
                        formatter: function() {
                            return 'R$ '+formatNumber(this.y);
                        }
                    }
                }
            },
            tooltip: {
                formatter: function() {
                    var point = this.point,
                        s = this.x +':<b>'+ 'R$ '+formatNumber(this.y) +'</b><br/>';
                    if (point.drilldown) {
                        s += 'Click to view '+ point.category;
                    } else {
                        s += 'Click to return to browser brands';
                    }
                    return s;
                }
            }
			
			,
            credits: {
                enabled: false
            }
			,
			
            series: [{
                name: name,
                data: data,
                color: 'white'
            }],
            exporting: {
                enabled: false
            }
        });
    });
    
	$.unblockUI();

	
//by Rpassosfraco	
}



</script>

</head>
<body onload="javascript: loadData()" style="background-color:#414141">
  

<div  style="padding:0px 0px 0px 0px; height:120%">
  <div class="container" >
      <!-- CLASSE QUE DEFINE O CONTAINER COMO FLUIDO (100%) -->
    <div class="container-fluid" >
      <div class="row">
        <div class="row">
    	    <div class="col-md-12"></div>
    	  </div>
        <!-- COLUNA OCUPANDO 10 ESPA&#231;OS NO GRID -->
        <div class="col-md-12">
          <div class="BordasArredondadas">			 
    		     <div class="TituloDash">VOP - Comparativo Empresa - Ultimos 12 Meses</div>
    	       <div id="Superior" class="AreaGrafica">Grafico 1</div>
          </div>
          <div style="padding:0.9%"></div>
          <div class="BordasArredondadas">
    	      <div class="TituloDash">Top 5  Gerente</div>
            <div id="Inferior" class="AreaGrafica">Grafico 2</div>
          </div>	  
        </div>
      </div>
    </div>
  </div> 
</div>
</body>
</html>
