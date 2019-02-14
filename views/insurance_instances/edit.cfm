<cfprocessingdirective pageencoding="utf-8" />
	
<div class="leftWrapper">
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Wypełnij zgłoszenie</h3>
		</div>
	</div>
	
	<!--- TUTAJ BĘDĄ DANE O POLISIE I KATEGORIA ZGŁOSZENIA --->
	
	<div class="contentArea">
		<div class="contentArea uiContent">
			<cfform name="insurance_instance_edit_form"
					action="">
			
				<ol class="uiList uiForm">
					<cfoutput query="questions">
						<cfswitch expression="#questiontypeid#" >
							
							<cfcase value="1" >
								<li>
									<label for="#id#">#question#</label>
									<cftextarea name="#id#" class="textarea ckeditor" >
										
									</cftextarea>
								</li>
							</cfcase>
							
							<cfcase value="3">
								<li>
									<label for="#id#">#question#</label>
									<cfinput type="text" class="input"
											 name="#id#" />
								</li>
							</cfcase>
							
							<cfcase value="4" >
								<li>
									<label for="#id#">#question#</label>
									<select name="#id#" class="select_box">
										<cfset tmp = questionValues[questionid] />
										<cfloop query="tmp">
											<option value="#questiontypevalue#">#questiontypevalue#</option>
										</cfloop>
									</select>
								</li>
							</cfcase>
						</cfswitch>
					</cfoutput>
					
					<li>
						<cfinput type="submit" name="insurance_instance_edit_form_submit"
								 class="admin_button green_admin_button" value="Zapisz" />
					</li>
				</ol>
			
			</cfform>
		</div>
	</div>
	
</div>