<cfcomponent displayname="Galerie" extends="Controller" hint="">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(type="before",through="loadLayout") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="podgladKatalogu" output="false" access="public" hint="">
		<cfparam name="URL.KATALOG" default="" />
		<cfset katalog = URL.KATALOG />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="pokazSklepy" output="false" access="public" hint="">
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="pokazPlik" output="false" access="public" hint="">
		<cfparam name="URL.KATALOG" default="" />
		<cfparam name="URL.PLIK" default="" />
		
		<cfset plik = URL.PLIK />
		<cfset katalog = URL.KATALOG />
		
		<cfset usesLayout(false) />
	</cffunction>
</cfcomponent>