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
			Raport: <cfoutput>#myreport.reportname#</cfoutput><br />
			Data utworzenia dokumentu: <cfoutput>#DateFormat(Now(), "dd.mm.yyyy")# #TimeFormat(Now(), "HH:mm:ss                 ")#</cfoutput>
		</span>
	</cfdocumentitem>
	
	<cfdocumentsection >
		<div style="float:left;width:100%;">
			<h3 style="font-family:Arial;font-size:14px;font-weight:normal;">Nieruchomość</h3>
			<p style="font-family:Arial;font-size:12px"><cfoutput>#myinstance.instancestreet#</cfoutput></p>
			<p style="font-family:Arial;font-size:12px"><cfoutput>#myinstance.instanceplace#, #myinstance.instancepostalcode#</cfoutput></p>
		</div>
		
		<div style="float:left;width:100%;margin-top:50px;">
			<h3 style="font-family:Arial;font-size:14px;font-weight:normal;">Partner</h3>
			<p style="font-family:Arial;font-size:12px"><cfoutput>#myuser.givenname# #myuser.sn#</cfoutput></p>
			<p style="font-family:Arial;font-size:12px"><cfoutput>#myuser.mail#</cfoutput></p>
			<!---<p style="font-family:Arial;font-size:12px"><cfoutput>#myuser.mob#</cfoutput></p>--->
		</div>
		
		<div class="clear">&nbsp;</div>
		
		<h1 style="font-family:Arial;font-size:18px;font-weight:normal;text-align:center;margin-top:-20px;"><cfoutput>#myreport.reportname#</cfoutput></h1>
		
		<div style="width:100%;">
			
		<table class="admin_table" style="width:100%;" cellpadding="0" cellspacing="0">
			<tbody>
				<cfset index = 1 />
				<cfloop collection="#reportfields#" item="i" >
					<tr>
						<td style="background-color:#000;color:#fff;padding:8px 4px;font-family:Arial;text-align:center;font-size:12px;width:100%;" colspan="2">
							<cfoutput>#i#</cfoutput>
						</td>
					</tr>
					
					<cfset tmp = reportfields[i] />
					
					<cfloop query="tmp">
						<tr>
							<td style="<cfif index % 2>background-color:#ededed;</cfif>padding:8px 4px;font-family:Arial;font-size:12px;width:30%;"><cfoutput>#fieldname#</cfoutput></td>
							<td style="<cfif index % 2>background-color:#ededed;</cfif>padding:8px 4px;font-family:Arial;font-size:12px;width:65%;"><cfoutput>#fieldvalue#</cfoutput></td>
						</tr>
						<cfset index++ />
					</cfloop>
					
					<cfset index++ />
				</cfloop>
			</tbody>
		</table>
		
		</div>
		
	</cfdocumentsection>

</cfdocument>

</cfsilent>

<!--- NAGŁÓWEK DOKUMENTU PRZEKAZANY DO PRZGLĄDARKI --->
<cfheader name="Content-Disposition" value="inline; filename=#DateFormat(Now(), 'dd.mm.yyyy')#-#TimeFormat(Now(), 'HH:mm:ss')#.pdf" />

<!--- TREŚĆ DOKUMENTU --->
<cfcontent type="application/pdf" variable="#myPdf#" />