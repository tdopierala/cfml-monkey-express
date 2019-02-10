<cfcomponent displayname="ftpActions" output="false" hint="">
	
	<cfproperty name="ftpObj" type="ftp" default="" />
	<cfproperty name="status" type="struct" default={} />
	<cfproperty name="connection" type="any" default="" />
	
	<!--- PSEUDO-CONSTRUCTOR --->
	<cfscript>
		variables = {
			ftpObj = "",
			status = {},
			connection = ""
		};
	</cfscript>
	
	<cffunction name="init" output="false" access="public" returntype="ftpActions">
		<cfargument name="obj" type="ftp" required="true" />
		
		<cfscript>
			setFtpObj(arguments.obj);
		</cfscript>
	
		<cfreturn this />
	</cffunction>
	
	<!--- SETTERS --->
	<cffunction name="setFtpObj" output="false" access="public" hint="" returntype="void">
		<cfargument name="obj" type="ftp" required="true" />
		<cfset variables.ftpObj = arguments.obj />
	</cffunction>
	
	<cffunction name="setStatus" output="false" access="public" hint="" returntype="void">
		<cfargument name="status" type="struct" required="true" />
		<cfset variables.status = arguments.status /> 
	</cffunction>
	
	<cffunction name="setConnection" output="false" access="public" returntype="void">
		<cfargument name="connection" type="any" required="true" />
		<cfset variables.connection = arguments.connection />
	</cffunction>
	
	<!--- GETTERS --->
	<cffunction name="getStatus" output="false" access="public" hint="" returntype="Struct" >
		<cfreturn variables.status />
	</cffunction>
	
	<cffunction name="getFtpObj" output="false" access="public" hint="" returntype="ftp">
		<cfreturn variables.ftpObj />
	</cffunction>
	
	<cffunction name="getConnection" output="false" access="public" hint="" returntype="any">
		<cfreturn variables.connection />
	</cffunction>
	
	<!--- METHODS --->
	<cffunction name="connect" output="false" access="public" hint="" returntype="ftpActions">
		<cfftp action="open" username="#variables.ftpObj.getUsr()#" connection="variables.connection" password="#variables.ftpObj.getPasswd()#" server="#variables.ftpObj.getHst()#" stopOnError="Yes" timeout="3600" passive="true" />
		
		<cfscript>
			setStatus(cfftp);
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="close" output="false" access="public" hint="" returntype="ftpActions">
		<cfftp action="close" connection="variables.connection" stopOnError="Yes" />
		
		<cfscript>
			setStatus({});
			setConnection({});
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="listDirectory" output="false" access="public" hint="" returntype="query">
		<cfargument name="dir" type="string" required="false" />
		
		<cfsetting requesttimeout="3600" />
		
		<cfif not isStruct(variables.connection) or
			structIsEmpty(variables.connection) >
		
			<cfscript>
				connect();
			</cfscript>
		
		</cfif>
		
		<cfset var dirQuery = "" />
		
		<cfif isDefined("arguments.dir")>
			<cfftp action="LISTDIR" stopOnError="false" name="dirQuery" directory = "#arguments.dir#" connection = "variables.connection" timeout="3600" passive="true" />
		<cfelse>
			<cfftp action="getcurrentdir" connection="variables.connection" timeout="3600" passive="true" />
			<cfftp action="LISTDIR" stopOnError="false" name="dirQuery" directory = "#cfftp.ReturnValue#" connection = "variables.connection" timeout="3600" passive="true" />
		</cfif>
		
		<cfscript>
			setStatus(cfftp);
		</cfscript>
	
		<cfreturn dirQuery />
	</cffunction>
	
	<cffunction name="changeDirectory" output="false" access="public" hint="" returntype="ftpActions">
		<cfargument name="dir" type="string" required="false" default="/" />
		
		<cfif not isStruct(variables.connection) or
			structIsEmpty(variables.connection) >
		
			<cfscript>
				connect();
			</cfscript>
		
		</cfif>
		
		<cfftp action="existsdir" directory="#arguments.dir#" connection="variables.connection" timeout="3600" passive="true" />

		<cfif cfftp.ReturnValue EQ "NO">
			<cfftp connection="variables.connection" action="createDir" directory="#arguments.dir#" failIfExists="false" timeout="3600" passive="true" />
		</cfif>
		
		<cfftp action="changedir" directory="#arguments.dir#" connection="variables.connection" stoponerror="false" timeout="3600" passive="true" />
		
		<cfscript>
			setStatus(cfftp);
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getFile" output="false" access="public" hint="" returntype="ftpActions">
		<cfargument name="fileName" type="string" required="true" />
		<cfargument name="path" type="string" required="false" default="ftp" />
		
		<cfsetting requesttimeout="3600" />
		
		<cfif not isStruct(variables.connection) or
			structIsEmpty(variables.connection) >
		
			<cfscript>
				connect();
			</cfscript>
		
		</cfif>
		
		<cfset var ftpResult = "" />
		
		<cfftp action="getcurrentdir" connection="variables.connection" timeout="3600" passive="true" />
		<cfftp action="getfile" username="#variables.ftpObj.getUsr()#" connection="variables.connection" password="#variables.ftpObj.getPasswd()#" server="#variables.ftpObj.getHst()#" failIfExists="false" stoponerror="false" remotefile="#cfftp.ReturnValue#/#arguments.fileName#" localfile="#expandPath('#arguments.path#')#/#arguments.fileName#" timeout="3600" passive="true" />
		
		<cfscript>
			setStatus(cfftp);
		</cfscript>
			
		<cfreturn this />
	</cffunction>
	
	<cffunction name="removeFile" output="false" access="public" hint="" returntype="ftpActions">
		<cfargument name="fileName" type="string" required="true" />
		
		<cfif not isStruct(variables.connection) or
			structIsEmpty(variables.connection) >
		
			<cfscript>
				connect();
			</cfscript>
		
		</cfif>
		
		<cfif structKeyExists(variables.status, "Succeeded") AND this.getStatus().Succeeded EQ "YES">
			<cfftp action="getcurrentdir" connection="variables.connection" passive="true" />
			<cfftp action="remove" username="#variables.ftpObj.getUsr()#" connection="variables.connection" password="#variables.ftpObj.getPasswd()#" server="#variables.ftpObj.getHst()#" stoponerror="false" item="#cfftp.ReturnValue#/#arguments.fileName#" passive="true" />
		</cfif>
		
		<cfscript>
			setStatus(cfftp);
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="putFile" output="false" access="public" hint="" returnType="ftpActions">
		<cfargument name="sourceFile" type="string" required="true" />
		<cfargument name="targetFile" type="string" required="true" />
		
		<cfif not isStruct(variables.connection) or
			structIsEmpty(variables.connection) >
		
			<cfscript>
				connect();
			</cfscript>
		</cfif>
		
		<cfif structKeyExists(variables.status, "Succeeded") AND this.getStatus().Succeeded EQ "YES">
			<cfftp action="getcurrentdir" connection="variables.connection" passive="true" />
			<cfftp connection="variables.connection" action="putfile" localfile="#arguments.sourceFile#" remotefile="#arguments.targetFile#" transfermode="auto" timeout="3600" passive="true" /> 
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="createDirectory" output="false" access="public" hint="" returntype="ftpActions">
		<cfargument name="directoryName" type="string" required="true" />
		
		<cfif not isStruct(variables.connection) or
			structIsEmpty(variables.connection) >
		
			<cfscript>
				connect();
			</cfscript>
		
		</cfif>
		
		<cfif structKeyExists(variables.status, "Succeeded") AND this.getStatus().Succeeded EQ "YES">
			<cfftp action="getcurrentdir" connection="variables.connection" passive="true" />
			<cfftp connection="variables.connection" action="createDir" directory="#cfftp.ReturnValue#/#arguments.directoryName#" failIfExists="false" passive="true" />
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="bakFile" output="false" access="public" hint="" returntype="ftpActions">
		<cfargument name="fileName" type="string" required="true" />
		
		<cfif not isStruct(variables.connection) or
			structIsEmpty(variables.connection) >
		
			<cfscript>
				connect();
			</cfscript>
		
		</cfif>
		
		<cfif structKeyExists(variables.status, "Succeeded") AND this.getStatus().Succeeded EQ "YES">
			<cfftp action="getcurrentdir" connection="variables.connection" passive="true" />
			<cfftp action="rename" existing="#cfftp.ReturnValue#/#arguments.fileName#" new="#cfftp.ReturnValue#/#arguments.fileName#.bak" username="#variables.ftpObj.getUsr()#" connection="variables.connection" password="#variables.ftpObj.getPasswd()#" server="#variables.ftpObj.getHst()#" stoponerror="false" passive="true" />
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="moveFile" output="false" access="public" hint="" returntype="ftpActions">
		<cfargument name="fileName" type="string" required="false" />
		<cfargument name="sourceDir" type="string" required="false" />
		<cfargument name="destinationDir" type="string" required="false" />
		
		<cfif not isStruct( variables.connection ) or structIsEmpty( variables.connection )>
			<cfscript>
				connect();
			</cfscript>
		</cfif>
		
		<cfftp action="rename" existing="#arguments.sourceDir#/#arguments.fileName#" new="#arguments.destinationDir#/#fileName#" connection="variables.connection" stoponerror="false" passive="true" />
		
		<cfreturn this />
	</cffunction>
	
</cfcomponent>