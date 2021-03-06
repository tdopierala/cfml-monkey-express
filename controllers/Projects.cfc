<cfcomponent
	extends="mc">

	<cffunction
		name="init">
	
		<cfset super.init() />
	
	</cffunction>
	
	<cffunction
		name="index"
		output="false" >
	
	</cffunction>
	
	<!---
		07.12.2012
		Aktualizacja danych użytkownika potrzebnych do integracji z Redmine.
		Użytkownik podaje swój ApiKey oraz swoje ID w Redmine.
	--->
	<cffunction
		name="updateUser"
		output="false"  >
	
		<cfset myuser = model("user").findByKey(session.userid) />
		<cfset myuser.update(
			redmineapikey	=	params.redmineapikey,
			redmineid		=	params.redmineid,
			callbacks		=	false) />
			
		<cfset session.user.redmineapikey	=	params.redmineapikey />
		<cfset session.user.redmineid		=	params.redmineid />
			
		<cfset redirectTo(back=true) />
	
	</cffunction> 
		
</cfcomponent>