<cfoutput>

	<tr>
		<td>&nbsp;</td>
		<td colspan="2" class="admin_submenu_options">
		
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa typu pliku</th>
						<th>Data dodania</th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody>
				
					<cfloop query="filetypes">
						<tr>
							<td>&nbsp</td>
							<td>#filetypename#</td>
							<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(filetypecreated, "yyyy-mm-dd")# #TimeFormat(filetypecreated, "HH:mm")#</td>
							<td>
								#linkTo(
									text="<span>Usuń plik z etapu</span>",
									controller="Place_files",
									action="removeFromStep",
									key=stepfiletypeid,
									class="remove_from_step {stepid:#stepid#,filetypeid:#id#}",
									title="Usuń plik z etapu")#
							</td>
						</tr>
					</cfloop>
				
				</tbody>
			</table>
		
		</td>
	</tr>

</cfoutput>