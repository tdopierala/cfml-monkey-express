<!--- GENERUJE DOKUMENT PDF --->
<cfsilent>

<cfdocument 
	format="pdf" 
	name="myPdf"
	orientation="portrait" 
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
						<th style="font-weight:normal;width:20px;background-color:#cbcac5;padding:6px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">Rodzaj listu</th>
						<th style="font-weight:normal;background-color:#cbcac5;padding:6px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;">Data nadania</th>
						<th style="font-weight:normal;background-color:#cbcac5;padding:6px;text-align:center;border-top:1px solid #000000;border-left:1px solid #000000;border-bottom:1px solid #000000;border-right:1px solid #000000;">Liczba listów</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="my_list">
						<tr>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(typename)>
									<cfoutput>#typename#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;padding:6px 0;">
								<cfif Len(data_nadania)>
									<cfoutput>#DateFormat(data_nadania, "dd-mm-yyyy")#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="text-align:center;border-left:1px solid #000000;border-bottom:1px solid #000000;border-right:1px solid #000000;padding:6px 0;">
								<cfif Len(letters_count)>
									<cfoutput>#letters_count#</cfoutput>
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
