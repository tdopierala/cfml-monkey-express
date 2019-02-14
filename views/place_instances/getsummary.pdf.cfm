<!--- GENERUJE DOKUMENT PDF --->
<cfsilent>
	
<cfdocument format="PDF" name="myPdf">
	
	<style type="text/css"> 
	<!-- 
		.clear { clear: both; float: none; }
		.admin_table tr td { width:100%; font-family: Arial; font-size: 12px; }
		.c { text-align: center; }
		.bottomBorder { bottom-border: 1px solid ##a1a1a1; }
		table thead tr th { font-family: Arial; font-size: 12px; text-transform: capitalize; }
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
			Data utworzenia dokumentu: <cfoutput>#DateFormat(Now(), "dd.mm.yyyy")# #TimeFormat(Now(), "HH:mm:ss")#</cfoutput>
		</span>
	</cfdocumentitem>
	
	<cfdocumentsection >
		
		<div style="float:left;width:100%;">
			<h3 style="font-family:Arial;font-size:14px;font-weight:normal;">Nieruchomość</h3>
			<p style="font-family:Arial;font-size:12px"><cfoutput>#myinstance.street#</cfoutput></p>
			<p style="font-family:Arial;font-size:12px"><cfoutput>#myinstance.postalcode#, #myinstance.city#</cfoutput></p>
		</div>
		
		<div style="float:left;width:100%;margin-top:50px;">
			<h3 style="font-family:Arial;font-size:14px;font-weight:normal;">Partner</h3>
			<p style="font-family:Arial;font-size:12px"><cfoutput>#myuser.givenname# #myuser.sn#</cfoutput></p>
			<p style="font-family:Arial;font-size:12px"><cfoutput>#myuser.mail#</cfoutput></p>
			<!---<p style="font-family:Arial;font-size:12px"><cfoutput>#myuser.mob#</cfoutput></p>--->
		</div>
		
		<div class="clear">&nbsp;</div>
		
		<h1 style="font-family:Arial;font-size:18px;font-weight:normal;text-align:center">Podsumowanie obiegu nieruchomości</h1>
		
		<div style="width:100%;">
			
		<table class="admin_table" style="width:100%;" cellpadding="0" cellspacing="0">
			<thead>
				<tr>
					<td style="background-color:#000;color:#fff;padding:8px 4px;font-family:Arial;text-align:center;font-size:12px;width:100%;">Data utworzenia</td>
					<td style="background-color:#000;color:#fff;padding:8px 4px;font-family:Arial;text-align:center;font-size:12px;width:100%;">Utworzono przez</td>
					<td style="background-color:#000;color:#fff;padding:8px 4px;font-family:Arial;text-align:center;font-size:12px;width:100%;">Nazwa etapu</td>
					<td style="background-color:#000;color:#fff;padding:8px 4px;font-family:Arial;text-align:center;font-size:12px;width:100%;">Data zamknięcia</td>
					<td style="background-color:#000;color:#fff;padding:8px 4px;font-family:Arial;text-align:center;font-size:12px;width:100%;">Zamknięto przez</td>
					<td style="background-color:#000;color:#fff;padding:8px 4px;font-family:Arial;text-align:center;font-size:12px;width:100%;">Status</td>
				</tr>
			</thead>
			<tbody>
				<cfset index = 1 />
				
				<cfloop query="placesteps">
					<cfset style = "" />
					<cfif index % 2>
						<cfset style = "background-color:##ededed;" />
					</cfif>
					<cfset style &= "padding:8px 4px;font-family:Arial;font-size:12px;" />
					<tr>
						<td style="<cfoutput>#style#</cfoutput>" class="c">
							<cfoutput>#imageTag(source="clock.png",alt="Data i godzina")#&nbsp;#DateFormat(start, "yyyy-mm-dd")#&nbsp;#TimeFormat(start, "HH:mm")#</cfoutput>
						</td>
						<td style="<cfoutput>#style#</cfoutput>">
							<cfoutput>#givenname# #sn#</cfoutput>
						</td>
						<td style="<cfoutput>#style#</cfoutput>">
							<cfoutput>#stepname#</cfoutput>
						</td>
						<td style="<cfoutput>#style#</cfoutput>">
							<cfoutput>#imageTag(source="clock.png",alt="Data i godzina")#&nbsp;#DateFormat(stop, "yyyy-mm-dd")#&nbsp;#TimeFormat(stop, "HH:mm")#</cfoutput>
						</td>
						<td style="<cfoutput>#style#</cfoutput>">
							<cfoutput>#givenname2# #sn2#</cfoutput>
						</td>
						<td style="<cfoutput>#style#</cfoutput>">
							<cfoutput>#statusname#</cfoutput>
						</td>
					</tr>
					<tr>
						<td style="<cfoutput>#style#</cfoutput> bottomBorder">
							Komentarz
						</td>
						<td colspan="5" style="<cfoutput>#style#</cfoutput>" class="bottomBorder">
							<cfoutput>#workflownote#</cfoutput>
						</td>
					</tr>	
					<cfset index++ />	
				</cfloop>
			</tbody>
		</table>
		
		<h1 style="font-family:Arial;font-size:18px;font-weight:normal;text-align:center;margin-top:30px;">Komentarze do formularzy</h1>
		
		<table class="admin_table" style="width:100%;" cellpadding="0" cellspacing="0">
			<thead>
				<tr>
					<td style="background-color:#000;color:#fff;padding:8px 4px;font-family:Arial;text-align:center;font-size:12px;width:15%;">Formularz</td>
					<td style="background-color:#000;color:#fff;padding:8px 4px;font-family:Arial;text-align:center;font-size:12px;width:15%;">Data dodania</td>
					<td style="background-color:#000;color:#fff;padding:8px 4px;font-family:Arial;text-align:center;font-size:12px;width:15%;">Użytkownik</td>
					<td style="background-color:#000;color:#fff;padding:8px 4px;font-family:Arial;text-align:center;font-size:12px;width:55%;">Treść</td>
				</tr>
			</thead>
			<tbody>
				<cfset index = 1 />
				<cfoutput query="notatkiFormularzy">
					<cfset style = "" />
					<cfif index % 2>
						<cfset style = "background-color:##ededed;" />
					</cfif>
					<cfset style &= "padding:8px 4px;font-family:Arial;font-size:12px;" />
					
					<tr>
						<td style="#style#">#formname#</td>
						<td style="#style#">#DateFormat(created, "yyyy/mm/dd")#</td>
						<td style="#style#">#givenname# #sn#</td>
						<td style="#style#">#formnote#</td>
					</tr>
					<cfset index++ />
				</cfoutput>
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