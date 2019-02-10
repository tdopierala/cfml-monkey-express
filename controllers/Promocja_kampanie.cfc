<cfcomponent displayname="Promocja_kampanie" output="false" extends="Controller" >
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
		<cfset filters(through="loadJs",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="loadJs" output="false" access="public" hint="">
		<cfset APPLICATION.ajaxImportFiles &= ",initPromocja" />
	</cffunction>
	
	<cffunction name="kampanie" output="false" access="public" hint="">
		<cfset kampanie = model("promocja_kampania").pobierzKampanie() />
	</cffunction>
	
	<cffunction name="dodajKampanie" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset var nowaKampania = model("promocja_kampania").dodajKampanie(nazwaKampanii=FORM.NAZWAKAMPANII, dataRozpoczecia=FORM.DATAKAMPANIIOD, dataZakonczenia=FORM.DATAKAMPANIIDO, przewidzianyBudzet=FORM.PRZEWIDZIANYBUDZET, userId = session.user.id) />
			<cflocation url="index.cfm?controller=promocja_kampanie&action=lista-kampanii" addtoken="false" />
		</cfif>
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="edytujListeSklepow" output="false" access="public" hint="">
		<cfset daneKampanii = model("promocja_kampania").pobierzDaneKampanii(URL.idKampanii) />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="listaKampanii" output="false" access="public" hint="">
		<cfset listaKampanii = model("promocja_kampania").pobierzKampanie() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="przypiszSklepyDoKampanii" output="false" access="public" hint="">
		<cfif IsDefined("FORM.FIELDNAMES") and IsDefined("URL.idKampanii")>
			<cfloop list="#FORM.KODSKLEPU#" index="kod" >
				<cfset var sklepKampanii = model("promocja_kampania").dodajSklepDoKampanii(kodSklepu=kod, idKampanii=URL.idKampanii) />
			</cfloop>
			
		</cfif>
			
		<cflocation url="index.cfm?controller=promocja_kampanie&action=lista-sklepow-do-przypisania&idKampanii=#URL.idKampanii#" addtoken="false" />
	</cffunction>
	
	<cffunction name="przypiszTypMaterialuDoKampanii" output="false" access="public" hint="">
		<cfif IsDefined("FORM.FIELDNAMES") and IsDefined("FORM.IDTYPUMATERIALUREKLAMOWEGO") and IsDefined("URL.idKampanii")>
			<cfloop list="#FORM.IDTYPUMATERIALUREKLAMOWEGO#" index="id">
				<cfset var materialKampanii = model("promocja_kampania").dodajTypMaterialuDoKampanii(idKampanii=URL.idKampanii,idTypuMaterialuReklamowego=id) />
			</cfloop>
		</cfif>
		
		<cfif isDefined("URL.idKampanii") and isDefined("URL.idTypuMaterialuReklamowego")>
			<cfset var materialKampanii = model("promocja_kampania").dodajTypMaterialuDoKampanii(idKampanii=URL.idKampanii,idTypuMaterialuReklamowego=URL.idTypuMaterialuReklamowego) />
			<cflocation url="index.cfm?controller=promocja_materialy&action=pobierz-dostepne-materialy-kampanii&idKampanii=#URL.idKampanii#" addtoken="false" />
		</cfif>
		
		<cflocation url="index.cfm?controller=promocja_kampanie&action=edytuj-materialy-kampanii&idKampanii=#URL.idKampanii#" addtoken="false" />
	</cffunction> 
	
	<cffunction name="usunSklepZKampanii" output="false" access="public" hint="">
		<cfif IsDefined("FORM.FIELDNAMES") and IsDefined("URL.idKampanii")>
			<cfloop list="#FORM.USUNSKLEPZKAMPANII#" index="kod">
				<cfset var sklepKampanii = model("promocja_kampania").usunSklepZKampanii(kodSklepu=kod, idKampanii=URL.idKampanii) />
			</cfloop>
		</cfif>
		<cflocation url="index.cfm?controller=promocja_kampanie&action=lista-przypisanych-sklepow&idKampanii=#URL.idKampanii#" addtoken="false" />
	</cffunction>
	
	<cffunction name="listaSklepowDoPrzypisania" output="false" access="public" hint="">
		<cfset listaSklepowDoPrzypisania = model("promocja_kampania").pobierzListeSklepowDoPrzypisania(URL.idKampanii) />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="listaPrzypisanychSklepow" output="false" access="public" hint="">
		<cfset listaPrzypisanychSklepow = model("promocja_kampania").pobierzPrzypisaneSklepyDoKampanii(URL.idKampanii) />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="edytujListeMaterialow" output="false" access="public" hint="">
		<cfset daneKampanii = model("promocja_kampania").pobierzDaneKampanii(URL.idKampanii) />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="edytujMaterialyKampanii" output="false" access="public" hint="">
		<cfset materialyKampanii = model("promocja_kampania").pobierzMaterialyKampanii(URL.idKampanii) />
		<cfset daneKampanii = model("promocja_kampania").pobierzDaneKampanii(URL.idKampanii) />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="materialyKampanii" output="false" access="public" hint="">
		<cfset materialyKampanii = model("promocja_kampania").pobierzMaterialyKampanii(URL.idKampanii) />
		<cfset daneKampanii = model("promocja_kampania").pobierzDaneKampanii(URL.idKampanii) />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="dodajPlikDoMaterialuKampanii" output="false" access="public" hint="">

		<cfif isDefined("FORM.FIELDNAMES")>
			<cfif not directoryExists(expandPath("files/promocja_materialy/#URL.idKampanii#"))>
				<cfset directoryCreate(expandPath("files/promocja_materialy/#URL.idKampanii#")) />
			</cfif>
			
			<cfset src = "files/promocja_materialy/#URL.idKampanii#/#DateFormat(Now(), 'yyyy-mm-dd')#_#TimeFormat(Now(), 'HH-mm-ss')#_" & randomText(length=11) />
			<cffile action="upload" fileField="plikMaterialu" destination="#expandPath('files/promocja_materialy/#URL.idKampanii#')#" nameConflict="MakeUnique" result="zapisanyPlik" />
			<cfset src &= "." & zapisanyPlik["CLIENTFILEEXT"] />
			<cffile action="rename" source="#expandPath('files/promocja_materialy/#URL.idKampanii#')#/#zapisanyPlik['SERVERFILE']#" destination="#expandPath(src)#" />
			
			<cfset plikMaterialu = model("promocja_kampania").dodajPlikDoMaterialuKampanii(idKampanii=URL.idKampanii,idMaterialuKampanii=URL.idMaterialuKampanii,idTypuMaterialuReklamowego=URL.idTypuMaterialuReklamowego,userId=session.user.id,srcMaterialu=src) />
			
		</cfif>
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="zapiszMaterialKampanii" output="false" access="public" hint="">
		<cfif isDefined("FORM.FIELDNAMES")>
			<cfset materialyKampanii = model("promocja_kampania").zapiszMaterialKampanii(idMaterialuKampanii=URL.idMaterialuKampanii,ilosc=FORM.ilosc,cenaJednostkowa=javacast("string", FORM.cenaJednostkowa)) />
		</cfif>
		
		<cfset materialyKampanii = model("promocja_kampania").pobierzMaterialKampanii(URL.idMaterialuKampanii) />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="usunKampanie" output="false" access="public" hint="">
		<cfset var usun = model("promocja_kampania").usunKampanieReklamowa(URL.idKampanii) />
		<cflocation url="index.cfm?controller=promocja_kampanie&action=lista-kampanii" addtoken="false" />
	</cffunction>
	
	<cffunction name="zmienStatus" output="false" access="public" hint="">
		<cfset status = model("promocja_kampania").zmienStatusKampanii(URL.idKampanii) />
		<cflocation url="index.cfm?controller=promocja_kampanie&action=lista-kampanii" addtoken="false" />
	</cffunction>
	
</cfcomponent>