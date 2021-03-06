<cfdocument format="pdf" fontEmbed="yes" pageType="A4" name="protocolpdf">

<style type="text/css" media="screen">
<!--
  @import url("stylesheets/concessionpdf.css");
-->
</style>

	<cfoutput>
		<div class="warpper pdf concession-proposal">
			
			<p class="document-header">Załącznik nr 1 do Instrukcji nr 3/2012/DF</p>
			<br />
			<h4><center>WNIOSEK O REFUNDACJĘ OPŁAT</center></h4>
			<br /><br />
			<p>Na podstawie Instrukcji nr 3/2012/DF w sprawie zasad refundacji kosztów opłat za korzystanie przez Partnera Prowadzącego Sklep z 
			zezwoleń na sprzedaż napojów alkoholowych w roku #attributes[38].value#, wnoszę o przyznanie refundacji.</p>
			<br />
			<p><strong>Data rozpoczęcia sprzedaży napojów alkoholowych <!--- w roku 2012 --->- </strong> #DateFormat(attributes[36].value,"dd.mm.yyyy")# r.</p>
			<br />
			<p>
				Do wniosku:
				<ul>
					<li>
						<cfif attributes[16].value eq 2>
							<cfset class = "unnecessary" />
						<cfelse>
							<cfset class = "default" />
						</cfif>
						
						<span class="#class#">dołączam oryginał ważnego zezwolenia na sprzedaż napojów alkoholowych (kopię zezwolenia poświadczoną notarialnie pozostawiam u siebie);</span>
						<br /><br />
						<strong>lub</strong><br /><br />
						
						<cfif attributes[16].value eq 1>
							<cfset class = "unnecessary" />
						<cfelse>
							<cfset class = "default" />
						</cfif>
						
						<span class="#class#">informuję, że oryginał ważnego zezwolenia na sprzedaż napojów alkoholowych w roku #attributes[38].value# Przekazałem wcześniej do Monkey Group (kopię zezwolenia poświadczoną notarialnie mam pozostawioną u siebie).*</span>
						<br /><br />
						oraz<br /><br />
					</li>
					<li>
						<cfif attributes[17].value eq 2>
							<cfset class = "unnecessary" />
						<cfelse>
							<cfset class = "default" />
						</cfif>
						
						<span class="#class#">dołączam pisemne oświadczenie o rezygnacji z działalności dotyczącej handlu napojami alkoholowymi w sklepie Monkey Express w chwili wygaśnięcia lub rozwiązania Umowy o Współdziałaniu i Współpracy ze Spółką Monkey Group;</span>
						<br /><br />
						<strong>lub</strong><br /><br />
						
						<cfif attributes[17].value eq 1>
							<cfset class = "unnecessary" />
						<cfelse>
							<cfset class = "default" />
						</cfif>
						
						<span class="#class#">informuję, że oświadczenie o rezygnacji z działalności dotyczącej handlu napojami alkoholowymi w sklepie Monkey Express w chwili wygaśnięcia Umowy o Współdziałaniu i Współpracy z Spółką Monkey Group przekazałem/am wcześniej do Monkey Group*</span>
						<br /><br />		
						oraz<br /><br />
					</li>
					<li>
						<cfif attributes[18].value eq 2>
							<cfset class = "unnecessary" />
						<cfelse>
							<cfset class = "default" />
						</cfif>
						
						<span class="#class#">dołączam kopię dokumentu wystawionego przez Urząd Gminy potwierdzającego naliczenie opłaty (wymiar opłaty) za korzystanie z zezwoleń na sprzedaż napojów alkoholowych;</span>
						<br /><br />
						<strong>lub</strong><br /><br />
						
						<cfif attributes[18].value eq 1>
							<cfset class = "unnecessary" />
						<cfelse>
							<cfset class = "default" />
						</cfif>
						
						<span class="#class#">w związku z brakiem dokumentu z Urzędu Gminy, dołączam wypełniony przeze mnie druk (załącznik nr 2 do w/w Instrukcji) wskazujący naliczanie opłat (wymiar opłat) za korzystanie z zezwoleń na sprzedaż napojów alkoholowych.*</span>
						<br />
					</li>
				</ul>
				<span>* niewłaściwe skreślić</span><br /><br />
			</p>
			
			<table class="concession-proposal-table" border="1">
				<thead>
					<tr>
						<th colspan="2">Wnioskodawca</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>Sklep numer</td>
						<td>#attributes[10].value#</td>
					</tr>
					<tr>
						<td>Imie i nazwisko</td>
						<td>#attributes[11].value#</td>
					</tr>
					<tr>
						<td>Nazwa przedsiebiorstwa PPS</td>
						<td>#attributes[12].value#</td>
					</tr>
					<tr>
						<td>NIP przedsiebiorstwa PPS</td>
						<td>#attributes[13].value#</td>
					</tr>
					<tr>
						<td>Adres przedsiebiorstwa PPS</td>
						<td>#attributes[14].value#</td>
					</tr>
					<tr>
						<td>Adres do korespondencji<br /> (jeśli inny niż powyższy)</td>
						<td>#attributes[15].value#</td>
					</tr>
				</tbody>
			</table>
		</div>
	</cfoutput>
	
</cfdocument>