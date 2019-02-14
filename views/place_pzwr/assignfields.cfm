<cfprocessingdirective pageEncoding="utf-8" />

<cfdiv class="cfwindow_container">

	<div class="inner">
		
		<div class="headerArea">
			<div class="headerArea uiHeader">
				<h3 class="uiHeaderTitle">Skojarz formularz</h3>
			</div>
		</div>

		<div class="contentArea">
			<div class="contentArea uiContent">
				
				<cfform name="assign_pzwr_with_form_field"
						action="#URLFor(controller='Place_pzwr',action='assignFields')#">
					
					<ol class="uiList uiForm">
						<li>
							<label for="column_name">Pole z formularza na stronie</label>
							<cfselect 
								name="column_name"
								query="pzwrColumns"
								display="field"
								value="field"
								queryPosition="below"
								class="select_box required" >
								
								<option value="">[wybierz]</option>
								
							</cfselect>
						</li>
						<li>
							<label for="formid">Nazwa formularza</label>
							<cfselect
								name="formid"
								query="placeForms"
								display="formname"
								value="id"
								class="select_box required"
								queryPosition="below" >
								
								<option value="">[wybierz]</option>
								
							</cfselect> 
						</li>
						<li>
							<label for="fieldid">Pole formularza</label>
							<select id="fieldid" name="fieldid" class="select_box required"></select>
						</li>
						<li>
							<cfinput type="submit"
									 class="admin_button green_admin_button"
									 name="assign_pzwr_with_form_field_submit"
									 value="Przypisz" />
						</li>
					</ol>
					
				</cfform>
				
				<div class="uiFooter">
				
				</div> <!-- /end uiFooter -->
		
			</div><!-- /end contentArea uiContent -->
		</div><!-- /end contentArea -->
		
		

		<div class="footerArea">
			<ul class="uiList placeTreeList">

				<cfscript>
					for(
						i = 1;
						i LTE connections.RecordCount;
						i = i + 1) {
					
						writeOutput("
							<li>
								<span class=""uiListElement"">
									#connections['columnname'][i]# -> #connections['formname'][i]# - #connections['fieldname'][i]#
								</span>
								<a href=""#URLFor(controller='Place_pzwr',action='removeConnection',key=connections['id'][i])#"" class=""remove remove_connection"">x</a>
							</li>
						");
							
					}
				</cfscript>

			</ul>
		</div> <!-- /end .footerArea -->
	
	</div> <!-- /end .inner -->

</cfdiv>

<cfset ajaxOnLoad("initPzwrNieruchomosci") />
<cfset ajaxOnLoad("removeUserDistrict") />
<cfset ajaxOnLoad("validateForm") />