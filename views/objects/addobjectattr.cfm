<cfif IsDefined("results")>
	<div class="uiMessage uiConfirmMessage">
		<cfoutput>#results.message#</cfoutput>
	</div>
</cfif>

<cfform name="add_object_attr_form"
		action="index.cfm?controller=objects&action=add-object-attr&defid=#defid#">
	
	<ol class="horizontal">
		<li>
			<label for="attrid">Nazwa atrybutu</label>
			<cfselect name="attrid" class="select_box" 
					  query="availableAttr" display="attr_name" value="attr_id">
				
			</cfselect>
		</li>
		<li>
			<cfinput type="submit" name="add_object_attr_form" 
					 value="Dodaj" class="admin_button green_admin_button" />
		</li>
	</ol>
	
</cfform>