<cfoutput>
	<tr>
		<td>&nbsp;</td>
		<td colspan="2" class="admin_submenu_options">
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa pola</th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>#elcnt#</td>
						<td>
							#textFieldTag(
								name="selectboxname[#elcnt#]",
								label=false,
								class="input")#
						</td>
						<td>
							#linkTo(
								text="<span>dodaj</span>",
								controller="Place_forms",
								action="addSelectBoxSingleForm",
								key=elcnt,
								class="add_selectbox_element")#
						</td>
					</tr>
				</tbody>
			</table>
			
		</td>
	</tr>
</cfoutput>