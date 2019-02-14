<cfoutput >
	<div class="wrapper">
	
		<h3>Lista departamentów</h3>
	
		<table class="tables" id="departmentTable">
			<thead>
				<tr>
					<th>Nazwa departamentu</th>
					<th>Ilość pracowników</th>
					<th>Akcje</th>
				</tr>
			</thead>
			<tbody>
				<cfloop collection="#departments#" item="i" >
					<tr>
						<td>
							#linkTo(
								text="#departments[i].department_name#",
								controller="Departments",
								key=departments[i].departmentid,
								action="view")#
						</td>
						<td>
							 #departments[i].users_count#
						</td>
						<td>
							#linkTo(
								text="zobacz",
								controller="Departments",
								action="view",
								key=departments[i].departmentid,
								title="Zobacz departament.")#
						</td>
					</tr>
				</cfloop>	
			</tbody>
			<tfoot>
				<tr>
					<td colspan="2">
						#linkTo(
							text="+dodaj",
							controller="Departments",
							action="add",
							title="Dodaj nowy departament.")#
					</td>
				</tr>
			</tfoot>
		</table>
	
	</div>	
</cfoutput>