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
		name="index"
		hint="Metoda pobierająca listę użytkowników z uprawnieniami do etapów">

		<cfset users = model("place_stepprivilege").getUsersPrivileges() />

	</cffunction>

	<cffunction
		name="getUserSteps"
		hint="Metoda pobierająca listę etapów (kroków) obiegu nieruchomości i
				generująca tabelkę z listą uprawnień">

		<cfset steps = model("place_stepprivilege").getUserSteps(userid=params.key) />

	</cffunction>

	<cffunction
		name="updateReadPrivilege"
		hint="Aktualizacja uprawnień do odczytu etapu">

		<cfset mycollection = model("place_stepprivilege").findByKey(params.stepprivilegeid) />
		<cfset mycollection.update(
			readprivilege=1-mycollection.readprivilege,
			callbacks=false) />

	</cffunction>

	<cffunction
		name="updateWritePrivilege"
		hint="Aktualizacja uprawnień do zapisu etapu">

		<cfset mycollection = model("place_stepprivilege").findByKey(params.stepprivilegeid) />
		<cfset mycollection.update(
			writeprivilege=1-mycollection.writeprivilege,
			callbacks=false) />

	</cffunction>

	<cffunction
		name="updateAcceptPrivilege"
		hint="Aktualizacja uprawnień do akceptacji etapu">

		<cfset mycollection = model("place_stepprivilege").findByKey(params.stepprivilegeid) />
		<cfset mycollection.update(
			acceptprivilege=1-mycollection.acceptprivilege,
			callbacks=false) />

	</cffunction>

	<cffunction
		name="updateRefusePrivilege"
		hint="Aktualizacja uprawnień do odrzucenia etapu">

		<cfset mycollection = model("place_stepprivilege").findByKey(params.stepprivilegeid) />
		<cfset mycollection.update(
			refuseprivilege=1-mycollection.refuseprivilege,
			callbacks=false) />

	</cffunction>

	<cffunction
		name="updateArchivePrivilege"
		hint="Aktualizacja uprawnień do przeniesienia do archiwum etapu">

		<cfset mycollection = model("place_stepprivilege").findByKey(params.stepprivilegeid) />
		<cfset mycollection.update(
			archiveprivilege=1-mycollection.archiveprivilege,
			callbacks=false) />

	</cffunction>

	<cffunction
		name="updateDeletePrivilege"
		hint="Aktualizacja uprawnień do usunięcia całej nieruchomości">

		<cfset mystep = model("place_stepprivilege").findByKey(params.stepprivilegeid) />
		<cfset mystep.update(
			deleteprivilege=1-mystep.deleteprivilege,
			callbacks=false) />

	</cffunction>

	<cffunction
		name="updateMovePrivilege"
		hint="Aktualizacja uprawnień do przesunięcia nieruchomości na inny etap." >

		<cfset mystep = model("place_stepprivilege").findByKey(params.stepprivilegeid) />
		<cfset mystep.update(
			moveprivilege=1-mystep.moveprivilege,
			callbacks=false) />

	</cffunction>
	
	<cffunction
		name="updateControllingPrivilege"
		hint="Aktualizacja uprawnień do zawieszeni nieruchomości przez Controlling." >

		<cfset mystep = model("place_stepprivilege").findByKey(params.stepprivilegeid) />
		<cfset mystep.update(
			controllingprivilege=1-mystep.controllingprivilege,
			callbacks=false) />
			
		<cfset renderNothing() />

	</cffunction>
	
	<cffunction
		name="updateDtPrivilege"
		hint="Aktualizacja uprawnień do zawieszeni nieruchomości przez Dział techn." >

		<cfset mystep = model("place_stepprivilege").findByKey(params.stepprivilegeid) />
		<cfset mystep.update(
			dtprivilege=1-mystep.dtprivilege,
			callbacks=false) />
			
		<cfset renderNothing() />

	</cffunction>

</cfcomponent>