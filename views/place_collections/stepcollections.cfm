<cfoutput>
	
	<tr>
		<td class="first">&nbsp;</td>
		<td colspan="2" class="admin_submenu_options">
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa zbioru</th>
						<th>Data utworzenia</th>
						<th>Użytkownik</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="mycollections">
						<tr>
							<td>
								#linkTo(
									text="<span>pobierz pola zbioru</span>",
									controller="Place_collections",
									action="collectionFields",
									key=id,
									class="expand_step_forms")#
							</td>
							<td>#collectionname#</td>
							<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(collectioncreated, "yyyy-mm-dd")# #TimeFormat(collectioncreated, "HH:mm")#</td>
							<td>#givenname# #sn#<br /><span class="i">#position#</span></td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
		</td>
	</tr>

</cfoutput>