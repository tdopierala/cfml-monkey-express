<cfcomponent displayname="Kontrahent" output="false" hint="" accessors="true" >
	<cfproperty name="id" type="string" default="" />
	<cfproperty name="dzielnica" type="string" default="" />
	<cfproperty name="internalid" type="string" default="" />
	<cfproperty name="kli_kontrahenciid" type="string" default="" />
	<cfproperty name="kodpocztowy" type="string" default="" />
	<cfproperty name="logo" type="string" default="" />
	<cfproperty name="miejscowosc" type="string" default="" />
	<cfproperty name="nazwa1" type="string" default="" />
	<cfproperty name="nazwa2" type="string" default="" />
	<cfproperty name="nip" type="string" default="" />
	<cfproperty name="nrdomu" type="string" default="" />
	<cfproperty name="nrlokalu" type="string" default="" />
	<cfproperty name="regon" type="string" default="" />
	<cfproperty name="typulicy" type="string" default="" />
	<cfproperty name="ulica" type="string" default="" />
	<cfproperty name="str_logo" type="string" default="" />
	
	<cffunction name="init" output="false" access="public" hint="" returntype="Kontrahent">
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