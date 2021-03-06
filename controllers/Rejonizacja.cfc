<cfcomponent displayname="Rejonizacja" extends="Controller">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="before",type="before") /> 
	</cffunction>
	
	<cffunction name="before" output="false" access="public" hint="">
		<cfset usesLayout(template="/layout") />
		<cfset APPLICATION.bodyImportFiles = ",initRejonizacja" /> 
	</cffunction>
	
	<cffunction name="index" output="false" access="public" hint="">
		<cfset makroregiony = model("rejonizacja_makroregion").pobierzMakroregiony() />
	</cffunction>
	
	<cffunction name="dodajRejon" output="false" access="public" hint="">
		<cfset powiaty = model("rejonizacja_powiat").pobierzPowiaty() />
		<cfset rejony = model("rejonizacja_rejon").pobierzRejony() />
		<cfset wojewodztwa = model("rejonizacja_wojewodztwo").pobierzWoj() />
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			
			<cfset nowyRejonDef = model("rejonizacja_rejon_def").new() />
			<cfset nowyRejonDef.nazwa = FORM.NAZWA />
			<cfset nowyRejonDef.save(callbacks=false) />
			
			<cfset nowyRejon = model("rejonizacja_rejon").przypiszPowiaty(nowyRejonDef.id, FORM.POWIATID) />
		</cfif>
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="dodajMakroregion" output="false" access="public" hint="">
		<cfset rejony = model("rejonizacja_rejon").pobierzRejony() />
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset nowyMakroregionDef = model("rejonizacja_makroregion_def").new() />
			<cfset nowyMakroregionDef.nazwa = FORM.NAZWA />
			<cfset nowyMakroregionDef.save(callbacks=false) />
			
			<cfset nowyMakroregion = model("rejonizacja_makroregion").przypiszRejony(nowyMakroregionDef.id, FORM.REJONID) />
		</cfif>
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="uzytkownicyRejonow" output="false" access="public" hint="">
		<cfset rejony = model("rejonizacja_rejon").pobierzRejony() />
		<cfset uzytkownicy = model("tree_groupuser").getUsersByGroupName("Partner ds sprzedazy") />
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset nowePrzypisanie = model("rejonizacja_rejon").przypiszUzytkownika(FORM) />
		</cfif>
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="powiatyWojewodztwa" output="false" access="public" hint="">
		<cfset json = "" />
		<cfif IsDefined("FORM.WOJID")>
			<cfset var pow = model("rejonizacja_powiat").pobierzPowiaty(FORM.WOJID) />
			<cfset json = QueryToStruct(Query=pow) />
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
	<cffunction name="usunPowiatAction" output="false" access="public" hint="">
		
		<cfset var pow = model("rejonizacja_rejon").usunPowiat(params.rejon, params.powiat) />
		
		<cfset json = pow />
		
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
	<cffunction name="usunUzytkownikaAction" output="false" access="public" hint="">
		
		<cfset var pow = model("rejonizacja_rejon").usunUzytkownika(params.rejon, params.userid) />
		
		<cfset json = pow />
		
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
	<cffunction name="pobierzRejonyMakroregionu" output="false" access="public" hint="">
		<cfset rejony = queryNew("id") />
		<cfif IsDefined("URL.KEY")>
			<cfset rejony = model("rejonizacja_rejon").pobierzRejonyMakroregionu(url.key) />
			
			<cfloop query="rejony">
				<cfif rejony.usersid neq ''>
					
					<cfset rejony.usersid = model("User").findAll(where="id IN (#rejony.usersid#)") />
					
				</cfif>
				
				<cfif rejony.powiatid neq ''>
					
					<cfset rejony.powiatid = model("rejonizacja_powiat").findAll(where="id IN (#rejony.powiatid#)") />
					
				</cfif>
			</cfloop>

		</cfif>
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="usunRejonMakroregionu" output="false" access="public" hint="">
		
		<cfset var pow = model("rejonizacja_rejon").usunRejonMakroregionu(params.makroregion, params.rejon) />
		
		<cfset json = pow />
		
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
	<cffunction name="usunMakroregion" output="false" access="public" hint="">
		
		<cfset var pow = model("rejonizacja_makroregion").usunMakroregion(params.key) />		
		<cfset json = pow />		
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
</cfcomponent>