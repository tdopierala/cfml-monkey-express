<cfcomponent 
	displaynme="user"
	output="false" 
	accessors="true" 
	hint="" >
	
	<cfproperty name="id" type="numeric" /> 
	<cfproperty name="givenname" type="string" />
	<cfproperty name="sn" type="string" />
	<cfproperty name="email" type="string" />
	<cfproperty name="login" type="string" />
	<cfproperty name="photo" type="string" />
	
	<cffunction name="init" output="false" access="public" hint="" returntype="user">
		
		<cfloop item="local.property" collection="#arguments#">
			<cfif structKeyExists(this, "set#local.property#")>
				<cfinvoke component="#this#" method="set#local.property#">
					<cfinvokeargument name="#local.property#" value="#arguments[local.property]#" />
				</cfinvoke>
			</cfif>
		</cfloop>
		
		<cfreturn this /> 
	</cffunction> 
	
</cfcomponent>