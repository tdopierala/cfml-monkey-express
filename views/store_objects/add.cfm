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
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<cfform name="store_attribute_add_form"
					action="index.cfm?controller=store_objects&action=add">
				
				<div class="instance_form_ol_bg">
					<ol class="horizontal instance_form_ol instance_form_ol_left">
						<li>
							<label for="object_name">Nazwa obiektu</label>
							<cfinput type="text" class="input" name="object_name" />
						</li>
						<li>
							<cfinput type="submit" name="store_attribute_add_form_submit"
									 class="admin_button green_admin_button" value="Dodaj" />
						</li>
					</ol>
					<ol class="horizontal instance_form_ol attribute_type_sublist">
						<li>
							<label for="attrid">Atrybut obiektu</label>
							<select name="attrid" class="select_box">
								<cfoutput query="attributes">
									<option value="#id#.#attribute_type_id#">#attribute_name#</option>
								</cfoutput>
							</select>
							<a href="#" class="add_object_attribute" title="Dodaj atrybut do obiektu">+</a>
						</li>
					</ol>
				</div>
				
			</cfform>

			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

<cfset ajaxOnLoad("initObject") />