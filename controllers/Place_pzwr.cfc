<cfcomponent
	extends="Controller"
	output="false">
		
	<cffunction
		name="init">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
		<cfset filters(through="loadJs",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" access="public" output="false" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="loadJs" access="public" output="false" hint="">
		<cfset APPLICATION.bodyImportFiles &= ",pzwrNieruchomosci" />
	</cffunction>
	
	<cffunction 
		name="index"
		output="false" >
	
		<cfset places = APPLICATION.cfc.nieruchomosci.getPlaces() />
	
	</cffunction> 
	
	<cffunction
		name="assignFields" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset newConnection = model("pzwr_export_mapping").create(FORM) />
		</cfif>
		
		<cfset pzwrColumns = APPLICATION.cfc.nieruchomosci.init().getColumns() />
		<cfset placeForms = model("place_form").getAllForms() />
		<cfset connections = model("pzwr_export_mapping").getConnections() />
		<cfset usesLayout(false) />
			
	</cffunction>
	
	<cffunction name="getFormFields" output="false" access="public" hint="">
		<cfset json = model("place_field").getFieldsByForm(formid=params.key) />
		<cfset json = QueryToStruct(Query=json) />
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction name="importPlaces" output="false" access="public" hint="">
		<cfset tmp = APPLICATION.cfc.nieruchomosci.init().movePlaces() />
		<cfset redirectTo(back=true) />
	</cffunction>
	
	<cffunction name="importSinglePlace" output="false" access="public" hint="">
		<cfset json = {
			message = "Nieruchomość została zaimportowana",
			status = true} />
		
		<cfif IsDefined("params.key")>
			<cfset res = APPLICATION.cfc.nieruchomosci.init().moveSinglePlace(params.key) />
			
			<cfif res is false>
				<cfset json = {
					message = "Nie można dodać nieruchomości",
					status = res 
				 } />
			</cfif>
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
	<cffunction name="getFromInternet" output="false" access="public" hint="">
		<cftry>
			<cfset tmp = APPLICATION.cfc.nieruchomosci.init().updateLocalTable() />
		<cfcatch type="any"></cfcatch>
		</cftry>
		
		<cfset redirectTo(back=true) />
	</cffunction>
	
	<cffunction name="removeConnection" output="false" access="public" hint="">
		<cfset myDistrict = model("Pzwr_export_mapping").deleteByKey(params.key) />
		<cfset renderNothing() />
	</cffunction>
	
</cfcomponent>