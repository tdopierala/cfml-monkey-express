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

			<h3 style="font-family:Arial;font-size:16px;font-weight:normal;">Rejestr poczty wychodzącej</h3>

			<table style="font-family:Arial;font-size:10px;width:100%;" cellpadding="0" cellspacing="0">
				<thead>
					<tr>
						<th class="first c" style="font-weight:normal;width:20px;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">Data wysłania</th>
						<th class="c" style="font-weight:normal;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">Typ przesyłki</th>
						<th class="c" style="font-weight:normal;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">Kategoria</th>
						<th class="c" style="font-weight:normal;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">Ilość</th>
						<th class="c" style="font-weight:normal;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">Uwagi</th>
						<th class="c" style="font-weight:normal;background-color:#cbcac5;padding:3px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000;border-bottom:1px solid #000000;">Dodał(a)</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="my_list">
						<tr>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(data_wyslania)>
									<cfoutput>#DateFormat(data_wyslania, "dd.mm.yyyy")#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(typename)>
									<cfoutput>#typename#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(categoryname)>
									<cfoutput>#categoryname#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(ilosc)>
									<cfoutput>#ilosc#</cfoutput>
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
							<td style="text-align:center;border-left:1px solid #000000;border-right:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfoutput>#givenname# #sn#</cfoutput>
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
