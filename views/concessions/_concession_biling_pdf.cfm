<cfdocument format="pdf" fontEmbed="yes" pageType="A4" name="protocolpdf">

<style type="text/css" media="screen">
<!--
  @import url("stylesheets/concessionpdf.css");
-->
</style>
	<cfoutput>
		<div class="warpper pdf concession-biling">
			
			<p class="document-header">Załącznik nr 2 do Instrukcji nr 3/2012/DF</p>
			<br />
			<p class="document-header right">Poznań, dnia #DateFormat(document.created, "dd.mm.yyyy")# r.</p>
			<br />
			<h4>Naliczenie opłat (wymiar opłat) w roku #attributes[39].value# za korzystanie z zezwoleń na sprzedaż napojów alkoholowych.</h4>
		
		
			<table class="concession-biling-table">
				<caption align="top">Wartość sprzedaży napojów alkoholowych w #attributes[39].value-1# r.</caption>
				<thead>
					<tr>
						<th>Określenie zezwolenia</th>
						<th>Wartość sprzedaży *</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="label">Zezwolenie A<br /> (dla piwa)</td>
						<td class="value">#attributes[19].value#</td>
					</tr>
					<tr>
						<td class="label">Zezwolenie B<br /> (dla wina)</td>
						<td class="value">#attributes[20].value#</td>
					</tr>
					<tr>
						<td class="label">Zezwolenie C<br /> (dla wódki)</td>
						<td class="value">#attributes[21].value#</td>
					</tr>
				</tbody>
			</table>
		
			<p>*) W przypadku, kiedy sklep nie prowadził sprzedaży alkoholu w #attributes[39].value-1# r. należy wpisać liczbę „0” (słownie: zero).</p>
		
			<table class="concession-biling-table">
				<caption align="top">Wartość naliczonych opłat dla poszczególnych zezwoleń na sprzedaż napojów alkoholowych.</caption>
				<thead>
					<tr>
						<th rowspan="2">Określenie zezwolenia</th>
						<th colspan="2">Opłata dotyczy okresu</th>
						<th rowspan="2">Wartość opłaty</th>
					</tr>
					<tr>
						<th>od</th>
						<th>do</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="label">Zezwolenie A<br /> (dla piwa)</td>
						<td>#attributes[22].value#</td>
						<td>#attributes[23].value#</td>
						<td class="value">#attributes[28].value#</td>
					</tr>
					<tr>
						<td class="label">Zezwolenie B<br /> (dla wina)</td>
						<td>#attributes[24].value#</td>
						<td>#attributes[25].value#</td>
						<td class="value">#attributes[29].value#</td>
					</tr>
					<tr>
						<td class="label">Zezwolenie C<br /> (dla wódki)</td>
						<td>#attributes[26].value#</td>
						<td>#attributes[27].value#</td>
						<td class="value">#attributes[30].value#</td>
					</tr>
					<tr>
						<th colspan="3">Razem</th>
						<td>#attributes[40].value#</td>
					</tr>
				</tbody>
			</table>
			
			<p>Opłaty wnoszone są:</p>
			<cfloop query="attributeoptions">
				<cfif attributeoptions.id eq attributes[41].value>
					<p class="b">#attributeoptions.name#</p>
				</cfif>
			</cfloop>
			
			<br /><br />
			<p class="i">Niniejszym oświadczam, że wypełniony druk naliczenia opłat (wymiar opłat) w roku #attributes[39].value# za korzystanie z zezwoleń 
			na sprzedaż napojów alkoholowych przedkładam w związku z nieotrzymaniem właściwego dokumentu z Urzędu Gminy oraz, że 
			dane w nim zawarte są prawdziwe.</p>
		</div>
	</cfoutput>
</cfdocument>