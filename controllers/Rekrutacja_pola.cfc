<cfcomponent displayname="Rekrutacja_pola" output="false" hint="" extends="Controller">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout", type="before") />
		<!---<cfset filters(through="loadJs", type="before") />--->
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="definicjePol" output="false" access="public" hint="">
		<cfset typyPol = model("rekrutacja_pole").pobierzTypyPol() />
		<cfset pola = model("rekrutacja_pole").pobierzPola() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="zapiszPole" output="false" access="public" hint="">
		<cfif isDefined("FORM.FIELDNAMES")>
			<cfset var nowePole = model("rekrutacja_pole").dodajPole(nazwaPola = FORM.nazwaPola, idTypuPola = FORM.idTypuPola ) />
		</cfif>
		
		<cfset typyPol = model("rekrutacja_pole").pobierzTypyPol() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="polaAnkiet" output="false" access="public" hint="">
		<cfset polaAnkiet = model("rekrutacja_ankieta").pobierzPolaAnkiet() />
		<cfset definicjeAnkiet = model("rekrutacja_ankieta").pobierzAnkiety() />
		<cfset definicjePol = model("rekrutacja_pole").pobierzPola() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="dodajPoleDoAnkiety" output="false" access="public" hint="">
		<cfif isDefined("FORM.FIELDNAMES")>
			<cfset var nowePoleAnkiety = model("rekrutacja_ankieta").dodajPoleDoAnkiety(idDefinicjiAnkiety = FORM.idDefinicjiAnkiety, idDefinicjiPola = FORM.idDefinicjiPola) />
		</cfif>
		
		<cfset definicjeAnkiet = model("rekrutacja_ankieta").pobierzAnkiety() />
		<cfset definicjePol = model("rekrutacja_pole").pobierzPola() />
		<cfset usesLayout(false) />
	</cffunction>
	
</cfcomponent>