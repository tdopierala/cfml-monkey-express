<cfoutput>

	<div class="wrapper">
	
		<h3>Grupy</h3>
		
		<table id="groupsTable" class="tables">
		
			<thead>
				<tr>
					<th>Nazwa grupy</th>
					<th>Opis grupy</th>
					<th>Akcje</th>
				</tr>
			</thead>
			
			<tbody>
				<cfloop query="groups">
					<tr>
						<td>
							#linkTo(
							text=groupname,
							controller="Groups",
							action="view",
							key=id)#
						</td>
						<td>#groupdescription#</td>
						<td>
							#linkTo(
								controller="Groups",
								action="editRules",
								key=id,
								text="edytuj uprawnienia",
								title="Edytuj uprawnienia grupy")#
								
							#linkTo(
								controller="Groups",
								action="delete",
								key=id,
								text="usuń",
								title="Usuń grupę")#
						</td>
					</tr>
				</cfloop>
			</tbody>
			
			<tfoot>
				<tr>
					<td colspan="3"></td>
				</tr>
			</tfoot>
		
		</table>
	
	</div>

</cfoutput>