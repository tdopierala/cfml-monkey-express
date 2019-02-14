		<!---
				Sprawdzam czy są zdefiniowane uprawnienia do modułu nieruchomości.
				Jeżeli ich nie ma to zapisuje je w sesji.
			--->

		<cfif not StructKeyExists(session, "placestepprivileges")>
			<cfset session.placestepprivileges = model("place_stepprivilege").getUserSteps(userid=session.userid,structure=true) />
		</cfif>
			
		<cfif not StructKeyExists(session, "placeformprivileges")>
			<cfset session.placeformprivileges = model("place_formprivilege").getUserForms(userid=session.userid,structure=true) />
		</cfif>
			
		<cfif not StructKeyExists(session, "placecollectionprivileges")>
			<cfset session.placecollectionprivileges = model("place_collectionprivilege").getUserCollections(userid=session.userid,structure=true) />
		</cfif>
			
		<cfif not StructKeyExists(session, "placephototypeprivileges")>
			<cfset session.placephototypeprivileges = model("place_phototypeprivilege").getUserPhotoTypes(userid=session.userid,structure=true) />
		</cfif>
			
		<cfif not StructKeyExists(session, "placefiletypeprivileges")>
			<cfset session.placefiletypeprivileges = model("place_filetypeprivilege").getUserFileTypes(userid=session.userid,structure=true) />
		</cfif>
			
		<cfif not structKeyExists(session, "placereportprivileges")>
			<cfset session.placereportprivileges = model("place_reportprivilege").getUserReports(
					userid=session.userid,
					structure=true) />
		</cfif>