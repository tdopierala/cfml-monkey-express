<cfoutput>
	
	<tr>
		<td>
			<select 
				name="typeid[#new_letter.id#]"
				class="select_box {id:#new_letter.id#,field_name:'typeid'} typeid">
			
				<option value=""></option>
				
				<cfloop query="my_types">
					<option value="#id#">#typename#</option>
				</cfloop>
			
			</select>

		</td>
		<td>
			<input
				type="text"
				name="data_nadania[#new_letter.id#]"
				class="input {id:#new_letter.id#,field_name:'data_nadania'} data_nadania" />

		</td>
		<td>
			
			<input
				type="text"
				name="letters_count[#new_letter.id#]"
				class="input {id:#new_letter.id#,field_name:'letters_count'} letters_count" />

		</td>
		<td>
			#linkTo(
				text="<span>-</span>",
				controller="Correspondences",
				action="removeLetterRow",
				key=new_letter.id,
				class="remove_letter_row small_admin_button red_admin_button")#
		</td>
	</tr>
	
</cfoutput>
<script>
$(function () {
	$('.data_nadania').datepicker({
		dateFormat: 'yy-mm-dd',
		monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
		dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So'],
		firstDay: 1
	});
});
</script>