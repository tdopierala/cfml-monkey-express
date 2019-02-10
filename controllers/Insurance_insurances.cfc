<cfcomponent displayname="Insurance_insurances" output="false" extends="Controller">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="edit" output="false" access="public" hint="">
		<!--- Pobieram informacje o kontrahencie --->
		<cfset sklep = model("store_store").getStoreByUser(session.user.login, session.user.logo) />
	</cffunction>
</cfcomponent>