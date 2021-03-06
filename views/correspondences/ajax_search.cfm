<cfoutput>

<cfloop query="my_list">
	<tr>
		<td>
			<select
				name="typeid[#id#]"
				class="select_box {id:#id#,field_name:'typeid'} typeid"
				id="typeid[#id#]">
				
				<option value=""></option>
								
				<cfset tmp = typeid />	
				<cfloop query="my_types">
					<option value="#id#" <cfif id eq tmp> selected="selected"</cfif>>#typename#</option>
				</cfloop>
							
			</select>

		</td>
		<td>
			<input 
				name="data_nadania[#id#]"
				type="text"
				class="input {id:#id#,field_name:'data_nadania'} data_nadania"
				value="#DateFormat(data_nadania, 'yyyy-mm-dd')#" />
		</td>
		<td>
			<input 
				name="letters_count[#id#]"
				type="text"
				class="input {id:#id#,field_name:'letters_count'} letters_count"
				value="#letters_count#" />
		</td>
		<td>
			#linkTo(
				text="<span>-</span>",
				controller="Correspondences",
				action="removeLetterRow",
				key=id,
				class="remove_letter_row small_admin_button red_admin_button")#
		</td>
	</tr>
</cfloop>
	
</cfoutput>