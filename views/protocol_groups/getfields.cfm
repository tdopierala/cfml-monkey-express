<cfoutput>
	
	<tr>
		<td class="first">&nbsp;</td>
		<td colspan="2" class="admin_submenu_options">
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa pola</th>
						<th>Typ pola</th>
						<th>Widoczność</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="myfields">
						<tr>
							<td class="first">&nbsp;</td>
							<td>#fieldname#</td>
							<td>#fieldtypename#</td>
							<td class="c">
								#checkBoxTag(
									name="access",
									class="protocolaccessfield {id:#fieldgroupid#}",
									checked=YesNoFormat(access))#
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
		</td>
	</tr>
	
</cfoutput>