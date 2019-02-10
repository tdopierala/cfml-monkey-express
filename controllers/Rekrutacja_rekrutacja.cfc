<cfcomponent displayname="Rekrutacja_rekrutacja" output="false" hint="" extends="Controller">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
		<cfset filters(through="loadJs",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="loadJs" output="false" access="public" hint="">
		<cfset APPLICATION.ajaxImportFiles &= ",initRekrutacja" />
	</cffunction>
	
	<cffunction name="formularze" output="false" access="public" hint="">
		<cfset formularze = model("rekrutacja_formularz").pobierzFormularze() />
	</cffunction>
	
	<cffunction name="nowyFormularz" output="false" access="public" hint="">
		<cfset nowyFormularz = model("rekrutacja_formularz").nowyFormularz(session.user.id) />
		<cfset ankietyFormularza = model("rekrutacja_ankieta").noweAnkietyFormularza(nowyFormularz) />
		<cfset polaFormularza = model("rekrutacja_formularz").pobierzPolaFormularza(nowyFormularz) />
		<cfset idFormularza = nowyFormularz />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="listaKandydatow" output="false" access="public" hint="">
		<cfset uzytkownicy = model("user_user").pobierzAktywnychUzytkownikow() />
		<cfset formularze = model("rekrutacja_formularz").pobierzFormularze() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="edytujFormularz" output="false" access="public" hint="">
		<cfset polaFormularza = queryNew("id") />
		<cfset idFormularza = "" />
		<cfif isDefined("URL.idFormularza")>
			<cfset polaFormularza = model("rekrutacja_formularz").pobierzPolaFormularza(URL.idFormularza) />
			<cfset idFormularza = URL.idFormularza />
		</cfif>
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="ankiety" output="false" access="public" hint="">
		<cfset ankietyFormularza = model("rekrutacja_ankieta").pobierzAnkietyFormularza(URL.idFormularza) />
		<cfset wartosciPol = model("rekrutacja_formularz").pobierzWartosciPol() />
		<cfset idFormularza = URL.idFormularza />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="zapiszAnkiete" output="false" access="public" hint="">
		<cfset ankietyFormularza = structNew() />
		<cfset idFormularza = FORM.idFormularza />
		<cfset wartosciPol = model("rekrutacja_formularz").pobierzWartosciPol() />
		
		<cfif isDefined("FORM.FIELDNAMES")>
			<cfloop list="#FORM.FIELDNAMES#" index="field" >
				<cfif FindNoCase("IDWARTOSCIANKIETY-", field) NEQ 0>
					<cfset var tmpPole = listToArray(field, "-") />
					<cfset var wartoscPola = FORM["#field#"] />
					<cfset var zapisanePole = model("rekrutacja_ankieta").zapiszPole(idWartosciAnkiety = tmpPole[2], wartoscPola = wartoscPola) />
				</cfif>
			</cfloop>
			
			<cfset ankietyFormularza = model("rekrutacja_ankieta").pobierzAnkiete(FORM.idAnkiety) />
		</cfif> 
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="zapiszFormularz" output="false" access="public" hint="">
		
		<cfset polaFormularza = queryNew("id") />
		<cfset idFormularza = FORM.idFormularza />
		<cfset wartosciPol = model("rekrutacja_formularz").pobierzWartosciPol() />
		
		<cfif IsDefined("FORM.FIELDNAMES") >
			<cfloop list="#FORM.FIELDNAMES#" index="field">
				<cfif FindNoCase("IDWARTOSCIFORMULARZA-", field) NEQ 0>
					<cfset var tmpPole = listToArray(field, "-") />
					<cfset var wartoscPola = FORM["#field#"] />
					<cfset var zapisanePole = model("rekrutacja_formularz").zapiszPole(idWartosciFormularza = tmpPole[2], wartoscPola = wartoscPola) />
				</cfif>
			</cfloop>
			
			<cfset polaFormularza = model("rekrutacja_formularz").pobierzPolaFormularza(idFormularza) />
		</cfif>
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="plikiFormularza" output="false" access="public" hint="" >
		<cfset plikiFormularza = model("rekrutacja_plik").plikiFormularza(URL.idFormularza) />
		<cfset idFormularza = URL.idFormularza />
		<cfset typyPlikow = model("rekrutacja_plik").pobierzTypyPlikow() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="pobierzPlikiKategorii" output="false" access="public" hint="">
		<cfset pliki = model("rekrutacja_plik").plikiKategorii(idFormularza = URL.idFormularza, idTypuPliku = URL.idTypuPliku) />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="dodajPlik" output="false" access="public" hint="">
		<cfif isDefined("FORM.FIELDNAMES")>
			<cfset var fileToUpload = createObject("component", "cfc.upload2").init(
					directory = "rekrutacja_pliki",
					maxSize = 3145728) />
					
			<cfset var fileResult = fileToUpload.uploadFile("formFile") />
			
			<cfset var plikFormularza = model("rekrutacja_plik").dodajPlik(idFormularza = FORM.idFormularza, idTypuPliku = FORM.idTypuPliku, userId = session.user.id, katalogPliku = fileResult.SERVERDIRECTORY, nazwaPliku = fileResult.NEWSERVERNAME) />
		</cfif>
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="raporty" output="false" access="public" hint="" >
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="podsumowanieFormularza" output="false" access="public" hint="" >
		<cfset formularz = model("rekrutacja_formularz").pobierzPolaFormularza(URL.idFormularza) />
		<cfset ankiety = model("rekrutacja_ankieta").pobierzAnkietyFormularza(URL.idFormularza) />
		
		<cfset usesLayout(false) />
	</cffunction>
	
</cfcomponent>