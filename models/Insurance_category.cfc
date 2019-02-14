<cfcomponent displayname="Insurance_category" extends="Model" output="false">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("insurance_categories") />
	</cffunction>
	
	<cffunction name="getAllCategories" output="false" access="public" hint="">
		<cfset var listaKategorii = "" />
		<cfquery name="listaKategorii" datasource="#get('loc').datasource.intranet#">
			select id, categoryname from insurance_categories;
		</cfquery>
		
		<cfreturn listaKategorii />
	</cffunction>
</cfcomponent>