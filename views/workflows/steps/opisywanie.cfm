<cfform
	name="workflow_edit_form"
	action="#URLFor(controller='Workflows',action='actionStep')#"
	onsubmit="javascript:$('##workflowstepnote').val(CKEDITOR.instances['workflowstepnote'].getData())" >

	<!---
		Pola ukryte potrzebne do prawidłowego zapisania etapu obiegu dokumentów.
	--->
	<cfinput name="workflowid" type="hidden" value="#workflowid#" />
	<cfinput name="documentid" type="hidden" value="#documentid#" />
	<cfinput name="workflowstepid" type="hidden" value="#id#" />
	<cfinput name="prev" type="hidden" value="#prev#" />
	<cfinput name="next" type="hidden" value="#next#" />

	<cfinput name="AUTO_SAVE_URL" type="hidden" value="#URLFor(controller='Workflows',action='updateDescription',key=id)#" />

	<table class="uiTable uiWorkflowTable">
		<thead>
			<tr>
				<th class="l">Korekta do faktury</th>
				<th colspan="3" class="l">
					<cfinput type="text" name="archive_search" class="input search_archive_document" />
					<select name="archiveid" id="archiveid" class="select_box">
						
					</select> 
				</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td colspan="4">
					<textarea
						name="workflowstepnote"
						class="textarea ckeditor {workflowstepid:<cfoutput>#id#</cfoutput>}"
						id="workflowstepnote" >

						<cfoutput>#workflowstepnote#</cfoutput>

					</textarea>
				</td>
			</tr>
			<tr class="accounting_description">
				<th class="leftBorder topBorder rightBorder bottomBorder">MPK</th>
				<th class="topBorder rightBorder bottomBorder">Projekt</th>
				<th class="topBorder rightBorder bottomBorder">Netto</th>
				<th class="topBorder rightBorder bottomBorder">&nbsp;</th>
			</tr>
			<!---
				Generowanie istniejących elementów opisujących fakturę.
			--->
			<cfloop query="workflowDescription">
				<tr class="wds-<cfoutput>#id#</cfoutput>">
					<td class="leftBorder bottomBorder rightBorder">
						<input type="text" name="workflowstepdescription[<cfoutput>#id#</cfoutput>][mpkid]" class="mpkautocomplete input full {field_name:'mpkid',id:<cfoutput>#id#</cfoutput>}" value="<cfoutput>#mpk# - #m_nazwa#</cfoutput>"/>
					</td>
					<td class="bottomBorder rightBorder">
						<input type="text" name="workflowstepdescription[<cfoutput>#id#</cfoutput>][projectid]" class="projectautocomplete input full {field_name:'projectid',id:<cfoutput>#id#</cfoutput>}" value="<cfoutput>#projekt# - #p_nazwa#</cfoutput>"/>
					</td>
					<td class="bottomBorder rightBorder">
						<input type="text" name="workflowstepdescription[<cfoutput>#id#</cfoutput>][workflowstepdescription]" class="c price priceautocomplete input full {field_name:'workflowstepdescription',id:<cfoutput>#id#</cfoutput>}" value="<cfoutput>#workflowstepdescription#</cfoutput>"/>
					</td>
					<td class="bottomBorder rightBorder r">
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
						class="input halfFull c" />
				</td>
				<td>
					<cfinput
						name="accounting_description_net_sum"
						type="text"
						class="input halfFull c" />
				</td>
			</tr>
			<tr>
				<td class="l">Typ dokumentu</td>
				<td colspan="3" class="l">

					<cfset defSelected = "0" />

					<cfif not Len(document.typeid)>
						<cfset defSelected = document.typeid />
					</cfif>

					<cfselect name="categoryid"
							  class="document_category_id select_box {documentid:#workflow.documentid#}"
							  query="categories"
							  display="categoryname"
							  value="id"
							  queryPosition="below"
							  selected="#defSelected#">
							  	  
						<option value="0">[wybierz]</option>
							  	  
					</cfselect>
					
					<!---<cfselect
						name="typeid"
						class="document_type_id select_box {documentid:#workflow.documentid#}"
						query="types"
						display="typename"
						value="id"
						queryPosition="below"
						selected="#defSelected#" >

						<option value="0">[wybierz]</option>

					</cfselect>--->
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
						data-step="1" />
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
				<td colspan="2">
					<cfinput
						type="text"
						name="workflowsteptransfernote"
						class="input full" />
				</td>
				<td class="c">
					<cfinput
						type="submit"
						name="workflow_edit_form_submit"
						class="uiSubmit submitRed"
						value="Opisz" />
				</td>
			</tr>
		</tfoot>
	</table>

</cfform>



<cfset AjaxOnLoad("loadCKE") />
<cfset AjaxOnLoad("initWorkflowAutosave") />
<cfset AjaxOnLoad("initArchive") />