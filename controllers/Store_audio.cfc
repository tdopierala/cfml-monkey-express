<cfcomponent displayname="Store_audio" output="false" extends="Controller" >
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(type="before",through="loadLayout") />
		<cfset filters(through="loadJs",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="loadJs" output="false" access="public" hint="">
		<cfset APPLICATION.ajaxImportFiles &= ",initStoreAudio" />
	</cffunction>
	
	<cffunction name="lista" output="false" access="public" hint="">
		<cfset listaAudio = model("store_audio").pobierzListe() />
		
		<cfparam name="url.t" default="" />
		<cfif url.t eq 1>
			<cfset usesLayout(false) />
		</cfif>
		
	</cffunction>
	
	<cffunction name="importujPlik" output="false" access="public" hint="">
		<cfset sklepy = 0 />
		<cfif isDefined("FORM.FIELDNAMES")>
			<cfspreadsheet action="read" src="#FORM.SRC#" query="plikImportu" headerrow="1" excludeheaderrow="true" sheetname="#FORM.NAZWAARKUSZA#" />
			<cfset sklepy = model("store_audio").importujDane(plikImportu) />
		</cfif>
		
		<cfset usesLayout(false) />
	</cffunction>
</cfcomponent>