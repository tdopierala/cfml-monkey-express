<cfcomponent
	extends="Controller"
	output="false">
		
	<cffunction
		name="init">
		
		<cfset super.init() />
		<cfset filters(through="before",type="before") />
		<cfset filters(through="loadJs",type="before") />
		
	</cffunction>
	
	<cffunction
		name="before">
		
		<cfset usesLayout(template="/layout") />
		
	</cffunction>
	
	<cffunction
		name="loadJS">

		<!---
			Dodaje obsługę autozapisywania pól formularza.
		--->
		<cfset APPLICATION.bodyImportFiles &= ",placeTreePrivileges" />

	</cffunction>
	
	<cffunction
		name="index"
		hint="Panel zarządzający uprawnieniami użytkowników - rejonizacją">
			
		<cfset tree = model("Place_tree_privilege").getTree(type="xml") />
			
	</cffunction>
	
	<cffunction
		name="addUser"
		hint="Formularz dodawania użytkownika do rejonizacji">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			
			<!--- Dodaję uzytkownika do drzewa --->
			<cfset myPrivilege = model("Place_tree_privilege").insert(FORM.userid) />
			
		</cfif>
		
		<cfif IsDefined("FORM.userid") AND IsDefined("FORM.provinceid") AND IsDefined("FORM.districtid")>
			
			<!--- Przypisuje domyślny powiat dla użytkownika --->
			<cfset myUserDistrict = model("Place_user_district").new() />
			<cfset myUserDistrict.userid = FORM.userid />
			<cfset myUserDistrict.provinceid = FORM.provinceid />
			<cfset myUserDistrict.districtid = FORM.districtid />
			<cfset myUserDistrict.save(callbacks=false) />

			
		</cfif>
		
		<cfset provinces = model("province").findAll() />
		<cfset usesLayout(false) />
		
	</cffunction>
	
	<cffunction
		name="getDistricts"
		hint="Pobranie powiatów na podstawie województwa">
		
		<cfset json = model("district").getDistricts(
			provinceid = params.key,
			structure = true) />
			
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
	<cffunction
		name="userDistricts"
		hint="Formularz powiatów użytkowników">
		
		<cfset userid = params.key />
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset myUserDistrict = model("Place_user_district").new() />
			<cfset myUserDistrict.userid = FORM.userid />
			<cfset myUserDistrict.provinceid = FORM.provinceid />
			<cfset myUserDistrict.districtid = FORM.districtid />
			<cfset myUserDistrict.save(callbacks=false) />
		</cfif>
		
		<cfset provinces = model("province").findAll() />
		<cfset userDistricts = model("Place_user_district").getUserDistricts(
			userid = params.key) />
		
		<cfset usesLayout(false) />
		
	</cffunction>
	
	<cffunction
		name="remove"
		hint="Usunięcie użytkownika z rejonizacji">
		
		<cfset toRemove = model("place_tree_privilege").remove(params.key) />
		<cfset redirectTo(back=true) />
		
	</cffunction>
	
	<cffunction 
		name="removeUserDistrict"
		hint="Usunięcie powiatu przypisanego do użytkownika">
		
		<cfset myDistrict = model("Place_user_district").deleteByKey(params.key) />
		<cfset renderNothing() />
		
	</cffunction> 
	
	<cffunction
		name="move"
		hint="Przesunięcie użytkownika w strukturze">
	
		<cfset myMove = model("Place_tree_privilege").move(
			my_root = params.my_root,
			new_parent = params.new_parent) />
			
		<cfset json = model("Place_tree_privilege").getTree(structure=true) />
		<cfset renderWith(data="json",template="/json",layout=false) />
	
	</cffunction>
		
</cfcomponent>