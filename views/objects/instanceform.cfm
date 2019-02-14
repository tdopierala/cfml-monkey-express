<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle"><cfoutput>#object.getName()#</cfoutput></h3>
	</div>
</div>

<cfform name="object_new_instance_form"
		action="index.cfm?controller=objects&action=instance-form&defid=#object.getId()#">

	<cfinput type="hidden" name="defid" value="#object.getId()#" />
	<cfinput type="hidden" name="parentid" />
	<div class="instance_form_ol_bg">
		<ol class="horizontal instance_form_ol instance_form_ol_left">
			<li>
				<label for="inst_name">Nazwa obiektu</label>
				<cfinput type="text" name="inst_name" class="input redborder" />
			</li>
			<cfoutput query="atrybuty">
				<li>
					<label for="attr:#def_id#.#attr_id#.#def_attr_id#.#attr_type_id#">#attr_name#</label>
					<cfinput type="text" name="attr:#def_id#.#attr_id#.#def_attr_id#.#attr_type_id#" class="input" />
				</li>
			</cfoutput>
			<li>
				<cfinput type="submit" class="admin_button green_admin_button" name="object_new_instance_form_submit" value="Zapisz" />
			</li>
		</ol>
		<ol class="horizontal instance_form_ol">
			<li>
				<label for="parentid">El. nadrzędny</label>
				<cfselect name="pid" class="select_box" id="pid"
						  query="parents" display="inst_name" value="id">
						  	  
				</cfselect>
				<a href="##" class="admin_button green_admin_button addParentId">+</a>
			</li>
			<li></li>
		</ol>
	</div>
</cfform>

<cfset ajaxOnLoad("initInstAdd") />