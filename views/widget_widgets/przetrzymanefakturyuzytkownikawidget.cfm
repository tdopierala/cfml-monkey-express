<cfprocessingdirective pageencoding="utf-8" />

<table class="uiTable">
	<thead>
		<tr>
			<th class="leftBorder topBorder rightBorder bottomBorder">Numer faktury</th>
			<th class="topBorder rightBorder bottomBorder">Imię i nazwisko</th>
			<th class="topBorder rightBorder bottomBorder">Etap</th>
			<th class="topBorder rightBorder bottomBorder">Ilość dni</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="faktury">
			<tr>
				<td class="leftBorder rightBorder bottomBorder">
					<a href="javascript:ColdFusion.navigate('#URLFor(controller="Workflows",action="edit",key=workflowid)#', 'user_profile_cfdiv');" title="Edytuj dokument">#documentname#</a>
				</td>
				<td class="rightBorder bottomBorder">#givenname# #sn#</td>
				<td class="rightBorder bottomBorder">#workflowstepstatusname#</td>
				<td class="rightBorder bottomBorder">#dni#</td>
			</tr>
		</cfoutput>
	</tbody>
</table>