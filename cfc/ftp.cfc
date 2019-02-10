<cfcomponent displayname="ftp" output="false" hint="">
	
	<cfproperty name="usr" type="string" default="" />
	<cfproperty name="passwd" type="string" default="" />
	<cfproperty name="prt" type="string" default="21" />
	<cfproperty name="hst" type="string" default="" />
	
	<!--- PSEUDO-CONSTRUCTOR --->
	<cfscript>
		variables = {
			usr = "",
			passwd = "",
			prt = "21",
			hst = ""
		};
	</cfscript>
	
	<cffunction name="init" output="false" access="public" hint="" returntype="ftp">
		<cfargument name="usr" type="string" required="false" default="" />
		<cfargument name="passwd" type="string" required="false" default="" />
		<cfargument name="prt" type="string" required="false" default="" />
		<cfargument name="hst" type="string" required="false" default="" />
		
		<cfscript>
			setUsr(arguments.usr);
			setPasswd(arguments.passwd);
			setPrt(arguments.prt);
			setHst(arguments.hst);
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setUsr" output="false" access="public" hint="" returntype="void">
		<cfargument name="usr" type="string" required="true" />
		<cfset variables.usr = arguments.usr />
	</cffunction>
	
	<cffunction name="setPasswd" output="false" access="public" hint="" returntype="void">
		<cfargument name="passwd" type="string" required="true" />
		<cfset variables.passwd = arguments.passwd />
	</cffunction>
	
	<cffunction name="setPrt" output="false" access="public" hint="" returntype="void">
		<cfargument name="prt" type="string" required="true" />
		<cfset variables.prt = arguments.prt />
	</cffunction>
	
	<cffunction name="setHst" output="false" access="public" hint="" returntype="void">
		<cfargument name="hst" type="string" required="true" />
		<cfset variables.hst = arguments.hst />
	</cffunction>
	
	<cffunction name="getUsr" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.usr />
	</cffunction>
	
	<cffunction name="getPasswd" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.passwd />
	</cffunction>
	
	<cffunction name="getPrt" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.prt />
	</cffunction>
	
	<cffunction name="getHst" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.hst />
	</cffunction>
	
</cfcomponent>