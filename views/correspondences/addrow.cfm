<cfoutput>
	<cfloop query="my_list">
	<tr>
		<td>
			<input 
				type="text"
				name="lp[#id#]"
				class="input first {id: #id#,field_name:'lp'}"
				value="#lp#" />
		</td>
		<td>
			<input 
				type="text"
				name="adresat[#id#]"
				class="input {id: #id#,field_name:'adresat'} adresat"
				value="#adresat#" />
		</td>
		<td>
			<input 
				type="text"
				name="miejsce_doreczenia[#id#]"
				class="input {id: #id#,field_name:'miejsce_doreczenia'} miejsce_doreczenia"
				value="#miejsce_doreczenia#" />
		</td>
		<td>
			<input 
				type="text"
				name="kwota_zl[#id#]"
				class="input first {id: #id#,field_name:'kwota_zl'}"
				value="#kwota_zl#" />
		</td>
		<td>
			<input 
				type="text"
				name="kwota_gr[#id#]"
				class="input first {id: #id#,field_name:'kwota_gr'}"
				value="#kwota_gr#" />
		</td>
		<td>
			<input 
				type="text"
				name="masa_kg[#id#]"
				class="input first {id: #id#,field_name:'masa_kg'}"
				value="#masa_kg#" />
		</td>
		<td>
			<input 
				type="text"
				name="masa_g[#id#]"
				class="input first {id: #id#,field_name:'masa_g'}"
				value="#masa_g#" />
		</td>
		<td>
			<input 
				type="text"
				name="nr_nadawczy[#id#]"
				class="input {id: #id#,field_name:'nr_nadawczy'}"
				value="#nr_nadawczy#" />
		</td>
		<td>
			<input 
				type="text"
				name="uwagi[#id#]"
				class="input {id: #id#,field_name:'uwagi'}"
				value="#uwagi#" />
		</td>
		<td>
			<input 
				type="text"
				name="oplata_zl[#id#]"
				class="input first {id: #id#,field_name:'oplata_zl'}"
				value="#oplata_zl#" />
		</td>
		<td>
			<input 
				type="text"
				name="oplata_gr[#id#]"
				class="input first {id: #id#,field_name:'oplata_gr'}"
				value="#oplata_gr#" />
		</td>
		<td>
			<input 
				type="text"
				name="pobranie_zl[#id#]"
				class="input first {id: #id#,field_name:'pobranie_zl'}"
				value="#pobranie_zl#" />
		</td>
		<td>
			<input 
				type="text"
				name="pobranie_gr[#id#]"
				class="input first {id: #id#,field_name:'pobranie_gr'}"
				value="#pobranie_gr#" />
		</td>
		<td>
			#linkTo(
				text="<span>-</span>",
				controller="Correspondences",
				action="removeRow",
				key=id,
				class="remove_correspondence_row small_admin_button red_admin_button")#
		</td>
	</tr>
	</cfloop>
</cfoutput>