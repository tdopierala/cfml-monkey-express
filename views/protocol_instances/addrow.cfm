<cfoutput>
	<tr>
		<!---
			Tutaj tworzę tyle kolumn ile jest eleentów grupy.
		--->
		<cfloop query="new_row" >
		<td>
			<cfswitch expression="#fieldtypeid#" >
				<cfcase value="4" >
					<!---
						Select box z opcjami do wyboru.
					--->
					<cfset my_query = my_selectbox_values[fieldid] />
					<select name="instancevalue[#id#]" id="instancevalue[#id#]">
						
						<cfloop query="my_query">
							<option value="#fieldvalue#">#fieldvalue#</option>
						</cfloop>
					
					</select>
													
					<!---
						Koniec selectboxa.
					--->
				</cfcase>
				<cfdefaultcase>
					<!---
						Domyślne pole formularza
					--->
					<cfif readonly eq 1>
				
						#textFieldTag(
							name="instancevalue[#id#]",
							class="horizontal_input #fieldclass#",
							readonly="readonly",
							value=fieldvalue)#
												
					<cfelse>
							
						#textFieldTag(
							name="instancevalue[#id#]",
							class="horizontal_input #fieldclass#",
							value=fieldvalue)#	
								
					</cfif>
													
				</cfdefaultcase>
			</cfswitch>
											
		</td>
		</cfloop>
		<td>
			#linkTo(
				text="-",
				controller="Protocol_instances",
				action="removeRow",
				params="groupid=#groupid#&typeid=#typeid#&instanceid=#instanceid#&row=#row_number.m+1#",
				class="small_admin_button red_admin_button remove_row")#
		</td>
	</tr>
</cfoutput>

<script>
	$(function() {
		$('.pick_up_date').datepicker({
			dateFormat: 'dd-mm-yy',
			monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
			dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So'],
			firstDay: 1
		});
	});
</script>