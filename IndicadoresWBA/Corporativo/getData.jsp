<%-- 
    Document   : getData
    Created on : 18/09/2012
	modificado em: 10/02/2015
    Author     : Rafael Franco Regio dos Passos
--%>

	
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>


<%!
    String GeraJson(ResultSet resultset){ 
    String RetornoJson="";
	
	try{
		ResultSetMetaData meta = resultset.getMetaData(); 
		int NumeroDeColunas = meta.getColumnCount();
		//converte para json
		RetornoJson = "[";
		
		while (resultset.next()) { 
		RetornoJson=RetornoJson+"{";
		
				for (int x=1; x <= NumeroDeColunas; x++){
				RetornoJson=RetornoJson+"\""+meta.getColumnName(x).toUpperCase()+"\":"+"\""+resultset.getString(meta.getColumnName(x))+"\"";
				if (x != NumeroDeColunas)
				 {
				  RetornoJson=RetornoJson+",";
				 }
			}
			RetornoJson=RetornoJson+"},";
		} 
		RetornoJson=RetornoJson.substring(0, RetornoJson.length() - 1)+"]"; 
		
	}catch(Exception e ){
	 RetornoJson = "{\"end\":\"true\"}]";
	}
	return RetornoJson.trim(); 
  
  }  
%>
<%
    String driver="com.microsoft.sqlserver.jdbc.SQLServerDriver";
    String url="jdbc:sqlserver://SRVBI;DatabaseName=dw_wba_bi";
    String usuario="sa";
    String senha="wba@1234";
    Connection  conexao;
    Statement statement;
    ResultSet resultset;
    
	//recupera parametro            
	String getData    =request.getParameter("getData");
	String getCedente =request.getParameter("getCedente");
	String getSacado  =request.getParameter("getSacado");
	String getEmpresa =request.getParameter("getEmpresa");
	String getDataFoto=request.getParameter("getDataFoto");
    String strQuery;
  
	
    try {
            Class.forName(driver);
            conexao = DriverManager.getConnection(url, usuario, senha);
            System.out.println("conectou em dw_wba_bi");
            statement = conexao.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
           
		    //Traz as Empresas  
		    if (getData.equals("empresa")){
				//monta query
				strQuery = "select dm023_001 id_empresa, dm023_010 empresa, dm023_040 grupo from tctbdm023 where dm023_001 <> -1";
				
				//Executa query
				resultset = statement.executeQuery(strQuery);		
				out.println(GeraJson(resultset));
			}
			
			//Traz os Cedentes por Empresa
			 if (getData.equals("CedentesDaEmpresa")){
			     System.out.println("CedentesDaEmpresa");
				//monta query
				strQuery = "select distinct   c.DM001_000 IdCedente, replace(rtrim(ltrim(c.DM001_010)),'	','') as NomeCedente from OPTBFT001 F inner join tctbdm001 as c on c.dm001_000 = F.DM001_000 inner join tctbdm023 emp on f.DM023_000 = emp.DM023_000 where emp.DM023_001 in ("+getEmpresa+")  and c.dm001_000 <> -1";
				//strQuery = "select DM001_000 IdCedente , DM001_010 NomeCedente from TCTBDM001 order by 2";
				
				//Executa query
				resultset = statement.executeQuery(strQuery);	
				String Resultado = GeraJson(resultset);
				out.print(Resultado);
			}
			
			//Traz todas posicoes HISTORICAS - OPTBFT001_HIST	
			 if (getData.equals("PosicoesHistoricas")){
				//monta query
				strQuery = "select distinct t.dm028_000 sk_data_carga ,t.DM028_160 as MesAno from OPTBFT001_HIST f inner join TCTBDM028 as t on t.DM028_000 = f.sk_data_carga order by 1 desc";
				
				//Executa query
				resultset = statement.executeQuery(strQuery);		
				out.print(GeraJson(resultset));
			}
			
			//Recebiveis da Carteira do Cedente --HISTORICA
			if (getData.equals("PosicoesHistoricasRecebiveisDoCedente")){
				//monta query
				
				if (getCedente.equals("TODOS"))
				{
				   strQuery = "select  case when o.DM060_001 = '046' then 'Comissaria'              when o.DM060_001 = '041' then 'Cheques'              when o.DM060_001 = '040' then 'Titulos'              when o.DM060_001 = '053' then 'Fomento'              when o.DM060_001 = '042' then 'Renegociados' end  TipoRecebiveis,         sum(f.opft001_110) as ValorTitulo from OPTBFT001_HIST f inner join OPTBDM060 as o on o.dm060_000 = f.DM099_000 where f.sk_data_carga  ="+getDataFoto+" and   o.DM060_001 in ('046','041','040','053','042') group by o.DM060_001";
				}
				else{
				
				   strQuery = "select  case when o.DM060_001 = '046' then 'Comissaria'              when o.DM060_001 = '041' then 'Cheques'              when o.DM060_001 = '040' then 'Titulos'              when o.DM060_001 = '053' then 'Fomento'              when o.DM060_001 = '042' then 'Renegociados' end  TipoRecebiveis,         sum(f.opft001_110) as ValorTitulo from OPTBFT001_HIST f inner join OPTBDM060 as o on o.dm060_000 = f.DM099_000 where f.sk_data_carga  ="+getDataFoto+" and   f.dm001_000      = "+getCedente+" and   o.DM060_001 in ('046','041','040','053','042') group by o.DM060_001";
				
				}
				
				//Executa query
				 resultset = statement.executeQuery(strQuery);		
				 out.print(GeraJson(resultset));
			}
			
			//Recebiveis da Carteira do Cedente --HISTORICA
			if (getData.equals("PosicoesHistoricasEvolucaoOperacaoDataVencimento")){
				//monta query
				
				if (getCedente.equals("TODOS"))
				{
				strQuery = "select   day(t.DM028_010)   as DiadataVencimento,  month(t.DM028_010) as MesdataVencimento,  Year(t.DM028_010)  as AnodataVencimento,  t.DM028_010        as dataVencimento,  sum(f.opft001_110) Vop from OPTBFT001_HIST f  inner join OPTBDM060 as o on o.dm060_000 =  f.DM099_000  inner join TCTBDM028 as t on t.dm028_000 =  f.sk_data_vcto where f.sk_data_carga  ="+getDataFoto+"  and  o.DM060_001 in ('046','041','040','053','042') group by t.DM028_010 order by 4 ";
				}
				else{
				
				strQuery = "select   day(t.DM028_010)   as DiadataVencimento,  month(t.DM028_010) as MesdataVencimento,  Year(t.DM028_010)  as AnodataVencimento,  t.DM028_010        as dataVencimento,  sum(f.opft001_110) Vop from OPTBFT001_HIST f  inner join OPTBDM060 as o on o.dm060_000 =  f.DM099_000  inner join TCTBDM028 as t on t.dm028_000 =  f.sk_data_vcto where f.sk_data_carga  ="+getDataFoto+" and   f.dm001_000      = "+getCedente+" and  o.DM060_001 in ('046','041','040','053','042') group by t.DM028_010 order by 4 ";
				
				}
				
				//Executa query
				resultset = statement.executeQuery(strQuery);		
				out.print(GeraJson(resultset));
			}
			
			//Traz valor inclussão por empresa/Mes-Ano
			 if (getData.equals("ValorInclusaoAnoMesEmpresa")){
				//monta query
					strQuery = "select    e.DM023_010 as Empresa,   t.DM028_001 as AnoMes,   t.DM028_160 as MesAno,   sum(f.opft001_200) ValorInclusao from OPTBFT001 f  inner join TCTBDM023 as e on e.dm023_000 = f.dm023_000  inner join OPTBDM060 as o  on o.dm060_000 =  f.DM099_000  inner join TCTBDM012 as ct on ct.dm012_000 = f.dm012_000  inner join TCTBDM028 as t on t.dm028_000 =  f.sk_data_dgto where o.DM060_001 in ('040','041','046') and ct.DM012_030 = 'Propria' and t.DM028_010 BETWEEN (dateadd(year,-1,getDate())) and getDate() group by e.DM023_010 ,t.DM028_160,t.DM028_001 order by t.DM028_001";
				
				//Executa query
				resultset = statement.executeQuery(strQuery);		
				out.print(GeraJson(resultset));
			}
		   if (getData.equals("1")){
		        strQuery = "";
				
				strQuery += " SELECT TOP_5_CEDENTE.DM001_010 AS CEDENTE ,  ((TOP_5_CEDENTE.VALOR_TITULO / TOP_5_CEDENTE.VALOR_CARTEIRA) * 100) AS 	CONCENTRACAO FROM";
				strQuery += "	(SELECT TOP 5   DM01.DM001_010 ,SUM([OPFT001_110]) AS VALOR_TITULO,(SELECT SUM([OPFT001_110]) AS VALOR_CARTEIRA 			FROM [OPTBFT001] AS OPFT01 INNER JOIN [OPTBDM060] AS DM60 ON OPFT01.DM099_000 = DM60.DM060_000  		WHERE OPFT01.DM062_000 IN (1,2)   AND OPFT01.DM012_000 IN (1,3)  AND DM60.[DM060_020] = 2";		  
				strQuery += "		) AS VALOR_CARTEIRA	FROM [OPTBFT001] AS OPFT01  INNER JOIN [TCTBDM001] AS DM01 		ON OPFT01.DM001_000 = DM01.DM001_000 INNER JOIN [TCTBDM062] AS DM62 ON OPFT01.DM062_000 = DM62.DM062_000";
				strQuery += "  INNER JOIN [OPTBDM060] AS DM60 ON OPFT01.DM099_000 = DM60.DM060_000  INNER JOIN [TCTBDM012] AS DM12"; 
				strQuery += "  ON OPFT01.DM012_000 = DM12.DM012_000	  WHERE DM62.DM062_000 IN (1,2) AND DM60.DM060_020 = 2";
				strQuery += "  	AND DM12.DM012_000 IN (1,3) GROUP BY DM01.DM001_010  ORDER BY 2 DESC ) AS TOP_5_CEDENTE";
			 
				resultset = statement.executeQuery(strQuery);		 
		
		
				/*Gera Arquivo no formato jSon*/
				 out.print("["); 
				 while (resultset.next()) { 
				 
							String CEDENTE=resultset.getString("CEDENTE");
							String CONCENTRACAO=resultset.getString("CONCENTRACAO");
				 
							out.print(                    
										"{"+
								"\"CEDENTE\":"+"\""+CEDENTE+"\","+
								"\"CONCENTRACAO\":\""+CONCENTRACAO+"\"},"
							);
				 }
				 out.print(" {\"end\":\"true\"}]");
			}
			
			
			if (getData.equals("2")){ // CEDENTE - EVOLUCAO DE OPERACAO  
			
			strQuery = "";
			strQuery += "   SELECT 	   (CONVERT(varchar,DM28.DM028_010,101))  AS DATA_INCLUSAO_CONTABIL 	  ,SUM([OPFT001_110]) AS VALOR_TITULO   FROM [OPTBFT001] AS OPFT01   INNER JOIN [TCTBDM028] AS DM28 		ON OPFT01.DM028_000 = DM28.DM028_000   INNER JOIN [TCTBDM001] AS DM01 		ON OPFT01.DM001_000 = DM01.DM001_000   INNER JOIN [TCTBDM062] AS DM62 		ON OPFT01.DM062_000 = DM62.DM062_000   INNER JOIN [OPTBDM060] AS DM60 		ON OPFT01.DM099_000 = DM60.DM060_000   INNER JOIN [TCTBDM012] AS DM12 		ON OPFT01.DM012_000 = DM12.DM012_000   WHERE       DM60.DM060_020 = 2		     AND DM12.DM012_000 IN (1,3)     AND DM01.DM001_010 = '"+getCedente+"'     AND DM28.DM028_001 BETWEEN        CAST( 						  LTRIM(RTRIM(CAST(YEAR(DATEADD(mm, DATEDIFF(m,0,GETDATE())-12,0))AS CHAR(5)))) 						  + 						  CASE WHEN LEN(CAST(MONTH(DATEADD(mm, DATEDIFF(m,0,GETDATE())-12,0))AS CHAR(3))) = 1 THEN '0'+CAST(MONTH(DATEADD(mm, DATEDIFF(m,0,GETDATE())-12,0))AS CHAR(3)) 						  ELSE CAST(MONTH(DATEADD(mm, DATEDIFF(m,0,GETDATE())-12,0))AS CHAR(3)) END 						   AS INT) 				   AND CAST( 						  LTRIM(RTRIM(CAST(YEAR(GETDATE())AS CHAR(5)))) 						  + 						  CASE WHEN LEN(CAST(MONTH(GETDATE()) AS CHAR(3))) = 1 THEN '0'+CAST(MONTH(GETDATE())AS CHAR(3)) 						  ELSE CAST(MONTH(GETDATE())AS CHAR(3)) END 						  AS INT)   GROUP BY 	  DM28.DM028_010";
	
			 
			 
			 
			
			resultset = statement.executeQuery(strQuery);		 
		
		
				/*Gera Arquivo no formato jSon*/
				 out.print("["); 
				 while (resultset.next()) { 
				 
				 
				 
							//String CEDENTE=resultset.getString("CEDENTE");
							String DATA_INCLUSAO_CONTABIL=resultset.getString("DATA_INCLUSAO_CONTABIL");
							String VALOR_TITULO=resultset.getString("VALOR_TITULO");
				 
							out.print(                    
										"{"+
								"\"DATA_INCLUSAO_CONTABIL\":"+"\""+DATA_INCLUSAO_CONTABIL+"\","+
								"\"VALOR_TITULO\":\""+VALOR_TITULO+"\"},"
							);
				 }
				 out.print(" {\"end\":\"true\"}]");
				 
			 
			 }
			 
			 
			 
			 if (getData.equals("3")){   //Evolucao da Operacao Top 5 Sacados
			 
			  strQuery = "";
			  strQuery = "  select Final.SACADO        ,SUM(Final.M1) as M1        ,SUM(Final.M2) as M2        ,SUM(Final.M3) as M3        ,SUM(Final.M4) as M4        ,SUM(Final.M5) as M5        ,SUM(Final.M6) as M6        ,SUM(Final.M7) as M7        ,SUM(Final.M8) as M8        ,SUM(Final.M9) as M9        ,SUM(Final.M10) as M10        ,SUM(Final.M11) as M11        ,SUM(Final.M12) as M12   from  (   SELECT   aux.SACADO ,   CASE WHEN aux.MES = 1 then aux.VALOR_TITULO else 0 end as 'M1'  ,CASE WHEN aux.MES = 2 then aux.VALOR_TITULO else 0 end as 'M2'  ,CASE WHEN aux.MES = 3 then aux.VALOR_TITULO else 0 end as 'M3'  ,CASE WHEN aux.MES = 4 then aux.VALOR_TITULO else 0 end as 'M4'  ,CASE WHEN aux.MES = 5 then aux.VALOR_TITULO else 0 end as 'M5'  ,CASE WHEN aux.MES = 6 then aux.VALOR_TITULO else 0 end as 'M6'  ,CASE WHEN aux.MES = 7 then aux.VALOR_TITULO else 0 end as 'M7'  ,CASE WHEN aux.MES = 8 then aux.VALOR_TITULO else 0 end as 'M8'  ,CASE WHEN aux.MES = 9 then aux.VALOR_TITULO else 0 end as 'M9'  ,CASE WHEN aux.MES = 10 then aux.VALOR_TITULO else 0 end as 'M10'  ,CASE WHEN aux.MES = 11 then aux.VALOR_TITULO else 0 end as 'M11'  ,CASE WHEN aux.MES = 12 then aux.VALOR_TITULO else 0 end as 'M12'   FROM  (    select  	YEAR(C.DATA_INCLUSAO_CONTABIL) as ANO , MONTH(C.DATA_INCLUSAO_CONTABIL) as MES, C.SACADO, SUM(C.VALOR_TITULO) as VALOR_TITULO  from  (            SELECT         DM28.DM028_010     AS DATA_INCLUSAO_CONTABIL 	  , DM22.DM022_010	   AS SACADO 	  , SUM([OPFT001_110]) AS VALOR_TITULO   FROM [OPTBFT001] AS OPFT01   INNER JOIN [TCTBDM028] AS DM28 		ON OPFT01.DM028_000 = DM28.DM028_000   INNER JOIN [TCTBDM001] AS DM01 		ON OPFT01.DM001_000 = DM01.DM001_000   INNER JOIN [TCTBDM022] AS DM22 		ON OPFT01.DM022_000 = DM22.DM022_000   INNER JOIN [TCTBDM062] AS DM62 		ON OPFT01.DM062_000 = DM62.DM062_000   INNER JOIN [OPTBDM060] AS DM60 		ON OPFT01.DM099_000 = DM60.DM060_000   INNER JOIN [TCTBDM012] AS DM12 		ON OPFT01.DM012_000 = DM12.DM012_000   WHERE  DM60.DM060_020 = 2		     AND DM12.DM012_000 IN (1,3)     AND DM22.DM022_000 NOT IN (-1,-2)  	AND DM22.DM022_010 IN 		( 			  SELECT TOP 5   				DM22.DM022_010	   AS SACADO 			  FROM [OPTBFT001] AS OPFT01 			  INNER JOIN [TCTBDM001] AS DM01 					ON OPFT01.DM001_000 = DM01.DM001_000 			  INNER JOIN [TCTBDM022] AS DM22 					ON OPFT01.DM022_000 = DM22.DM022_000 			  INNER JOIN [TCTBDM062] AS DM62 					ON OPFT01.DM062_000 = DM62.DM062_000 			  INNER JOIN [OPTBDM060] AS DM60 					ON OPFT01.DM099_000 = DM60.DM060_000 		  INNER JOIN [TCTBDM012] AS DM12 					ON OPFT01.DM012_000 = DM12.DM012_000 			  WHERE 			  				DM60.DM060_020 = 2		 				AND DM12.DM012_000 IN (1,3) 				AND DM22.DM022_000 NOT IN (-1,-2)   				AND DM01.DM001_010 = '"+getCedente+"' 			    			  GROUP BY DM22.DM022_010 			        			  ORDER BY SUM([OPFT001_110]) DESC 		)     AND DM01.DM001_010 = '"+getCedente+"'         AND DM28.DM028_001 BETWEEN   CAST( 						  LTRIM(RTRIM(CAST(YEAR(DATEADD(mm, DATEDIFF(m,0,GETDATE())-12,0))AS CHAR(5)))) 						  + 						  CASE WHEN LEN(CAST(MONTH(DATEADD(mm, DATEDIFF(m,0,GETDATE())-12,0))AS CHAR(3))) = 1 THEN '0'+CAST(MONTH(DATEADD(mm, DATEDIFF(m,0,GETDATE())-12,0))AS CHAR(3)) 						  ELSE CAST(MONTH(DATEADD(mm, DATEDIFF(m,0,GETDATE())-12,0))AS CHAR(3)) END 						   AS INT) 				      AND CAST( 						  LTRIM(RTRIM(CAST(YEAR(GETDATE())AS CHAR(5)))) 						  + 						  CASE WHEN LEN(CAST(MONTH(GETDATE()) AS CHAR(3))) = 1 THEN '0'+CAST(MONTH(GETDATE())AS CHAR(3)) 						  ELSE CAST(MONTH(GETDATE())AS CHAR(3)) END 						  AS INT)   GROUP BY DM22.DM022_010          , DM28.DM028_010              )C       group by YEAR(C.DATA_INCLUSAO_CONTABIL)  , MONTH(C.DATA_INCLUSAO_CONTABIL), C.SACADO      ) AS aux   ) as Final   group by Final.SACADO     ORDER BY 1 DESC  ";
			  
			  
			  
			  resultset = statement.executeQuery(strQuery);		 
		
		
				/*Gera Arquivo no formato jSon*/
				 out.print("["); 
				 while (resultset.next()) { 
				 
				 
				 
							String SACADO=resultset.getString("SACADO");
							String M1=resultset.getString("M1");
							String M2=resultset.getString("M2");
							String M3=resultset.getString("M3");
							String M4=resultset.getString("M4");
							String M5=resultset.getString("M5");
							String M6=resultset.getString("M6");
							String M7=resultset.getString("M7");
							String M8=resultset.getString("M8");
							String M9=resultset.getString("M9");
							String M10=resultset.getString("M10");
							String M11=resultset.getString("M11");
							String M12=resultset.getString("M12");
							
							
							
				 
							out.print(                    
										"{"+
								"\"SACADO\":"+"\""+SACADO+"\","+
								"\"M1\":"+"\""+M1+"\","+
								"\"M2\":"+"\""+M2+"\","+
								"\"M3\":"+"\""+M3+"\","+
								"\"M4\":"+"\""+M4+"\","+
								"\"M5\":"+"\""+M5+"\","+
								"\"M6\":"+"\""+M6+"\","+
								"\"M7\":"+"\""+M7+"\","+
								"\"M8\":"+"\""+M8+"\","+
								"\"M9\":"+"\""+M9+"\","+
								"\"M10\":"+"\""+M10+"\","+
								"\"M11\":"+"\""+M11+"\","+
								"\"M12\":\""+M12+"\"},"
							);
				 }
				 out.print(" {\"end\":\"true\"}]");
			 
			 }
			 
			 
			  if (getData.equals("4")){   //Evolucao da Operacao Top 5 Sacados -- com procedure
			  
					
					//String query = "exec EVOLUCAO_OPERACAO_TOP_5_SACADOS 'SUN FOODS IND. DE PRODS. ALIMENTICIOS LTDA'";
	
					String query = "exec EVOLUCAO_OPERACAO_TOP_5_SACADOS '"+getCedente+"'";
	
					
					CallableStatement proc =  conexao.prepareCall(query);
					resultset = proc.executeQuery();  
						 
						 
						 out.print("["); 
						 while (resultset.next()) { 
					 
					    String SACADO = resultset.getString(1);
						String M1=resultset.getString(2);
						String M2=resultset.getString(3);
						String M3=resultset.getString(4);
						String M4=resultset.getString(5);
						String M5=resultset.getString(6);
						String M6=resultset.getString(7);
						String M7=resultset.getString(8);
						String M8=resultset.getString(9);
						String M9=resultset.getString(10);
						String M10=resultset.getString(11);
						String M11=resultset.getString(12);
						String M12=resultset.getString(13);
						
											
						if (M1 == null) M1 = "0";
						if (M2 == null) M2 = "0";
						if (M3 == null) M3 = "0";
						if (M4 == null) M4 = "0";
						if (M5 == null) M5 = "0";
						if (M6 == null) M6 = "0";
						if (M7 == null) M7 = "0";
						if (M8 == null) M8 = "0";
						if (M9 == null) M9 = "0";
						if (M10 == null) M10 = "0";
						if (M11 == null) M11 = "0";
						if (M12 == null) M12 = "0";						
						
						
					 out.print(                    
										"{"+
								"\"SACADO\":"+"\""+SACADO+"\","+
								"\"M1\":"+"\""+M1+"\","+
								"\"M2\":"+"\""+M2+"\","+
								"\"M3\":"+"\""+M3+"\","+
								"\"M4\":"+"\""+M4+"\","+
								"\"M5\":"+"\""+M5+"\","+
								"\"M6\":"+"\""+M6+"\","+
								"\"M7\":"+"\""+M7+"\","+
								"\"M8\":"+"\""+M8+"\","+
								"\"M9\":"+"\""+M9+"\","+
								"\"M10\":"+"\""+M10+"\","+
								"\"M11\":"+"\""+M11+"\","+
								"\"M12\":\""+M12+"\"},"
							);
				 }
				 out.print(" {\"end\":\"true\"}]");
			 
			 
					
					
					 
                    
			  
			  }
			 
			 
			 

          
        } catch (ClassNotFoundException Driver) {
            System.out.println("Driver nao localizado: " + Driver);            
        } catch (SQLException Fonte) {
            System.out.println("Deu erro na conexao " +
                    "com a fonte de dados: " + Fonte);
        }
			
			
			
		
%>        
      
