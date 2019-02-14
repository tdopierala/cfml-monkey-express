<cfoutput>
	
	<tr>
		<td class="first">&nbsp;</td>
		<td colspan="3" class="admin_submenu_options">
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa grupy</th>
						<th>Liczba pól</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="mygroups">
						<tr>
							<td class="first">
								
								#linkTo(
									text="<span>pobierz pola grup</span>",
									controller="Place_reports",
									action="getGroupFields",
									key=groupid,
									class="expand_step_forms")#
								
							</td>
							<td>#groupname#</td>
							<td>#fieldcount#</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
		</td>
	</tr>
	
</cfoutput>