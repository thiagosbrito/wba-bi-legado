<%-- 
    Document   : getData
    Created on : 18/09/2012
    Author     : Rafael Franco Regio dos Passos
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.*"%>


<%/*@page contentType="text/JSON" pageEncoding="UTF-8"*/%>

			
<%
    String driver="com.microsoft.sqlserver.jdbc.SQLServerDriver";
    String url="jdbc:sqlserver://PRUDENTSERV;DatabaseName=dw_wba_bi ";
    String usuario="sa";
    String senha="wba@1234";
    Connection  conexao;
    Statement statement;
    ResultSet resultset;
    
	//recupera parametro            
	String getData=request.getParameter("getData");
	String getCedente=request.getParameter("getCedente");
	String getSacado=request.getParameter("getSacado");
    String strQuery;
    
	
	
    try {
            Class.forName(driver);
            conexao = DriverManager.getConnection(url, usuario, senha);
            System.out.println("conectou em dw_wba_fi");
            statement = conexao.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
           
		   
		   if (getData.equals("1")){
		        strQuery = "";
				
				strQuery += " QUERY SQL";
			 
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
			strQuery += "   Query 2";
	
			 
			 
			 
			
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
			 
			 
			 
			 if (getData.equals("3")){   //Evolução da Operação Top 5 Sacados
			 
			  strQuery = "";
			  strQuery = " Query 2";
			  
			  
			  
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
			 
			 
			  if (getData.equals("4")){   //Evolução da Operação Top 5 Sacados -- com procedure
			  
					
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
            System.out.println("Driver não localizado: " + Driver);            
        } catch (SQLException Fonte) {
            System.out.println("Deu erro na conexão " +
                    "com a fonte de dados: " + Fonte);
        }
			
			
			
		
%>        
      
