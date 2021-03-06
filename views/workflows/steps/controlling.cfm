<cfform
	name="workflow_edit_form"
	action="#URLFor(controller='Workflows',action='actionStep')#" >
	
	
	<!---
		Pola ukryte potrzebne do prawidłowego zapisania etapu obiegu dokumentów.
	--->
	<cfinput name="workflowid" type="hidden" value="#workflowid#" />
	<cfinput name="documentid" type="hidden" value="#documentid#" />
	<cfinput name="workflowstepid" type="hidden" value="#id#" />
	<cfinput name="prev" type="hidden" value="#prev#" />
	<cfinput name="next" type="hidden" value="#next#" />

	<table class="uiTable uiWorkflowTable">
		<thead>
			<tr>
				<th>&nbsp;</th>
				<th>&nbsp;</th>
				<th>&nbsp;</th>
				<th>&nbsp;</th>
			</tr>
		</thead>
		<tbody>
			<tr class="accounting_description">
				<td class="leftBorder bottomBorder rightBorder">MPK</td>
				<td class="rightBorder bottomBorder">Projekt</td>
				<td class="rightBorder bottomBorder">Netto</td>
				<td class="rightBorder bottomBorder">&nbsp;</td>
			</tr>
			<!---
				Generowanie istniejących elementów opisujących fakturę.
			--->
			<cfloop query="workflowDescription">
				<tr class="wds-<cfoutput>#id#</cfoutput>">
					<td>
						<input type="text" name="workflowstepdescription[<cfoutput>#id#</cfoutput>][mpkid]" class="input full mpkautocomplete {field_name:'mpkid',id:<cfoutput>#id#</cfoutput>}" value="<cfoutput>#mpk# - #m_nazwa#</cfoutput>"/>
					</td>
					<td>
						<input type="text" name="workflowstepdescription[<cfoutput>#id#</cfoutput>][projectid]" class="input full projectautocomplete {field_name:'projectid',id:<cfoutput>#id#</cfoutput>}" value="<cfoutput>#projekt# - #p_nazwa#</cfoutput>"/>
					</td>
					<td>
						<input type="text" name="workflowstepdescription[<cfoutput>#id#</cfoutput>][workflowstepdescription]" class="c price priceautocomplete input full {field_name:'workflowstepdescription',id:<cfoutput>#id#</cfoutput>}" value="<cfoutput>#workflowstepdescription#</cfoutput>"/>
					</td>
					<td class="r">
						<a href="index.cfm?controller=workflows&action=ajax-delete-description-by-id&key=<cfoutput>#id#</cfoutput>" class="removeRow darkRed" title="Usuń wiersz">Usuń wiersz</a>
					</td>
				</tr>
			</cfloop>
			<!---
				Koniec generowania istniejących elementów opisujących fakture.
			--->
			<tr class="accounting_description_options">
				<td colspan="4" class="r">
					<a
						href="<cfoutput>#URLFor(controller="Workflows",action="getTableRow2")#</cfoutput>"
						class="getTableRow darkRed {workflowid: <cfoutput>#workflowid#</cfoutput>, workflowstepid:<cfoutput>#id#</cfoutput>}"
						title="Dodaj wiersz">

						+wiersz

					</a>
				</td>
			</tr>
			<tr class="accounting_summary">
				<td colspan="2" class="r">Pozostało</td>
				<td>
					<cfinput
						name="accounting_description_remain"
						type="text"
						class="input full c" />
				</td>
				<td>
					<cfinput
						name="accounting_description_net_sum"
						type="text"
						class="input full c" />
				</td>
			</tr>
		</tbody>
		<tfoot>
			<tr>
				<td>Użytkownik</td>
				<td>
					<cfinput
						name="move_to_user"
						type="text"
						class="input full"
						data-step="2" />
				</td>
				<td colspan="2" class="move_to_user_search_result">
					<select name="userid" class="select_box user_select_box required">

					</select>
				</td>
			</tr>
			<tr>
				<td>
					Komentarz
				</td>
				<td>
					<cfinput
						type="text"
						name="workflowsteptransfernote"
						class="input full" />
				</td>
				<td colspan="2" class="r">
					
					<cfif params.action eq 'acceptInvoice'>
						<!---<cfinput
							type="submit"
							name="workflow_edit_form_submit"
							class="uiSubmitInvoice submitRed"
							value="Prawidłowy dekret" />--->
							
						<cfinput type="hidden" name="workflow_edit_form_submit" value="Prawidłowy dekret" />
						<a	href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Workflows",action="actionStep")#</cfoutput>', 'intranet_left_content', curtainClose, null, 'POST', 'workflow_edit_form');"
							title="Prawidłowy dekret"
							class="uiSubmitInvoice submitRed hide_curtain">
								<span>Prawidłowy dekret</span>
						</a>
					<cfelse>
						<a
							href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Workflows",action="rejectStep")#</cfoutput>', 'intranet_left_content', null, null, 'POST', 'workflow_edit_form');"
							title="Odrzucam"
							class="uiSubmit submitGray">
								<span>Odrzucam</span>
						</a>
	
						<cfinput
							type="submit"
							name="workflow_edit_form_submit"
							class="uiSubmit submitRed"
							value="Prawidłowy dekret" />
					</cfif>
				</td>
			</tr>

		</tfoot>
	</table>

</cfform>