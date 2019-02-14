<cfoutput>

	<div class="wrapper">
	
		<h3>Statusy obiegu dokumentów</h3>
		
		<table class="tables" id="statusesTable">
			<thead>
				<tr>
					<th>Lp.</th>
					<th>Nazwa statusu</th>
				</tr>
			</thead>
			<tbody>
				<cfset index = 1>
				<cfloop query="statuses">
					<tr>
						<td>#index#</td>
						<td>#statusname#</td>
					</tr>
				<cfset index++>
				</cfloop>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="2"></td>
				</tr>
			</tfoot>
		</table>
	
	</div>

</cfoutput>