<cfcomponent displayname="Rekrutacja_raporty" output="false" hint="" extends="Controller" >
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
	</cffunction>
	
	<cffunction name="raportZaproszonych" output="false" access="public" hint="">
		<cfset raport = model("rekrutacja_raport").raportZaproszonych() />
		<cfset uzytkownicy = model("user_user").listaWszystkichUzytkownikow() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="raportRozmow" output="false" access="public" hint="">
		<cfset raport = model("rekrutacja_raport").raportZaproszonych() />
		<cfset uzytkownicy = model("user_user").listaWszystkichUzytkownikow() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="raportZainteresowanych" output="false" access="public" hint="">
		<cfset raport = model("rekrutacja_raport").raportZainteresowanych() />
		<cfset uzytkownicy = model("user_user").listaWszystkichUzytkownikow() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="raportRezygnacji" output="false" access="public" hint="" >
		<cfset raport = model("rekrutacja_raport").raportZainteresowanych() />
		<cfset uzytkownicy = model("user_user").listaWszystkichUzytkownikow() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="raportSzkolenie" output="false" access="public" hint="">
		<cfset raport = model("rekrutacja_raport").raportSzkolenie() />
		<cfset uzytkownicy = model("user_user").listaWszystkichUzytkownikow() />
		<cfset usesLayout(false) />
	</cffunction>
</cfcomponent>