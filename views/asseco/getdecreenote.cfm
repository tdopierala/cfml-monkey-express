<cfset filename = "#ExpandPath('files/invoicedecrees/')##replace(kartakorespondencji, '/', '_', 'ALL')#___#DateFormat(Now(), 'dd-mm-yyyy')#.pdf" />
<cfset savefilename = "#replace(kartakorespondencji, '/', '_', 'ALL')#___#DateFormat(Now(), 'dd-mm-yyyy')#.pdf" />

<cfif FileExists(filename)> <!--- Jeśli plik już istnieje to go usuwam i generuje nowy --->

	<cffile  
	    action = "delete" 
	    file = "#filename#">

<!---
	<cfheader name="Content-Disposition" value="inline; filename=#savefilename#" />
	<cfheader name="Expires" value="#Now()#" />
	<cfcontent type="application/pdf" file="#filename#" />
--->
</cfif>

<cfdocument format="pdf" fontEmbed="yes" pageType="A4" name="protocolpdf">

<style type="text/css" media="screen">
<!--
  @import url("stylesheets/pdfdocument.css");

-->
</style>

	<div class="wrapper pdf">
	
		<span class="h1"><cfoutput>#kartakorespondencji#</cfoutput></span>
		
		<span class="h2">Kontrahent</span>
		<span><cfoutput>#workflowsearch.nazwa2#</cfoutput></span><br/>
		<span>NIP: <cfoutput>#workflowsearch.nip#</cfoutput></span>
		
		<span class="h2">Faktura</span>
		<ul>
			<li><span>Numer faktury</span><cfoutput>#workflowsearch.numer_faktury_zewnetrzny#</cfoutput></li>
			<li><span>Data sprzedaży</span><cfoutput>#DateFormat(workflowsearch.data_sprzedazy, "dd-mm-yyyy")#</cfoutput></li>
			<li><span>Data wystawienia</span><cfoutput>#DateFormat(workflowsearch.data_wystawienia, "dd-mm-yyyy")#</cfoutput></li>
			<li><span>Data płatności</span><cfoutput>#DateFormat(workflowsearch.data_platnosci, "dd-mm-yyyy")#</cfoutput></li>
			<li><span>Data wpływu</span><cfoutput>#DateFormat(workflowsearch.data_wplywu, "dd-mm-yyyy")#</cfoutput></li>
			<li></li>
			<li><span>Kwota netto</span><cfoutput>#workflowsearch.netto#</cfoutput></li>
			<li><span>Kwota brutto</span><cfoutput>#workflowsearch.brutto#</cfoutput></li>
		</ul>
		
		<span class="h2">Dowód</span>
		<table cellspacing="0" border="0" cellspacing="0" class="decreetable">
			<thead>
				<tr>
					<th class="leftBorder topBorder rightBorder bottomBorder">MPK</th>
					<th class="topBorder rightBorder bottomBorder">PROJEKT</th>
					<th class="topBorder rightBorder bottomBorder">KWOTA NETTO</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="decree">
					<tr>
						<td class="leftBorder bottomBorder rightBorder">#MPK#</td>
						<td class="bottomBorder rightBorder">#PROJEKT#</td>
						<td class="bottomBorder rightBorder">#KWOTA# #WALUTA#</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
		
		<table class="decreenote" cellspacing="0" border="0" cellspacing="0">
			<thead>
				<tr>
					<th class="leftBorder topBorder rightBorder bottomBorder">KWOTA</th>
					<th class="topBorder rightBorder bottomBorder">WN</th>
					<th class="topBorder rightBorder bottomBorder">MA</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="decree">
					<tr>
						<td class="leftBorder bottomBorder rightBorder">#KWOTA#</td>
						<td class="bottomBorder rightBorder">#KONTO_WN#</td>
						<td class="bottomBorder rightBorder">#KONTO_MA#</td>
					</tr>
				</cfloop>
			</tbody>
		</table>

	</div>

</cfdocument>

<cfpdf 
    action = "write" 
    source = "protocolpdf" 
    destination="#filename#" />

<cfheader name="Content-Disposition" value="inline; filename=#savefilename#" />
<cfheader name="Expires" value="#Now()#" />
<cfcontent type="application/pdf" file="#filename#" />
