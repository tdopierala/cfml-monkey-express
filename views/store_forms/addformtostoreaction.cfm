<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
				<cfloop array="#formularze#" index="formularz" >
					
					<cfdiv class="instanceObjectForm" id="instanceFormSubmit#formularz.form_id#">
						<div class="instanceHeader uiInstanceHeader">
							<h5 class="uiInstanceTitle"><cfoutput>#formularz.form_name#</cfoutput></h5>
						</div>
						
						<cfform name="add_object_to_store_form"
							action="index.cfm?controller=store_forms&action=save-store-form&storeid=#storeid#&formid=#formularz.form_id#">
							
							<cfinput type="hidden" name="storeid" value="#storeid#" />
							<cfinput type="hidden" name="projekt" value="#store.projekt#" />
							
							<ol class="horizontal">
								<cfloop query="formularz">
									<li>
										<label for="<cfoutput>attribute-#form_id#.#attribute_id#.#attribute_type_id#</cfoutput>"><cfoutput>#attribute_name#</cfoutput></label>
										
										<cfswitch expression="#formularz.attribute_type_id#" >
										
											<cfcase value="1">
												<cfinput type="text" name="attribute-#form_id#.#attribute_id#.#attribute_type_id#" class="input" />
											</cfcase>
										
											<cfcase value="2" >
												<select name="<cfoutput>attribute-#form_id#.#attribute_id#.#attribute_type_id#</cfoutput>" class="select_box">
													<cfloop query="slownik">
														<cfif slownik.attribute_id eq formularz.attribute_id>
															<option value="<cfoutput>#dictionary_value#</cfoutput>"><cfoutput>#dictionary_value#</cfoutput></option>
														</cfif>
													</cfloop>
												</select>
												
											</cfcase>
										
										</cfswitch>
									</li>
								</cfloop>
								<li>
									<cfinput type="submit" class="admin_button green_admin_button" 
											 name="add_object_to_store_form" value="Zapisz" />
								</li>
							</ol>
						</cfform>
					</cfdiv>
					
				</cfloop>
			
				<div class="clear"></div>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<div id="uiObjectsContainer"></div>

			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>
