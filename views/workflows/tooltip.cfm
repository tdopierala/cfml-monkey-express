<cfoutput>
	<div class="workflow_tooltip">
		
		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>MPK</th>
					<th>Projekt</th>
					<th>Kwota</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="description">
					<tr>
						<td class="first">&nbsp;</td>
						<td>#mpk#</td>
						<td>#projekt#</td>
						<td>#workflowstepdescription#</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
		
	</div>
</cfoutput>