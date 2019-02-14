<!--- GENERUJE DOKUMENT PDF --->
<cfsilent>

<cfdocument 
	format="pdf" 
	name="myPdf"
	orientation="landscape"
	pageType="A4"
	>
	
	<style type="text/css"> 
	<!-- 
		td, th { border: 1px solid #000; }
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
		
		<span style="font-family:Arial;font-size:12px;float:right;text-align:right;">
			Data utworzenia dokumentu: <cfoutput>#DateFormat(Now(), "dd.mm.yyyy")# #TimeFormat(Now(), "HH:mm:ss")#</cfoutput>
		</span>
	</cfdocumentitem>
	
	<cfdocumentsection >
				
		<div class="correspondence_pdf" style="">
			
			<table style="font-family:Arial;font-size:10px;width:100%;" cellpadding="0"  cellspacing="0">
				<thead>
					<tr>
						<th rowspan="2" class="first c" style="font-weight:normal;width:20px;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">Lp.</th>
						<th rowspan="2" class="c" style="font-weight:normal;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">ADRESAT (imię i nazwisko lub nazwa)</th>
						<th rowspan="2" class="c" style="font-weight:normal;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">Dokładne miejsce doręczenia</th>
						<th colspan="2" class="c" style="font-weight:normal;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;">Kwota zadekl. wart.</th>
						<th colspan="2" class="c" style="font-weight:normal;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;">Masa</th>
						<th rowspan="2" class="c" style="font-weight:normal;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">Nr nadawczy</th>
						<th rowspan="2" class="c" style="font-weight: normal;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">Uwagi</th>
						<th colspan="2" class="c" style="font-weight: normal;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;">Opłata</th>
						<th colspan="2" class="c" style="font-weight: normal;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000;">Kwota pobrania</th>
						<th rowspan="2" class="c" style="font-weight: normal;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-right:1px solid #000000;border-bottom:1px solid #000000;">Data</th>
					</tr>
					<tr>
						<th style="font-weight:normal;width:20px;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">zł</th>
						<th style="font-weight: normal;width:20px;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">gr</th>
						<th style="font-weight: normal;width:20px;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">kg</th>
						<th style="font-weight: normal;width:20px;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">g</th>
						<th style="font-weight: normal;width:20px;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">zł</th>
						<th style="font-weight: normal;width:20px;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">gr</th>
						<th style="font-weight: normal;width:20px;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">zł</th>
						<th style="font-weight: normal;width:20px;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000;border-bottom:1px solid #000000;">gr</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="my_list">
						<tr>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(lp)>
									<cfoutput>#lp#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(adresat)>
									<cfoutput>#adresat#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(miejsce_doreczenia)>
									<cfoutput>#miejsce_doreczenia#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(kwota_zl)>
									<cfoutput>#kwota_zl#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(kwota_gr)>
									<cfoutput>#kwota_gr#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(masa_kg)>
									<cfoutput>#masa_kg#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(masa_g)>
									<cfoutput>#masa_g#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(nr_nadawczy)>
									<cfoutput>#nr_nadawczy#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(uwagi)>
									<cfoutput>#uwagi#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(oplata_zl)>
									<cfoutput>#oplata_zl#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(oplata_gr)>
									<cfoutput>#oplata_gr#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(pobranie_zl)>
									<cfoutput>#pobranie_zl#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;border-right:1px solid #000000;">
								<cfif Len(pobranie_gr)>
									<cfoutput>#pobranie_gr#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-bottom:1px solid #000000;padding:6px 0;border-right:1px solid #000000;">
								<cfif Len(correspondencecreated)>
									<cfoutput>#DateFormat(correspondencecreated, 'yyyy/mm/dd')#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
						</tr>
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
