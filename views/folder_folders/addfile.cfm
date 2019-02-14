<cfprocessingdirective pageencoding="utf-8" />

<div class="cfwindow_container clearfix">

	<div class="inner">
		
		<div class="headerArea">
			<div class="headerArea uiHeader">
				<h3 class="uiHeaderTitle">Dodaj plik</h3>
			</div>
			
			<cfif flashKeyExists("success")>
				<div class="headerArea uiFlash">
					<span class="success"><cfoutput>#flash("success")#</cfoutput></span>
				</div>
			</cfif>
			
		</div>
		
		

		<div class="contentArea">
			<div class="contentArea uiContent">
				
				<cfform name="form_folder_add_document" action="#URLFor(controller='Folder_folders',action='addFile',folderid=params.folderid)#" enctype="multipart/form-data"> 
					<cfinput type="hidden" name="folderid" value="#params.folderid#" /> 
					<ol class="uiList uiForm">
						<li>
							<cfinput type="file" name="filedata" /> 
						</li>
						<li>
							<cfinput type="submit"
									 value="Dodaj"
									 class="admin_button green_admin_button"
									 name="form_folder_add_document" />
						</li>
					</ol>
					
				</cfform>
				
				<div class="uiFooter">
				
				</div> <!-- /end uiFooter -->
		
			</div><!-- /end contentArea uiContent -->
		</div><!-- /end contentArea -->
		
		

		<div class="footerArea">
			<ul class="uiList">

				<cfscript>
					
				</cfscript>

			</ul>
		</div> <!-- /end .footerArea -->
	
	</div> <!-- /end .inner -->

</div>