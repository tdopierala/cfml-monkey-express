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
		name="getInstanceFormComments"
		hint="Pobranie komentarzy do pola formularza">

		<cfset myinstance = model("place_instanceform").findByKey(params.key) />
		<cfset mycomments = model("place_instanceformcomment").getComments(instanceformid=params.key) />

	</cffunction>

	<cffunction
		name="actionAdd"
		hint="Zapisanie komentarza">

		<cfset mycomment = model("place_instanceformcomment").New(params) />
		<cfset mycomment.commentcreated = Now() />
		<cfset mycomment.userid = session.userid />
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

		<cfset myuser = model("user").findOne(where="id=#mycomment.userid#") />

	</cffunction>

</cfcomponent>