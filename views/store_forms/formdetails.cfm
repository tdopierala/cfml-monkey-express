<cfprocessingdirective pageencoding="utf-8" />
	
<table class="uiTable aosTable storeObjectDetailsTable">
	<thead>
		<tr>
			<th class="leftBorder topBorder rightBorder bottomBorder">Atrybut</th>
			<th class="topBorder rightBorder bottomBorder">Wartość</th>
		</tr>
	</thead>	
	<tbody>
		<cfloop collection="#szczegoly#" item="element" >
			<cfset el = element />
			<tr class="obj_attr_<cfoutput>#el#</cfoutput>">
				<td colspan="2" class="leftBorder bottomBorder rightBorder l u yellowBg">
					<cfoutput>#szczegoly["#element#"]["FORM_NAME"]#</cfoutput>
					<a href="javascript:void(0)" onclick="usunFormularzZeSklepu(<cfoutput>#el#</cfoutput>)" title="Usuń formularz ze sklepu" class="icon-remove"><span>Usuń formularz ze sklepu</span></a>
					<a href="javascript:void(0)" onclick="initCfWindow('index.cfm?controller=store_forms&action=edit-instance&instanceid=<cfoutput>#el#</cfoutput>', <cfoutput>#el#</cfoutput>, 400, 633)" title="Edytuj formularz" class="icon-edit"><span>Edytuj formularz</span></a>
				</td>
			</tr>
			<cfset atrybuty = szczegoly["#element#"]["ATTRIBUTES"] />
			<cfloop query="atrybuty">
				<tr class="obj_attr_<cfoutput>#el#</cfoutput>">
					<td class="leftBorder bottomBorder rightBorder l"><cfoutput>#attribute_name#</cfoutput></td>
					<td class="bottomBorder rightBorder l"><cfoutput>#value_text#</cfoutput></td>
				</tr>
			</cfloop>
		</cfloop>
	</tbody>
</table>