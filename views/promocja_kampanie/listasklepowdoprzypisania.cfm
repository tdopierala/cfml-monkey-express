
<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="refreshForm">
	
<cfset perpage = 30 />
<cfparam name="url.start" default="1">
<cfif not isNumeric(url.start) or url.start lt 1 or url.start gt listaSklepowDoPrzypisania.recordCount or round(url.start) neq url.start>
	<cfset url.start = 1>
</cfif>

<h5>Sklepy do przypisania</h5>
<cfform name="sklepyKampaniiForm" action="index.cfm?controller=promocja_kampanie&action=przypisz-sklepy-do-kampanii&idKampanii=#URL.idKampanii#">
<table class="uiTable">
	<thead>
		<tr>
			<th class="leftBorder topBorder rightBorder bottomBorder"><input onClick="initToggler()" type="checkbox" name="wszystkieKodySklepow" value="wszystkie" id="wszystkieKodySklepow" /></th>
			<th class="topBorder rightBorder bottomBorder">Numer</th>
			<th class="topBorder rightBorder bottomBorder">Miasto</th>
			<th class="topBorder rightBorder bottomBorder">KOS</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="listaSklepowDoPrzypisania" startrow="#url.start#" maxrows="#perpage#">
			<tr>
				<td class="leftBorder bottomBorder rightBorder"><input type="checkbox" name="kodSklepu" value="#projekt#" /></td>
				<td class="bottomBorder rightBorder l">#projekt#</td>
				<td class="bottomBorder rightBorder l">#miasto#</td>
				<td class="bottomBorder rightBorder l"></td>
			</tr>
		</cfoutput>
	</tbody>
	<tfoot>
		<tr>
			<th colspan="4" class="leftBorder bottomBorder rightBorder l">
				<cfinput type="submit" class="btn" name="sklepyKampaniiForm" value="Przypisz" />
			</th>
		</tr>
	</tfoot>
</table>
</cfform>

[
<cfif url.start gt 1>
	<cfset link = "index.cfm?controller=promocja_kampanie&action=lista-sklepow-do-przypisania&idKampanii=#URL.idKampanii#&start=" & (url.start - perpage)>
	<cfoutput><a href="javascript:ColdFusion.navigate('#link#', 'paginacjaListySklepow')">Poprzednia strona</a></cfoutput>
<cfelse>
	Poprzednia strona
</cfif>
/
<cfif (url.start + perpage - 1) lt listaSklepowDoPrzypisania.recordCount>
	<cfset link = "index.cfm?controller=promocja_kampanie&action=lista-sklepow-do-przypisania&idKampanii=#URL.idKampanii#&start=" & (url.start + perpage)>
	<cfoutput><a href="javascript:ColdFusion.navigate('#link#', 'paginacjaListySklepow')">Następna strona</a></cfoutput>
<cfelse>
	Następna strona
</cfif>
]

</cfdiv>
