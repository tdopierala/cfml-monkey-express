<cfoutput>

	<div class="wrapper">
	
		<h3>Lista sekwencji</h3>
		
		<table class="tables" id="sequencesTable">
			<thead>
				<tr>
					<th>Lp.</th>
					<th>Nazwa</th>
					<th>Login użytkownika</th>
					<th>Email służbowy</th>
				</tr>
			</thead>
			<tbody>
				<cfset index = 1>
				<cfloop query="sequences">
					<tr>
						<td>#index#</td>
						<td>#sequencename#</td>
						<td>#login#</td>
						<td>#companyemail#</td>
					</tr>
				<cfset index++>
				</cfloop>
			</tbody>
		</table>
	
	</div>

</cfoutput>