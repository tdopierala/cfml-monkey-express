<cfoutput>

	<tr>
		<td>&nbsp;</td>
		<td colspan="2" class="admin_submenu_options">
		
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa typu zdjęcia</th>
						<th>Data dodania</th>
					</tr>
				</thead>
				<tbody>
				
					<cfloop query="phototypes">
						<tr>
							<td>&nbsp</td>
							<td>#phototypename#</td>
							<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(phototypecreated, "yyyy-mm-dd")# #TimeFormat(phototypecreated, "HH:mm")#</td>
						</tr>
					</cfloop>
				
				</tbody>
			</table>
		
		</td>
	</tr>

</cfoutput>



