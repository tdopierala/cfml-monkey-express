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
					action="index.cfm?controller=store_attributes&action=add">
				
				<div class="instance_form_ol_bg">
					<ol class="horizontal instance_form_ol instance_form_ol_left">
						<li>
							<label for="attribute_name">Nazwa atrybutu</label>
							<cfinput type="text" class="input" name="attribute_name" />
						</li>
						<li>
							<label for="attribute_type_id">Typ atrybutu</label>
							<cfselect query="attributeTypes" name="attribute_type_id"
									  class="select_box attribute_type_id" display="type_name" value="id">
									  	  
							</cfselect>
						</li>
						<li>
							<cfinput type="submit" name="store_attribute_add_form_submit"
									 class="admin_button green_admin_button" value="Dodaj" />
						</li>
					</ol>
					<ol class="horizontal instance_form_ol attribute_type_sublist">
						
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

<cfset ajaxOnLoad("initAttribute") />