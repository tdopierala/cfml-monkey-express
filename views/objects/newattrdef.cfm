<cfif IsDefined("results")>
	<div class="uiMessage uiConfirmMessage">
		<cfoutput>#results.message#</cfoutput>
	</div>
</cfif>

<cfform name="object_attr_def_form"
		action="index.cfm?controller=objects&action=new-attr-def"
		onsubmit="">

	<ol class="uiList uiForm align-middle">
		<li>
			<label for="attr_name">Nazwa atrybutu</label>
			<cfinput type="text" name="attr_name" class="input" /> 
		</li>
		<li>
			<label for="attr_type_id">Typ atrybutu</label>
			<cfselect name="attr_type_id" class="select_box" query="attr_types" value="id" display="attr_type_name" >
			</cfselect>
		</li>
		<li>
			<cfinput type="submit" name="object_attr_def_form_submit" 
					 class="admin_button green_admin_button" value="Zapisz" /> 
		</li>
	</ol>
</cfform>