<cfprocessingdirective pageencoding="utf-8" />
	
<!--- GENERUJE DOKUMENT PDF --->
<cfsilent>
	
<cfdocument format="PDF" name="myPdf" fontembed="true" >
	
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
	</cfdocumentitem>
	
	<cfdocumentsection >
		
		
		
		<div style="font-family:'Arial';font-size:13px;text-align:justify;line-height:1.35em;width:100%;">
		
			<cfoutput query="notes">
				
				<h2 style="font-family:'Arial';font-size:18px;font-weight:normal;">#title#</h2>
				
				<div style="font-size:12px;margin-bottom:10px;">
					<table cellpadding="0" cellspacing="0" style="width:100%;">
						<thead></thead>
						<tbody>
							<tr>
								<td style="font-size:12px;border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;background-color:##eeeeee;">Numer sklepu</td>
								<td style="font-size:12px;border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;">#projekt#</td>
								<td style="font-size:12px;border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;background-color:##eeeeee;">Adres sklepu</td>
								<td style="font-size:12px;border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;">#adressklepu#</td>
								<td style="font-size:12px;border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;background-color:##eeeeee;">Nazwisko KOS</td>
								<td style="font-size:12px;border-left:1px solid ##000000;border-top:1px solid ##000000;border-right:1px solid ##000000;padding:4px;">#partner_givenname# #partner_sn#</td>
							</tr>
							<tr>
								<td style="font-size:12px;border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;background-color:##eeeeee;">Data powstania</td>
								<td style="font-size:12px;border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;">#DateFormat(notecreated, "dd/mm/yyyy")#</td>
								<td style="font-size:12px;border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;background-color:##eeeeee;">Tytuł dok</td>
								<td style="font-size:12px;border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;">#title#</td>
								<td style="font-size:12px;border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;background-color:##eeeeee;">Ocena wypadkowa</td>
								<td style="font-size:12px;border-left:1px solid ##000000;border-top:1px solid ##000000;border-right:1px solid ##000000;padding:4px;">#score#</td>
							</tr>
							<tr>
								<td style="font-size:12px;border-left:1px solid ##000000;border-top:1px solid ##000000;border-bottom:1px solid ##000000;padding:4px;background-color:##eeeeee;">Osoba kontrolująca</td>
								<td style="font-size:12px;border-left:1px solid ##000000;border-top:1px solid ##000000;border-bottom:1px solid ##000000;padding:4px;">#user_givenname# #user_sn#</td>
								<td style="font-size:12px;border-left:1px solid ##000000;border-top:1px solid ##000000;border-bottom:1px solid ##000000;padding:4px;background-color:##eeeeee;">Data kontroli</td>
								<td style="font-size:12px;border-left:1px solid ##000000;border-top:1px solid ##000000;border-bottom:1px solid ##000000;padding:4px;">#DateFormat(inspectiondate, "dd/mm/yyyy")#</td>
								<td colspan="4" style="border-left:1px solid ##000000;border-top:1px solid ##000000;">&nbsp;</td>
							</tr>
						</tbody>
					</table>
				</div>
				
				<div style="font-family:'Arial';font-size:12px;margin-bottom:-10px">#notebody#</div>
				
				<div style="line-height:0.3em;margin-bottom:20px;">
				
					<h3 style="font-family:'Arial';font-size:10px;font-weight:normal;">Notatka została utworzona <strong>#DateFormat(notecreated, "dd/mm/yyyy")#</strong> przez <strong>#user_givenname# #user_sn#</strong></h3>
					<h3 style="font-family:'Arial';font-size:10px;font-weight:normal;">Dotyczy sklepu <strong>#projekt#</strong> prowadzonego przez <strong>#nazwaajenta#</strong></h3>
					
				</div>
				
			</cfoutput>
		
		</div>
		
	</cfdocumentsection>

</cfdocument>

</cfsilent>

<!--- NAGŁÓWEK DOKUMENTU PRZEKAZANY DO PRZGLĄDARKI --->
<cfheader name="Content-Disposition" value="inline; filename=#DateFormat(Now(), 'dd.mm.yyyy')#-#TimeFormat(Now(), 'HH:mm:ss')#.pdf" />

<!--- TREŚĆ DOKUMENTU --->
<cfcontent type="application/pdf" variable="#myPdf#" />