<cfoutput>

<tr>
	<td>
		<input
			type="text"
			name="data_wplywu-#new_row.id#"
			class="input pick_up_date {id:#new_row.id#, field_name:'data_wplywu'}" />
	</td>
	<td>
		<input
			type="text"
			name="pismo_z_dn-#new_row.id#"
			class="input pick_up_date {id:#new_row.id#, field_name:'pismo_z_dn'}" />
	</td>
	<td>
		<input
			type="text"
			name="sygnatura-#new_row.id#"
			class="input {id:#new_row.id#, field_name:'sygnatura'}" />
	</td>
	<td>
		<select
			name="typeid-#new_row.id#"
			class="select_box {id:#new_row.id#,field_name:'typeid'}">

			<option value="">[Typ]</option>
			<cfloop query="my_types">
				<option value="#id#">#typename#</option>
			</cfloop>

		</select>
	</td>
	<td>
		<select
			name="category-#new_row.id#"
			class="select_box {id:#new_row.id#,field_name:'categoryid'}">

			<option value="">[Kategoria]</option>
			<cfloop query="my_categories">
				<option value="#id#">#categoryname#</option>
			</cfloop>

		</select>
	</td>
	<td>
		<input
			type="text"
			name="nadawca-#new_row.id#"
			class="input {id:#new_row.id#, field_name:'nadawca'}" />
	</td>
	<td>
		<input
			type="text"
			name="adres-#new_row.id#"
			class="input {id:#new_row.id#, field_name:'adres'}" />
	</td>
	<td>
		<input
			type="text"
			name="dotyczy-#new_row.id#"
			class="input {id:#new_row.id#, field_name:'dotyczy'}" />
	</td>
</tr>

</cfoutput>