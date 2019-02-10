<cfcomponent
	extends="Controller">

	<cffunction
		name="init">

		<cfset super.init() />
		<cfset filters(through="privilege") />

	</cffunction>

	<cffunction
		name="privilege"
		hint="Nadanie uprawnień do nieruchomości">

		<!---<cfif not StructKeyExists(session, "placestepprivileges") OR
			not StructKeyExists(session, "placeformprivileges") OR
			not StructKeyExists(session, "placecollectionprivileges") OR
			not StructKeyExists(session, "placephototypeprivileges") OR
			not StructKeyExists(session, "placefiletypeprivileges") OR
			not StructKeyExists(session, "placereportprivileges")>

			<cfset super.modulePlacePrivileges() />

		</cfif>--->

	</cffunction>

	<cffunction
		name="actionAdd"
		hint="Dodanie nowego komentarza">

		<cfset mycomment = model("place_collectioninstancecomment").New(params) />
		<cfset mycomment.userid = session.userid />
		<cfset mycomment.commentcreated = Now() />
		<cfset mycomment.save(callbacks=false) />

		<!---
			7.01.2013
			Wysyłanie maila do właściciela nieruchomości z informacją o komentarzu.
		--->
		<cfset myinstance = model("place_instance").findOne(where="id=#mycomment.instanceid#") />
		<cfset myuser = model("user").findOne(where="id=#myinstance.userid#") />
		<cfset mail = model("email").commentNotification(
			instance=myinstance,
			comment=mycomment.comment,
			user=myuser) />
		<!---
			Koniec wysyłania maila do właściciela nieruchomości.
		--->

		<cfset myuser = model("user").findByKey(mycomment.userid) />

	</cffunction>

</cfcomponent>