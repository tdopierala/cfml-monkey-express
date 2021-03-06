<cfcomponent
	displayname="test"
	hint=""
	output="false"
	extends="json" >

	<cfproperty 
		name="datasource"
		type="string"
		default="cfartgallery">
		
	<cfset THIS.datasource = "cfartgallery" />

	<cffunction
		name="init">
	
		<cfargument 
			name="datasource"
			type="string" 
			default="#THIS.datasource#"
			required="false" >
			
		<cfset THIS.datasource = arguments.datasource />
		
		<cfreturn this />
	
	</cffunction>
	
	<cffunction
		name="gettables">
		 
		<cfquery
			name="qTest"
			result="rTest"
			datasource="#THIS.datasource#">
				
			show tables; 
				
		</cfquery>
		
		<cfreturn qTest />
		
	</cffunction>
	
</cfcomponent>