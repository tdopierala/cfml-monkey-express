<div class="workflow_tooltip">
	<div class="uiContent">
		
		<table class="uiTable">
			<thead>
				<tr>
					<th class="leftBorder topBorder rightBorder bottomBorder">Atrybut</th>
					<th class="topBorder rightBorder bottomBorder">Wartość</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="attributes">
					<tr>
						<td class="leftBorder rightBorder bottomBorder">#attributelabel#</td>
						<td class="rightBorder bottomBorder">#userattributevaluetext#</td>
					</tr>
				</cfoutput>
			</tbody>
		</table>
		
	</div>
</div>