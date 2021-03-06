<!---  getprotocolpdf.pdf.cfm.cfc --->
<!--- @@Created By: TD Monkey Group 2012 --->
<!---
Widok generujący PDF protokołu rozbieżności.

Wydaje mi się, że jest tutaj zaimplementowany ciekawy pomysł. Sposób może nie jest elegancki przez dużego IFa, ale efekt jest prawidłowy.

Skrypt sprawdza, czy isnieje na dysku wygenerowany plik PDF z protokołem. Jeśli taki plik jest to jest on pobierany i zwracany do przeglądarki. Jeśli pliku nie ma to jest on tworzony, zapisywany na dysku i wyświetlany w przeglądarce.

TODO
Dorobić AJAXowe generowanie widoku. Wtedy zaoszczędzimy czas na generowaniu odpowiedniego zapytania.
	
--->

<cfset filename = "#ExpandPath('files/protocols/')#protocol_#protocol.id#_#DateFormat(protocol.protocolcreated, 'dd-mm-yyyy')#.pdf" />
<cfset savefilename = "protocol_#protocol.id#_#DateFormat(protocol.protocolcreated, 'dd-mm-yyyy')#.pdf" />

<cfif FileExists(filename)>

	<cfheader name="Content-Disposition" value="inline; filename=#savefilename#" />
	<cfheader name="Expires" value="#Now()#" />
	<cfcontent type="application/pdf" file="#filename#" />
	
<cfelse>

	<cfdocument format="pdf" fontEmbed="yes" pageType="A4" name="protocolpdf">
	
	<style type="text/css" media="screen">
	<!--
	  @import url("stylesheets/protocolpdf.css");
	
	-->
	</style>
	
		<div class="wrapper pdf">
		
		<span class="h1">Protokół rozbieżności nr <span><cfoutput>#protocol.id#</cfoutput>/</span></span>
		
		<span class="h3">Dane sklepu i nr Ajenta</span>
		<div class="protocolheader">
			<ul>
				<cfoutput>
					<cfloop query="protocolheader">
						<cfif attributeid eq 108 or attributeid eq 109>
							<li><span>#attributename#</span> #protocolattributevalue#</li>
						</cfif>
					</cfloop>
				</cfoutput>
			</ul>
		</div>
		
		<span class="h3">Dane dostawcy i nr WZ</span>
		<div class="protocolheader">
			<ul>
				<cfoutput>
					<cfloop query="protocolheader">
						<cfif (attributeid NEQ 108) and (attributeid NEQ 109) and (attributeid NEQ 140)>
							<li><span>#attributename#</span> #protocolattributevalue#</li>
						</cfif>
					</cfloop>
				</cfoutput>
			</ul>
		</div>
		
		<span class="h3">Protokół</span>
		<div class="protocolcontent">
			<table class="pdftables" cellspacing="0">
				<thead>
					<tr>
						<th class="bottomBorder rightBorder leftBorder topBorder">Lp.</th>
						<th class="bottomBorder rightBorder topBorder">Indeks</th>
						<th class="bottomBorder rightBorder topBorder">Nazwa towaru</th>
						<th class="bottomBorder rightBorder topBorder">Powód rozbieżności</th>
						<th class="bottomBorder rightBorder topBorder">Termin przydatności</th>
						<th class="bottomBorder rightBorder topBorder">Ilość</th>
						<th class="bottomBorder rightBorder topBorder">Zwrot towaru</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput>
						<cfloop query="protocolcontent">
							<tr>
								<td class="c leftBorder rightBorder bottomBorder">#lp#</td>
								<td class="c rightBorder bottomBorder">#indeks#</td>
								<td class="rightBorder bottomBorder">#nazwatowaru#</td>
								<td class="rightBorder bottomBorder">#powodrozbieznosci#</td>
								<td class="c rightBorder bottomBorder">#terminprzydatnosci#</td>
								<td class="c rightBorder bottomBorder">#ilosc#</td>
								<td class="c rightBorder bottomBorder">#zwrottowaru#</td>
							</tr>
						</cfloop>
					</cfoutput>
				</tbody>
			</table>
		</div>
		
		<span class="h3">Uwagi:</span>
		<div class="protocolnote">
			 <cfloop query="protocolheader">
				<cfif (attributeid EQ 140)>
					<cfoutput>#protocolattributevalue#</cfoutput>
				</cfif>
			</cfloop>
		</div>
		
		<div class="franchisor">
		PODPIS I PIECZĄTKA AJENTA
		</div>
		
		<div class="driver">
		PODPIS I PIECZĄTKA KIEROWCY
		</div>
		
		<div class="clear"></div>
		
		<div class="credits">
		Data wygenerowania dokumentu: <cfoutput>#DateFormat(Now(), "dd-mm-yyyy")# #TimeFormat(Now(), "HH:mm:ss")#</cfoutput></div>
		</div> <!--- koniec wrapper dla ca?ego widoku --->
	
	</cfdocument>
	
	<cfpdf 
	    action = "write" 
	    source = "protocolpdf" 
	    destination="#filename#" />
	
	<cfheader name="Content-Disposition" value="inline; filename=#savefilename#" />
	<cfheader name="Expires" value="#Now()#" />
	<cfcontent type="application/pdf" file="#filename#" />

</cfif>