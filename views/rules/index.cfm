<cfoutput>
	<div class="wrapper">
	
		<h3>Reguły dostępu</h3>
	
		<div class="wrapper">
			<table class="tables" id="rulesTable">
				<thead>
					<tr>
						<th>Lp.</th>
						<th>Nazwa reguły</th>
						<th>Kontroler</th>
						<th>Akcja</th>
					</tr>
				</thead>
				<tbody>
					<cfset index = 1>
					<cfloop query="rules">
						<tr>
							<td>#index++#</td>
							<td>#name#</td>
							<td>#controller#</td>
							<td>#action#</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
	</div>
</cfoutput>