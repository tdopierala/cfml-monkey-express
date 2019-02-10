<cfcomponent displayname="AtrybutDokumentu" output="false" accessors="true" >
	
	<cfproperty name="id" type="string" default="" />
	<cfproperty name="documentattributeid" type="numeric" default="0" />
	<cfproperty name="documentid" type="numeric" default="0" />
	<cfproperty name="documentattributetextvalue" type="string" default="" />
	<cfproperty name="attributeid" type="numeric" default="0" />
	<cfproperty name="documentinstanceid" type="numeric" default="0" />
	
	<cffunction name="init" output="false" access="public" hint="" returntype="AtrybutDokumentu">
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