<!--- GENERUJE DOKUMENT PDF --->
<cfsilent>

<cfdocument format="PDF" name="myPdf">
	
	<style type="text/css"> 
		body, div, table { font-family: Arial; font-size: 12px; }
		.tabela { border: 1px solid ##000000; width: 100%; }
		.clear { clear: both; float: none; }
		.admin_table tr td { width:100%; font-family: Arial; font-size: 12px; }
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
			Zbiór: <cfoutput>#mycollection.collectionname#</cfoutput><br />
			Data utworzenia dokumentu: <cfoutput>#DateFormat(Now(), "dd.mm.yyyy")# #TimeFormat(Now(), "HH:mm:ss                 ")#</cfoutput>
		</span>
	</cfdocumentitem>
	
	<cfdocumentsection >
		<div style="float:left;width:100%;">
			<h3 style="font-family:Arial;font-size:14px;font-weight:normal;">Nieruchomość</h3>
			<p style="font-family:Arial;font-size:12px"><cfoutput>#myinstance.instancestreet#</cfoutput></p>
			<p style="font-family:Arial;font-size:12px"><cfoutput>#myinstance.instanceplace#, #myinstance.instancepostalcode#</cfoutput></p>
		</div>
		
		<div class="clear">&nbsp;</div>
		
		<h1 style="font-family:Arial;font-size:18px;font-weight:normal;text-align:center"><cfoutput>#mycollection.collectionname#</cfoutput></h1>
		
		<div style="width:640px;margin:20px auto 0;">
		<table class="tabela" cellpadding="0" cellspacing="0" style="border: 1px solid ##000000; width: 100%;">
			<tr>
				<th style="border: 1px solid ##000000;text-align:left;padding:8px;"><span style="font-family:Arial;font-size:11px;font-weight:normal">Miejscowość</span></th>
				<th style="border: 1px solid ##000000;text-align:left;padding:8px;"><span style="font-family:Arial;font-size:11px;font-weight:normal">Strona www</span></th>
				<th style="border: 1px solid ##000000;text-align:left;padding:8px;"><span style="font-family:Arial;font-size:11px;font-weight:normal">Telefon</span></th>
				<th style="border: 1px solid ##000000;text-align:left;padding:8px;"><span style="font-family:Arial;font-size:11px;font-weight:normal">Ulica</span></th>
				<th style="border: 1px solid ##000000;text-align:left;padding:8px;"><span style="font-family:Arial;font-size:11px;font-weight:normal">Nr domu</span></th>
				<th style="border: 1px solid ##000000;text-align:left;padding:8px;"><span style="font-family:Arial;font-size:11px;font-weight:normal">Uwagi</span></th>
			</tr>
			<cfoutput query="mycollections">
				<tr>
					<td style="border: 1px solid ##000000;padding:2px;"><span style="font-family:Arial;font-size:11px;font-weight:normal">#miejscowosc#</span></td>
					<td style="border: 1px solid ##000000;padding:2px;"><span style="font-family:Arial;font-size:11px;font-weight:normal">#strona_www#</span></td>
					<td style="border: 1px solid ##000000;padding:2px;"><span style="font-family:Arial;font-size:11px;font-weight:normal">#tel#</span></td>
					<td style="border: 1px solid ##000000;padding:2px;"><span style="font-family:Arial;font-size:11px;font-weight:normal">#ulica#</span></td>
					<td style="border: 1px solid ##000000;padding:2px;"><span style="font-family:Arial;font-size:11px;font-weight:normal">#nr_domu#</span></td>
					<td style="border: 1px solid ##000000;padding:2px;"><span style="font-family:Arial;font-size:11px;font-weight:normal">#uwagi#</span></td>
				</tr>
			</cfoutput>
		</table>

		</div>
	</cfdocumentsection>

</cfdocument>

</cfsilent>

<!--- NAGŁÓWEK DOKUMENTU PRZEKAZANY DO PRZGLĄDARKI --->
<cfheader name="Content-Disposition" value="inline; filename=#DateFormat(Now(), 'dd.mm.yyyy')#-#TimeFormat(Now(), 'HH:mm:ss')#.pdf" />

<!--- TREŚĆ DOKUMENTU --->
<cfcontent type="application/pdf" variable="#myPdf#" />
