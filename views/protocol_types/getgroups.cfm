<cfoutput>
	
	<tr>
		<td class="first">&nbsp;</td>
		<td colspan="2" class="admin_submenu_options">
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa grupy</th>
						<th>Liczba pól</th>
						<th>Widoczność</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="mygroups">
						<tr>
							<td class="first">&nbsp;</td>
							<td>#groupname#</td>
							<td class="c">#fieldscount#</td>
							<td class="c">
								#checkBoxTag(
									name="access",
									class="protocoltypegroups {id:#typegroupid#}",
									checked=YesNoFormat(access))#
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
		</td>
	</tr>
	
</cfoutput>