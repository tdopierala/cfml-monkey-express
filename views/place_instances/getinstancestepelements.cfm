<cfsilent>
	<!--- Cache z uprawnieniami --->
	<cfinclude template="../include/place_privileges.cfm" />
	
</cfsilent>

<cfoutput>

	<tr>
		<td class="first">&nbsp;</td>
		<td colspan="6" class="admin_submenu_options">
			
			<ul class="place_row_options">
				<li class="title">Formularze</li>
				<cfloop query="forms">
					
					<!---
						8.11.2012
						Tutaj odbywa się sprawdzanie, czy użytkownik ma dostęp
						do tego formularza.
					--->
					
					<cfif checkAccess(privileges=myPrivilege.placeformprivileges.rows,itemname="formid",itemvalue=formid,accessname="readprivilege") >
					
					<li>
						<cfparam name="percentage" default="0" >
						<cfset percentage = 0 />
						<cfif allfields neq 0>
							<cfset percentage = filledfield/allfields * 100 />
						</cfif>
							
						<div class="progress_bar_wrapper <cfif accepted eq 0>red_progress</cfif>">
							<div class="progress_bar_progress" style="width: #percentage#%"></div>
						</div> 
					
						#linkTo(
							text=formname,
							controller="Place_instances",
							action="getInstanceForm",
							key=instance_id,
							params="formid=#formid#",
							class="place_form_modal")#
						
						#linkTo(
							text="<span>pdf</span>",
							controller="Place_instances",
							action="getInstanceForm",
							key=instance_id,
							params="formid=#formid#&format=pdf",
							target="_blank",
							class="element_to_pdf")#
							
						#linkTo(
							text="<span>Informacje do formularza</span>",
							controller="Place_forms",
							action="getFormNotes",
							params="formid=#formid#&instanceid=#instance_id#",
							class="ajaxmodallink get_form_notes {formid:#formid#,instanceid:#instance_id#}",
							title="Notatka do formularza")#
					</li>
					
					</cfif>
					<!---
						Koniec sprawdzania dostępu użytkownika do formularza.
					--->
				</cfloop>
			</ul>
			
			<ul class="place_row_options">
				<li class="title">Zbiory</li>
				<cfloop query="collections">
					
					<!---
						8.11.2012
						Tutaj odbywa się sprawdzanie uprawnień użytkownika do zbioru.
					--->
					
					<cfif checkAccess(privileges=myPrivilege.placecollectionprivileges.rows,itemname="collectionid",itemvalue=collectionid,accessname="readprivilege") >
					
					<li>
						
						<span class="place_element_count">#collectioncount#</span>
						
						#linkTo(
							text=collectionname,
							controller="Place_collections",
							action="getInstanceCollections",
							key=instance_id,
							params="collectionid=#collectionid#",
							class="place_form_modal")#
						
						#linkTo(
							text="<span>pdf</span>",
							controller="Place_collections",
							action="getInstanceCollections",
							key=instance_id,
							params="collectionid=#collectionid#&format=pdf",
							target="_blank",
							class="element_to_pdf")#
					</li>
					
					</cfif>
					<!---
						Koniec sprawdzania uprawnień użytkownika do zbioru.
					--->
					
				</cfloop>
			</ul>
			
			<div class="clear"></div>
			
			<ul class="place_row_options">
				<li class="title">Pliki</li>
				<cfloop query="files">
				
					<!---
						8.11.2012
						Tutaj sprawdzam, czy użytkownik ma prawo dostępu do plików.
					--->
				
					<cfif checkAccess(privileges=myPrivilege.placefiletypeprivileges.rows,itemname="filetypeid",itemvalue=filetypeid,accessname="readprivilege") >
					
					<li>
						<span class="place_element_count">#filescount#</span>
						
						#linkTo(
							text=filetypename,
							controller="Place_files",
							action="getInstanceFiles",
							key=instance_id,
							params="filetypeid=#filetypeid#",
							class="")#
					</li>
					
					</cfif>
					<!---
						Koniec sprawdzania uprawnień do plików.
					--->
				
				</cfloop>
			</ul>
			
			<ul class="place_row_options">
				<li class="title">Zdjęcia</li>
				<cfloop query="photos">
				
					<!---
						8.11.2012
						Sprawdzanie uprawnień użytkownika do zdjęć.
					--->
					<cfif checkAccess(privileges=myPrivilege.placephototypeprivileges.rows,itemname="phototypeid",itemvalue=phototypeid,accessname="readprivilege") >
						
					<li>
						
						<span class="place_element_count">#photoscount#</span>
						
						#linkTo(
							text=phototypename,
							controller="Place_photos",
							action="getInstancePhotos",
							key=instance_id,
							params="phototypeid=#phototypeid#&stepid=#myworkflow.stepid#",
							target="_blank",
							class="")#
						
					</li>
					
					</cfif>
					<!---
						Koniec sprawdzania uprawnień użytkownika do pliów.
					--->
				
				</cfloop>
			</ul>
			
			<div class="clear"></div>
			
			<ul class="place_row_options">
				<li class="title">Inne</li>
					<li>
						#linkTo(
							text="Uczestnicy",
							controller="Place_instances",
							action="getInstanceUsers",
							key=myworkflow.instanceid,
							params="",
							target="_blank",
							class="")#
					</li>
			</ul>
			
			<ul class="place_row_options">
				<li class="title">Raporty</li>
				<cfloop query="reports">
					
					 <cfif checkAccess(privileges=myPrivilege.placereportprivileges.rows,itemname="reportid",itemvalue=reportid,accessname="readprivilege") > 
					
					<li>
						#linkTo(
							text=reportname,
							controller="Place_reports",
							action="view",
							key=reportid,
							params="format=pdf&instanceid=#instance_id#",
							class="")#
					</li>
					
					</cfif>
					
				</cfloop>
				
				<!---
					11.03.2013
					Raport z dodanych zdjęć do nieruchomości
				--->
				<li>
					#linkTo(
						text="Zdjęcia",
						controller="Place_photos",
						action="photoReport",
						key=myworkflow.instanceid,
						params="format=pdf",
						target="_blank",
						class="")#
				</li>
				
			</ul>
			
			<!--- Domyślne formularze --->
			<cfset i = 1 />
			<cfif defaultForms.RecordCount NEQ 0>
				<script>
					<cfloop query="defaultForms">
						<cfset screenX = 50*i />
						<cfset screenY = 20*i />
						
						window.open('index.cfm?controller=place_instances&action=get-instance-form&key=#instanceid#&formid=#formid#&window=true','#formname#','width=885,height=400,left=#screenX#,top=#screenY#,screenX=#screenX#,screenY=#screenY#');
					
						<cfset i++ />
					</cfloop>
				</script>
			</cfif>
			
			<!--- Domyślne raporty --->
			<cfset i = 1 />
			<cfif defaultReports.RecordCount NEQ 0>
				<script>
					<cfloop query="defaultReports">
						<cfset screenX = 50*i />
						<cfset screenY = 30*i />
						
						window.open('index.cfm?controller=place_reports&action=view&key=#reportid#&instanceid=#instanceid#&format=pdf', 'Raport', 'width=885,height=400,left=#screenX#,top=#screenY#,screenX=#screenX#,screenY=#screenY#');
						
						
					</cfloop>
				</script>
			</cfif>
			
		</td>
	</tr>

</cfoutput>