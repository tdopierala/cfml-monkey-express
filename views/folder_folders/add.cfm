<cfprocessingdirective pageEncoding="utf-8" />

<div class="cfwindow_container">
	<div class="inner">
		
		<div class="headerArea">
			<div class="headerArea uiHeader">
				<h3 class="uiHeaderTitle">Dodaj nową teczkę</h3>
			</div>
		</div>
		
		<div class="contentArea">
			<div class="contentArea uiContent">
				
				<cfform name="folder_new_folder_form"
						action="#URLFor(controller='Folder_folders',action='add')#"
						onsubmit="javascript:$('##folderdescription').val(CKEDITOR.instances['folderdescription'].getData())">
					
					<cfinput type="hidden" name="folderid" value="#params.folderid#" /> 
					
					<ul class="uiList uiForm">
						<li>
							<label for="foldername">Nazwa teczki</label>
							<cfinput type="text"
									 class="input"
									 name="foldername" />
						</li>
						<li>
							<label for="folderdescription">Opis teczki</label>
							<cftextarea name="folderdescription"
										class="ckeditor" >
							</cftextarea>
						</li>
						<li>
							<input type="submit"
								name="folder_new_folder_form_submit"
								class="admin_button green_admin_button"
								value="Zapisz" />
						</li>
					</ul>
					
				</cfform>
				
				<div class="uiFooter">
					
				</div>
		
			</div>
		</div>

		<div class="footerArea">

		</div>
		
	</div>
</div>

<cfset ajaxOnLoad("initFolders") />