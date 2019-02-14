<cfsilent>
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaDyrektorzy" >
		<cfinvokeargument name="groupname" value="Dyrektorzy" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaDp" >
		<cfinvokeargument name="groupname" value="Departament Personalny" />
	</cfinvoke>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Dodaj nową instrukcję</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<cfif IsDefined("results")>
				<div class="uiMessage <cfif results.success is true> uiConfirmMessage <cfelse> uiErrorMessage </cfif>"><cfoutput>#results.message#</cfoutput></div>
			</cfif>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<div id="uiInstructions">
				
				<cfform name="instruction_add_form" action="index.cfm?controller=instructions&action=add"
						enctype="multipart/form-data">
					
					<ol class="horizontal">
						<li>
							<label for="documenttypeid">Numer dokumentu</label>
							
							<select name="documenttypeid" class="select_box">
								<cfloop query="documenttypes">
									<cfif uprawnieniaDyrektorzy is true and uprawnieniaDp is true>
										<cfoutput>
											<option value="#id#">#documenttypename#</option>
										</cfoutput>
									<cfelse>
										<cfif id eq 1 or id eq 3>
											<cfcontinue />
										<cfelse>
											<cfoutput>
												<option value="#id#">#documenttypename#</option>
											</cfoutput>
										</cfif>
									</cfif>
								</cfloop>
							</select>
							
							/
							<cfoutput>#DateFormat(Now(), "yyyy")#</cfoutput>
							/
							<cfoutput>#DateFormat(Now(), "mm")#</cfoutput>
							/
							<cfselect
								name="department_name"
								query="departments"
								value="selectvalue"
								display="selectvalue"
								class="select_box" >
	
							</cfselect>
						</li>
						<li>
							<label for="statusid">Status dokumentu</label>
							<cfselect name="statusid" query="statuses" value="id" display="statusname" class="select_box">
	
							</cfselect>
						</li>
						<li>
							<label for="typeid">Typ dokumentu</label>
							<cfloop query="document_types">
								<span class="checkboxGroup">
									<cfinput type="checkbox" name="typeid" value="#id#" checked="true" /> <cfoutput>#typename#</cfoutput>
								</span>
							</cfloop>
						</li>
						<li>
							<label for="instruction_about">Dotyczy</label>
							<cftextarea
								name="instruction_about"
								class="textarea ckeditor" />
						</li>
						<li>
							<label for="instruction_date_from">Data obowiązywania od</label>
							<cfinput
								name="instruction_date_from"
								type="text"
								class="input date_picker" />
						</li>
						<li>
							<label for="instruction_date_to">Data obowiązywania do</label>
							<cfinput
								name="instruction_date_to"
								type="text"
								class="input date_picker" />
						</li>
						<li>
							<label for="archive_instructions">Dokumenty tracące ważność</label>
							<cfinput
								name="archive_instructions"
								type="text"
								class="input" />
						</li>
						<li>
							<label for="file">Plik</label>
							<cfinput
								name="file"
								type="file"
								accept="application/pdf" />
						</li>
						<li>
							<p>Uprawnienia dokumentu</p>
							<ol class="darkFrame">
								<cfloop query="privileges">
									<cfoutput>
										<li class="level-#level#">
											<cfinput type="checkbox" name="groupid" value="#id#" class="instructionGroupPrivilege {level: #level#}" /> #groupname#
										</li>
									</cfoutput>
								</cfloop>
							</ol>
						</li>
						<li>
							<cfinput type="submit" name="instruction_add_form_submit"
									 class="admin_button green_admin_button" value="Zapisz" />
						</li>
						
					</ol>
					
				</cfform>
				
			</div>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

<cfset ajaxOnLoad("initInstruction") />