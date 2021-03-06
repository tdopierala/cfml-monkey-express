<!--- GENERUJE DOKUMENT PDF --->
<cfsilent>

<cfdocument format="PDF" name="myPdf">
	
	<style type="text/css"> 
	<!-- 
	
		.clear { clear: both; float: none; }
		.admin_table tr td { width:100%; font-family: Arial; font-size: 12px; }
	--> 
	</style>
	
	<cfdocumentitem type="header" >
		<span style="font-family:Arial;font-size:12px;float:left;">
			Monkey Group, 
			ul. Wojskowa 6,
			60-792&nbsp;Poznań
		</span>
	</cfdocumentitem>

	<cfdocumentitem type="footer" >
		<span style="font-family:Arial;font-size:12px;float:left;">
			<cfoutput>#cfdocument.currentpagenumber#/#cfdocument.totalpagecount#</cfoutput>
		</span>
		
		<span style="font-family:Arial;font-size:12px;float:right;text-align:right;">
			Strona: <cfoutput>#my_page.pagename#</cfoutput><br />
			Data utworzenia dokumentu: <cfoutput>#DateFormat(Now(), "dd.mm.yyyy")# #TimeFormat(Now(), "HH:mm:ss                 ")#</cfoutput>
		</span>
	</cfdocumentitem>
	
	<cfdocumentsection >
		
		<div style="float:left;width:100%;">
			<h3 style="font-family:Arial;font-size:14px;font-weight:normal;"><cfoutput>#my_page.pagename#</cfoutput></h3>
		</div>
		
		<div class="clear">&nbsp;</div>
		
		<cfoutput>#my_page.pagecontent#</cfoutput>
		
	</cfdocumentsection>

</cfdocument>

</cfsilent>

<!--- NAGŁÓWEK DOKUMENTU PRZEKAZANY DO PRZGLĄDARKI --->
<cfheader name="Content-Disposition" value="inline; filename=#DateFormat(Now(), 'dd.mm.yyyy')#-#TimeFormat(Now(), 'HH:mm:ss')#.pdf" />

<!--- TREŚĆ DOKUMENTU --->
<cfcontent type="application/pdf" variable="#myPdf#" />
