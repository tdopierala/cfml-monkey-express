<cfoutput >
	<div class="wrapper">
	
		<h3>Departament <span>#department.department_name#</span></h3>
		
		<table class="tables" id="departmentList">
			<thead>
				<tr>
					<th>Login</th>
					<th>Akcje</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="department_users">
					<tr>
						<td>#login#</td>
						<td>
							#linkTo(
								text="zobacz",
								controller="Users",
								action="view",
								key=id,
								title="Zobacz profil użytkownika.")#
							
							#linkTo(
								text="edytuj",
								controller="Users",
								action="edit",
								key=id,
								title="Edytuj profil użytkownika.")#
							
							#linkTo(
								text="edytuj atrybuty",
								controller="UserAttributes",
								action="edit",
								key=id,
								title="Edytuj atrybuty użytkownika.")#
							
							#linkTo(
								text="usuń",
								controller="Users",
								action="delete",
								key=id,
								title="Usuń profil użytkownika.")#
				
						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	
	</div>
</cfoutput>