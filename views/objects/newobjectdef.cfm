<cfif IsDefined("results")>
	<div class="uiMessage <cfif results.success is true> uiConfirmMessage <cfelse> uiErrorMessage </cfif>">
		<cfoutput>#results.message#</cfoutput>
	</div>
</cfif>

<cfform name="object_def_form"
		action="index.cfm?controller=objects&action=new-object-def"
		id="object_def_form">
											
	<ol class="uiList uiForm align-middle">
		<li>
			<label for="def_name">Nazwa obiektu</label>
			<cfinput type="text" name="def_name" class="input" /> 
		</li>
		<li>
			<div class="def_available_attr box">
				<cfoutput query="attr">
					<span class="attr_item {id:#id#}">#attr_name#</span>
				</cfoutput>
			</div>
		</li>
		<li>
			<div class="def_assigned_attr box"></div>
		</li>
		<li>
			<cfinput type="submit" name="object_def_form_submit" 
					 class="admin_button green_admin_button" value="Zapisz" /> 
		</li>
	</ol>
</cfform>

<cfset ajaxOnLoad("initNewObjectDef") />