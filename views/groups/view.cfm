<cfoutput>

	<div class="wrapper">
	
		<h3>Lista użytkowników w grupie</h3>
		
		<table class="tables" id="usersInGroupTable">
			<thead>
				<tr>
					<th>Login</th>
					<th>Akcje</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="users">
					<tr>
						<td>#login#</td>
						<td>
							#linkTo(
								text="zobacz profil",
								controller="users",
								action="view",
								key=userid)#
						</td>
					</tr>
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