<cfcomponent displayname="eleader" output="false" extends="Controller">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="before",type="before") /> 
	</cffunction>
	
	<cffunction name="before" output="false" access="public" hint="">
		<cfsetting requesttimeout="540" />
		
		<cfset usesLayout(template="/layout") />
		<cfset application.ajaxImportFiles &= ",initEleader" />
		
		<cfinvoke method="checkUserTreeGroup" component="controllers.Tree_groupusers" returnvariable="debile">
			<cfinvokeargument name="groupname" value="Departament Kontroli i Nadzoru" />
		</cfinvoke>
		
		<!---<cfif IsDefined("debile") and debile is true>
			<cfset redirectTo(controller="Users",action="view",key=session.user.id) />
		</cfif>--->
		
	</cffunction>
	
	<cffunction name="index" output="false" access="public" hint="">
		<cfset renderNothing() />
	</cffunction>
	
	<!---<cffunction name="aos" output="false" access="public" hint="Prezentowanie głównej tabelki z AOS z posiomu KOSa">
		<cfsetting requesttimeout="3600" />
		<cfparam name="interval" type="numeric" default="2" />
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="centrala">
			<cfinvokeargument name="groupname" value="Centrala" />
		</cfinvoke>
		
		<cfif centrala is false>
			<cfset redirectTo(controller="users",action="view",key=session.user.id) />
		</cfif>
		
		<cfif IsDefined("session.eleader.interval")>
			<cfset interval = session.eleader.interval />
		</cfif>
		
		<cfif IsDefined("FORM.INTERVAL")>
			<cfset interval = FORM.INTERVAL />
		</cfif>
		
		<cfset session.eleader.interval = interval />
		
		<cfset listaKos = application.cfc.eleader.listaKos() />
		<cfset listaZagadnien = application.cfc.eleader.listaZagadnien() />
		<cfset ccount = application.cfc.eleader.definicjeZadanColumnCount() />
		<cfset ostatniArkusz = application.cfc.eleader.ostatniArkusz() />
		
		<cfset wersjeZadan = application.cfc.eleader.wersjeZadan() />
		<cfset wszystkieZagadnienia = application.cfc.eleader.listaWszystkichZagadnien() />
			
		<cfset structListaZagadnien = {} />
		<cfloop query="listaZagadnien">
			<cfset structListaZagadnien[iddefinicjizadania]['nazwazadania'] = nazwazadania />
			<cfset structListaZagadnien[iddefinicjizadania]['iloscpunktow'] = sum />
			<cfset structListaZagadnien[iddefinicjizadania]['wersja'] = wersja />
		</cfloop>
			
		<cfset structListaZagadnienWersjami = {} />
		<cfloop query="wersjeZadan">
			<cfset structListaZagadnienWersjami[numer] = {} />
			<cfset tmpNumer = numer /> 
			<cfloop query="wszystkieZagadnienia">
				<cfif tmpNumer EQ wersja>
					<cfset structListaZagadnienWersjami[tmpNumer][nazwazadania] = sum />
				</cfif>
			</cfloop>
		</cfloop>
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset usesLayout(false) />
		</cfif>
	</cffunction>--->
	
	<cffunction name="aos" output="false" access="public" hint="">
		
		<cfsetting requesttimeout="3600" />
		<cfparam name="interval" type="numeric" default="2" />
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="centrala">
			<cfinvokeargument name="groupname" value="Centrala" />
		</cfinvoke>
		
		<cfif centrala is false>
			<cfset redirectTo(controller="users",action="view",key=session.user.id) />
		</cfif>
		
		<cfif IsDefined("session.eleader.interval")>
			<cfset interval = session.eleader.interval />
		</cfif>
		
		<cfif IsDefined("FORM.INTERVAL")>
			<cfset interval = FORM.INTERVAL />
		</cfif>
		
		<cfset session.eleader.interval = interval />
		
		<!--- Pobranie danych widocznych w widoku --->
		<cfset listaKos = application.cfc.eleader.listaKos() />
		<cfset ccount = application.cfc.eleader.definicjeZadanColumnCount() />
		<cfset ostatniArkusz = application.cfc.eleader.ostatniArkusz() />
		
		<cfset listaZagadnien = application.cfc.eleader.listaZagadnien() />
		<cfset iloscOdwolan = application.cfc.eleader.iloscOdwolan(interval) />
		
		<cfset wersjeZadan = application.cfc.eleader.wersjeZadan() />
		<cfset wszystkieZagadnienia = application.cfc.eleader.listaWszystkichZagadnien() />
			
		<cfset structListaZagadnien = {} />
		<cfloop query="listaZagadnien">
			<cfset structListaZagadnien[iddefinicjizadania]['nazwazadania'] = nazwazadania />
			<cfset structListaZagadnien[iddefinicjizadania]['iloscpunktow'] = sum />
			<cfset structListaZagadnien[iddefinicjizadania]['wersja'] = wersja />
		</cfloop>
			
		<cfset structListaZagadnienWersjami = {} />
		<cfloop query="wersjeZadan">
			<cfset structListaZagadnienWersjami[numer] = {} />
			<cfset tmpNumer = numer /> 
			<cfloop query="wszystkieZagadnienia">
				<cfif tmpNumer EQ wersja>
					<cfset structListaZagadnienWersjami[tmpNumer][nazwazadania] = sum />
				</cfif>
			</cfloop>
		</cfloop>
			
		<cfset structIloscOdwolan = {} />
		<cfloop query="iloscOdwolan" >
			<cfset structIloscOdwolan["#kodsklepu#"] = iloscodwolan />
		</cfloop>
		
		<!---<cfdump var="#wszystkieZagadnienia#" label="wszystkie zagadnienia" />
		<cfabort />--->
		
	</cffunction>
	
	<cffunction name="aosSklepu" output="false" access="public" hint="">
		<cfparam name="aosSklepuOd" type="string" default="" />
		<cfparam name="aosSklepuDo" type="string" default="" />
		<cfparam name="kosEmail" type="string" default="" />
		<cfparam name="odwolania" type="numeric" default="1" />
		<cfparam name="sklep" type="string" default="" />
		<cfparam name="wersja" type="numeric" default="#application.cfc.eleader.pobierzMaxWersjaZadan()#" />
		<cfparam name="maxWersja" type="numeric" default="#application.cfc.eleader.pobierzMaxWersjaZadan()#" />
		
		<!--- 
			Pobranie filtra z sesji 
		--->
		<cfif IsDefined("session.aosSklepu.aosSklepuOd")>
			<cfset aosSklepuOd = session.aosSklepu.aosSklepuOd />
		</cfif>
		
		<cfif IsDefined("session.aosSklepu.aosSklepuDo")>
			<cfset aosSklepuDo = session.aosSklepu.aosSklepuDo />
		</cfif>
		
		<cfif IsDefined("session.aosSklepu.kosEmail")>
			<cfset kosEmail = session.aosSklepu.kosEmail />
		</cfif>
		
		<cfif IsDefined("session.aosSklepu.odwolania")>
			<cfset odwolania = session.aosSklepu.odwolania />
		</cfif>
		
		<cfif IsDefined("session.aosSklepu.sklep")>
			<cfset sklep = session.aosSklepu.sklep />
		</cfif>
		
		<cfif IsDefined("session.aosSklepu.wersja")>
			<cfset wersja = session.aosSklepu.wersja />
		</cfif>
		
		<!---
			Pobranie filtra z formularza
		--->
		<cfif IsDefined("FORM.AOSSKLEPUOD")>
			<cfset aosSklepuOd = FORM.AOSSKLEPUOD />
		</cfif>
		
		<cfif IsDefined("FORM.AOSSKLEPUDO")>
			<cfset aosSklepuDo = FORM.AOSSKLEPUDO />
		</cfif>
		
		<cfif IsDefined("FORM.KOSEMAIL")>
			<cfset kosEmail = FORM.KOSEMAIL />
		</cfif>
		
		<cfif IsDefined("FORM.ODWOLANIA")>
			<cfset odwolania = FORM.ODWOLANIA />
		</cfif>
		
		<cfif IsDefined("FORM.SKLEP")>
			<cfset sklep = FORM.SKLEP />
		</cfif>
		
		<cfif IsDefined("FORM.WERSJA")>
			<cfset wersja = FORM.WERSJA />
		</cfif>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="kosU">
			<cfinvokeargument name="groupname" value="KOS" />
		</cfinvoke>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
			<cfinvokeargument name="groupname" value="Partner prowadzacy sklep" />
		</cfinvoke>
		
		<cfif pps is true>
			<cfset redirectTo(controller="Users",action="view",key=session.user.id) />
		</cfif>
		
		<cfif kosU is true>
			<cfset kosEmail = session.user.mail />
		</cfif>
		
		<cftry>
		
			<cfset kos = model("tree_groupuser").getUsersByGroupName("KOS") />
			<cfset ccount = application.cfc.eleader.definicjeZadanColumnCount(wersja = wersja) />
			<cfset listaZagadnien = application.cfc.eleader.listaZagadnien(wersja = wersja) />
			<cfset arkuszeDlaSprzedazy = application.cfc.eleader.aosSklepu(
				aosSklepuOd = aosSklepuOd,
				aosSklepuDo = aosSklepuDo,
				kosEmail = kosEmail,
				odwolania = odwolania,
				sklep = sklep,
				wersja = wersja) />
			
			<cfset structListaZagadnien = {} />
			<cfloop query="listaZagadnien">
				<cfset structListaZagadnien[iddefinicjizadania]['nazwazadania'] = nazwazadania />
				<cfset structListaZagadnien[iddefinicjizadania]['iloscpunktow'] = sum />
			</cfloop>
			
			<cfset session.aosSklepu = {
				aosSklepuOd = aosSklepuOd,
				aosSklepuDo = aosSklepuDo,
				kosEmail = kosEmail,
				odwolania = odwolania,
				sklep = sklep,
				wersja = wersja,
				maxWersja = maxWersja
			} />
			
			<cfcatch type="any">
				<cfmail to="admin@monkey.xyz" from="INTRANET <intranet@monkey.xyz>" replyto="intranet@monkey.xyz" subject="AOS dla DS" type="html"> 
					<cfdump var="#CFCATCH#" />
				</cfmail>
			</cfcatch>
		
		</cftry>
		
		<cfif IsDefined("URL.t") and URL.t is true>
			<cfset usesLayout(false) />
		</cfif>
		
	</cffunction>
	
	<cffunction name="aosSklepuV2" output="false" access="public" hint="">
		
		<cfparam name="aosSklepuOd" type="string" default="" />
		<cfparam name="aosSklepuDo" type="string" default="" />
		<cfparam name="kosEmail" type="string" default="" />
		<cfparam name="odwolania" type="numeric" default="1" />
		<cfparam name="sklep" type="string" default="" />
		
		<!--- 
			Pobranie filtra z sesji 
		--->
		<cfif IsDefined("session.aosSklepu.aosSklepuOd")>
			<cfset aosSklepuOd = session.aosSklepu.aosSklepuOd />
		</cfif>
		
		<cfif IsDefined("session.aosSklepu.aosSklepuDo")>
			<cfset aosSklepuDo = session.aosSklepu.aosSklepuDo />
		</cfif>
		
		<cfif IsDefined("session.aosSklepu.kosEmail")>
			<cfset kosEmail = session.aosSklepu.kosEmail />
		</cfif>
		
		<cfif IsDefined("session.aosSklepu.odwolania")>
			<cfset odwolania = session.aosSklepu.odwolania />
		</cfif>
		
		<cfif IsDefined("session.aosSklepu.sklep")>
			<cfset sklep = session.aosSklepu.sklep />
		</cfif>
		
		<!---
			Pobranie filtra z formularza
		--->
		<cfif IsDefined("FORM.AOSSKLEPUOD")>
			<cfset aosSklepuOd = FORM.AOSSKLEPUOD />
		</cfif>
		
		<cfif IsDefined("FORM.AOSSKLEPUDO")>
			<cfset aosSklepuDo = FORM.AOSSKLEPUDO />
		</cfif>
		
		<cfif IsDefined("FORM.KOSEMAIL")>
			<cfset kosEmail = FORM.KOSEMAIL />
		</cfif>
		
		<cfif IsDefined("FORM.ODWOLANIA")>
			<cfset odwolania = FORM.ODWOLANIA />
		</cfif>
		
		<cfif IsDefined("FORM.SKLEP")>
			<cfset sklep = FORM.SKLEP />
		</cfif>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="kosU">
			<cfinvokeargument name="groupname" value="KOS" />
		</cfinvoke>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
			<cfinvokeargument name="groupname" value="Partner prowadzacy sklep" />
		</cfinvoke>
		
		<cfif kosU is true>
			<cfset kosEmail = session.user.mail />
		</cfif>

		<cfset kos = model("tree_groupuser").getUsersByGroupName("KOS") />
		
		<cfif pps is true>
			<cfset arkusze = application.cfc.eleader.arkuszeSklepuV2(
				numerSklepu = session.user.login,
				aosSklepuOd = aosSklepuOd,
				aosSklepuDo = aosSklepuDo,
				odwolania = odwolania) />
		<cfelse>
			<cfset arkusze = application.cfc.eleader.arkuszeSklepuV2(
				numerSklepu = sklep,
				aosSklepuOd = aosSklepuOd,
				aosSklepuDo = aosSklepuDo,
				kosEmail = kosEmail,
				odwolania = odwolania) />
		</cfif>
		
		<cfset session.aosSklepu = {
				aosSklepuOd = aosSklepuOd,
				aosSklepuDo = aosSklepuDo,
				kosEmail = kosEmail,
				odwolania = odwolania,
				sklep = sklep
			} />
		
	</cffunction>
	
	<cffunction name="sklepyKos" output="false" access="public" hint="Pobieram listę sklepów danego KOSa">
		<cfsetting requesttimeout="3600" />
		
		<cfparam name="interval" type="numeric" default="2" />
		
		<cfif IsDefined("session.eleader.interval")>
			<cfset interval = session.eleader.interval />
		</cfif>
		
		<cfif IsDefined("FORM.INTERVAL")>
			<cfset interval = FORM.INTERVAL />
		</cfif>
		
		<cfset session.eleader.interval = interval />
		
		<cfif IsDefined("params.email")>
			<cfset ccount = application.cfc.eleader.definicjeZadanColumnCount() />
			
			<cfset sklepyKosa = application.cfc.eleader.sklepyKosa(email=params.email,interval=interval) />
			<cfset sklepyKosaIntranet = application.cfc.eleader.sklepyKosaIntranet(params.email) />
			
			<cfset ostatniaKontrolaDkin = application.cfc.eleader.pobierzOstatniaKontroleNaSklepie(sklep="%",email="%monkey.xyz",kos=params.email) />
			<cfset ostatniaKontrolaKos = application.cfc.eleader.pobierzOstatniaKontroleNaSklepie(sklep="%",email="%monkey.xyz",kos=params.email) />
			
			<cfset listaZagadnien = application.cfc.eleader.listaZagadnien() />
			<cfset iloscOdwolan = application.cfc.eleader.iloscOdwolan(interval) />
		
			<cfset wersjeZadan = application.cfc.eleader.wersjeZadan() />
			<cfset wszystkieZagadnienia = application.cfc.eleader.listaWszystkichZagadnien() />
			
			<cfset structListaZagadnien = {} />
			<cfloop query="listaZagadnien">
				<cfset structListaZagadnien[iddefinicjizadania]['nazwazadania'] = nazwazadania />
				<cfset structListaZagadnien[iddefinicjizadania]['iloscpunktow'] = sum />
				<cfset structListaZagadnien[iddefinicjizadania]['wersja'] = wersja />
			</cfloop>
			
			<cfset structListaZagadnienWersjami = {} />
			<cfloop query="wersjeZadan">
				<cfset structListaZagadnienWersjami[numer] = {} />
				<cfset tmpNumer = numer /> 
				<cfloop query="wszystkieZagadnienia">
					<cfif tmpNumer EQ wersja>
						<cfset structListaZagadnienWersjami[tmpNumer][nazwazadania] = sum />
					</cfif>
				</cfloop>
			</cfloop>
			
			<cfset structIloscOdwolan = {} />
			<cfloop query="iloscOdwolan" >
				<cfset structIloscOdwolan["#kodsklepu#"] = iloscodwolan />
			</cfloop>
		</cfif>
		
		<cfset usesLayout(false) />
		
	</cffunction>
	
	<cffunction name="arkuszeSklepu" output="false" hint="Pobieram listę arkuszy wypełnionych na danym sklepie">
		<cfparam name="interval" type="numeric" default="2" />
		
		<cfif IsDefined("session.eleader.interval")>
			<cfset interval = session.eleader.interval />
		</cfif>
		
		<cfif IsDefined("FORM.INTERVAL")>
			<cfset interval = FORM.INTERVAL />
		</cfif>
		
		<cfset session.eleader.interval = interval />
		
		<cfif IsDefined("params.sklep")>
			<cfset ccount = application.cfc.eleader.definicjeZadanColumnCount() />
			<cfset listaZagadnien = application.cfc.eleader.listaZagadnien() />
			<cfset punktacjaAktywnosciSklepu = application.cfc.eleader.punktacjaAktywnosci(sklep = params.sklep, interval=interval) />
			<cfset odwolaniaPoAktywnosci = application.cfc.eleader.iloscOdwolanPoAktywnosci(interval) />
			
			<!---<cfdump var="#punktacjaAktywnosciSklepu#" label="punktacja aktywności sklepu" />
			<cfabort />--->
			
			<!---<cfdump var="#listaZagadnien#" label="lista zagadnien" />
			<cfabort />--->
			
			<cfset wersjeZadan = application.cfc.eleader.maxWersjeZadan() />
			<cfset wszystkieZagadnienia = application.cfc.eleader.listaWszystkichZagadnien() />
			
			<cfset structListaZagadnien = {} />
			<cfloop query="listaZagadnien">
				<cfset structListaZagadnien[iddefinicjizadania]['nazwazadania'] = nazwazadania />
				<cfset structListaZagadnien[iddefinicjizadania]['iloscpunktow'] = sum />
				<cfset structListaZagadnien[iddefinicjizadania]['wersja'] = wersja />
			</cfloop>
			
			<cfset structListaZagadnienWersjami = {} />
			<cfloop query="wersjeZadan">
				<cfset structListaZagadnienWersjami[numer] = {} />
				<cfset tmpNumer = numer /> 
				<cfloop query="wszystkieZagadnienia">
					<cfif tmpNumer EQ wersja>
						<cfset structListaZagadnienWersjami[tmpNumer][nazwazadania] = sum />
					</cfif>
				</cfloop>
			</cfloop>
			
			<!---<cfdump var="#structListaZagadnienWersjami#" label="lista zagadnien wersjami" />
			<cfabort />--->
			
			<!--- Zamieniam odwołania na strukturę --->
			<cfset structOdwolaniaPoAktywnosci = {} />
			<cfloop query="odwolaniaPoAktywnosci">
				<cfset structOdwolaniaPoAktywnosci[idaktywnosci] = iloscodwolan />
			</cfloop>
		</cfif>
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="odpowiedziArkusza" output="false" access="public" hint="Pobieranie odpowiedzi do wskazanego arkusza">
		<cfif IsDefined("params.idaktywnosci")>
			<cfset ccount = application.cfc.eleader.definicjeZadanColumnCount() />
			<cfset listaZagadnien = application.cfc.eleader.listaZagadnien() />
			<cfset odpowiedzi = application.cfc.eleader.pobierzOdpowiedziArkusza(params.idaktywnosci) />
			<cfset notatka = model("note_note").pobierzNotatkeDoArkusza(sklep = odpowiedzi.kodsklepu, datakontroli = odpowiedzi.poczatekaktywnosci) />
			
			<cfset structListaZagadnien = {} />
			<cfloop query="listaZagadnien">
				<cfset structListaZagadnien[iddefinicjizadania]['nazwazadania'] = nazwazadania />
				<cfset structListaZagadnien[iddefinicjizadania]['iloscpunktow'] = sum />
			</cfloop>
		</cfif>
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="zagadnieniaArkuszaV2" output="false" access="public" hint="">
		<cfset zagadnienia = queryNew("id") />
		<cfset idaktywnosci = "" />
		<cfif IsDefined("params.idaktywnosci")>
			<cfset zagadnienia = application.cfc.eleader.zgadnieniaArkuszaV2(params.idaktywnosci) />
			<cfset idaktywnosci = params.idaktywnosci />
		</cfif>
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="odpowiedziZagadnieniaV2" output="false" access="public" hint="">
		<cfset odpowiedzi = queryNew("id") />
		<cfif isDefined("params.idaktywnosci") and isDefined("params.idzadania")>
			<cfset odpowiedzi = application.cfc.eleader.odpowiedziZagadnieniaV2(idaktywnosci = params.idaktywnosci, idzadania = params.idzadania) />
		</cfif>
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="wszystkieOdpowiedziArkusza" output="false" access="public" hint="Pobranie wszystkich odpowiedzi do wskazanego arkusza">
		<cfif IsDefined("URL.idaktywnosci")>
			<cfset ccount = application.cfc.eleader.definicjeZadanColumnCount(URL.idaktywnosci) />
			<cfset listaZagadnien = application.cfc.eleader.listaZagadnien(URL.idaktywnosci) />
			<cfset odpowiedzi = application.cfc.eleader.pobierzOdpowiedziArkusza(params.idaktywnosci) />
			<cfset notatka = model("note_note").pobierzNotatkeDoArkusza(sklep = odpowiedzi.kodsklepu, datakontroli = odpowiedzi.poczatekaktywnosci) />
			
			<cfset wersjeZadan = application.cfc.eleader.wersjeZadan() />
			<cfset wszystkieZagadnienia = application.cfc.eleader.listaWszystkichZagadnien() />
			
			<cfset structListaZagadnien = {} />
			<cfloop query="listaZagadnien">
				<cfset structListaZagadnien[iddefinicjizadania]['nazwazadania'] = nazwazadania />
				<cfset structListaZagadnien[iddefinicjizadania]['iloscpunktow'] = sum />
				<cfset structListaZagadnien[iddefinicjizadania]['wersja'] = wersja />
			</cfloop>
			
			<cfset structListaZagadnienWersjami = {} />
			<cfloop query="wersjeZadan">
				<cfset structListaZagadnienWersjami[numer] = {} />
				<cfset tmpNumer = numer /> 
				<cfloop query="wszystkieZagadnienia">
					<cfif tmpNumer EQ wersja>
						<cfset structListaZagadnienWersjami[tmpNumer][nazwazadania] = sum />
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="pps" output="false" access="public" hint="Wypełnione arkusze AOS danego sklepu">
		<cfparam name="kodsklepu" type="string" default="" />
		<cfparam name="interval" type="numeric" default="2" />
		
		<!---
			Sprawdzam, czy jestem PPS. Jak tak to pokazuje tylko jego sklepy.
			Jak nie jestem PPS to pokazuje filtr ze sklepami do wyboru.
			
			Najpierw tworzę informacje do filtra.
		--->
		<cfif IsDefined("session.eleader.kodsklepu")>
			<cfset kodsklepu = session.eleader.kodsklepu />
		</cfif>
		
		<cfif IsDefined("FORM.KODSKLEPU")>
			<cfset kodsklepu = FORM.KODSKLEPU />
		</cfif>
		
		<cfif IsDefined("session.eleader.interval")>
			<cfset interval = session.eleader.interval />
		</cfif>
		
		<cfif IsDefined("FORM.INTERVAL")>
			<cfset interval = FORM.INTERVAL />
		</cfif>
		
		<cfset session.eleader = {
			kodsklepu = kodsklepu,
			interval = interval
		} />
		
		<cfinvoke method="checkUserTreeGroup" component="controllers.Tree_groupusers" returnvariable="uprawnieniaPps">
			<cfinvokeargument name="groupname" value="Partner prowadzacy sklep" />
		</cfinvoke>
		
		<cfif uprawnieniaPps is true>
			<cfset sklep = model("store_store").getStoreByProject(session.user.login) />
			<cfset punktacjaAktywnosci = application.cfc.eleader.punktacjaAktywnosci(sklep=session.user.login,interval=interval) />
		<cfelse>
			<cfset punktacjaAktywnosci = application.cfc.eleader.punktacjaAktywnosci(sklep=kodsklepu,interval=interval) />
		</cfif>
		
		<cfset listaZagadnien = application.cfc.eleader.listaZagadnien() />
		
		<cfset structListaZagadnien = {} />
		<cfloop query="listaZagadnien">
			<cfset structListaZagadnien[iddefinicjizadania]['nazwazadania'] = nazwazadania />
			<cfset structListaZagadnien[iddefinicjizadania]['iloscpunktow'] = sum />
		</cfloop>
		
		<cfset ccount = application.cfc.eleader.definicjeZadanColumnCount() />
		
		<cfif IsDefined("URL.t") and URL.t is true>
			<cfset usesLayout(false) />
		</cfif>
	</cffunction>
	
	<cffunction name="dodajOdwolanie" output="false" access="public" hint="Dodawanie odwołania przez PPS od pytania">
		<cfif IsDefined("FORM.FIELDNAMES")>
			<!--- Ustawiam parametry do formularza --->
			<cfset parametryFormularza = structNew() />
			<cfset parametryFormularza.idaktywnosci = FORM.IDAKTYWNOSCI />
			<cfset parametryFormularza.iddefinicjizadania = FORM.IDDEFINICJIZADANIA />
			<cfset parametryFormularza.iddefinicjipola = FORM.IDDEFINICJIPOLA />
			<cfset parametryFormularza.kodsklepu = FORM.KODSKLEPU />
			
			<cfset odwolanie = application.cfc.eleader.pobierzOdwolanieDoPytania(FORM) />
			<cfif odwolanie.recordCount GT 0>
				<cfset zgloszenieOdwolania = "są odwołania" />
			</cfif>
			
			<!--- Sprawdzam czy przesłano treść odwołania --->
			<cfif IsDefined("FORM.trescodwolania")>
				<cfset noweOdwolanie = application.cfc.eleader.dodajOdwolanie(FORM) />
				<cfset dodajHistorieOdwolan = application.cfc.eleader.dodajHistorieOdwolanAos(noweOdwolanie) />
				<cfset komunikat = true />
			</cfif>
		</cfif>

		<cfset usesLayout(false) />
	</cffunction> 
	
	<cffunction name="pobierzZdjecie" output="false" access="public" hint="">
		<cfargument name="idaktywnosci" type="string" required="true" />
		<cfargument name="idpola" type="string" required="true" />
		<cfargument name="idzadania" type="string" required="true" />
		
		<cfset zdjecie = application.cfc.eleader.pobierzZdjecie(
			idaktywnosci = arguments.idaktywnosci,
			iddefinicjipola = arguments.idpola,
			iddefinicjizadania = arguments.idzadania) />

		<cfreturn zdjecie />
	</cffunction>
	
	<cffunction name="pobierzOdwolanie" output="false" access="public" hint="">
		<cfif IsDefined("URL.idaktywnosci")>
			<cfset odwolania = application.cfc.eleader.pobierzOdwolaniePoIdAktywnosci(URL.idaktywnosci) />
		</cfif>
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="acceptAppeal" output="false" access="public" hint="">
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset o = application.cfc.eleader.akceptacjaOdwolania(id=FORM.IDODWOLANIA,userid=session.user.id,uzasadnienie=FORM.UZASADNIENIE) />
			<cflocation url="index.cfm?controller=eleader&action=appeal&id=#FORM.IDODWOLANIA#" addtoken="false" />
		</cfif>
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="declineAppeal" output="false" access="public" hint="">
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset o = application.cfc.eleader.odrzucenieOdwolania(id=FORM.IDODWOLANIA,userid=session.user.id,uzasadnienie=FORM.UZASADNIENIE) />
			<cflocation url="index.cfm?controller=eleader&action=appeal&id=#FORM.IDODWOLANIA#" addtoken="false" />
		</cfif>
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="appeal" output="false" access="public" hint="">
		<cfif isDefined("URL.id")>
			<cfset odwolanie = application.cfc.eleader.pobierzOdwolanie(URL.id) />
		</cfif>
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="tmp">
		<cfset application.cfc.eleader.przygotujTabele() />
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="raportAosSklepu" output="false" access="public" hint="">
		<cfparam name="aosSklepuOd" type="string" default="" />
		<cfparam name="aosSklepuDo" type="string" default="" />
		<cfparam name="kosEmail" type="string" default="" />
		<cfparam name="odwolania" type="numeric" default="1" />
		<cfparam name="sklep" type="string" default="" />
		
		<!--- 
			Pobranie filtra z sesji 
		--->
		<cfif IsDefined("session.aosSklepu.aosSklepuOd")>
			<cfset aosSklepuOd = session.aosSklepu.aosSklepuOd />
		</cfif>
		
		<cfif IsDefined("session.aosSklepu.aosSklepuDo")>
			<cfset aosSklepuDo = session.aosSklepu.aosSklepuDo />
		</cfif>
		
		<cfif IsDefined("session.aosSklepu.kosEmail")>
			<cfset kosEmail = session.aosSklepu.kosEmail />
		</cfif>
		
		<cfif IsDefined("session.aosSklepu.odwolania")>
			<cfset odwolania = session.aosSklepu.odwolania />
		</cfif>
		
		<cfif IsDefined("session.aosSklepu.sklep")>
			<cfset sklep = session.aosSklepu.sklep />
		</cfif>
		
		<!---
			Pobranie filtra z formularza
		--->
		<cfif IsDefined("FORM.AOSSKLEPUOD")>
			<cfset aosSklepuOd = FORM.AOSSKLEPUOD />
		</cfif>
		
		<cfif IsDefined("FORM.AOSSKLEPUDO")>
			<cfset aosSklepuDo = FORM.AOSSKLEPUDO />
		</cfif>
		
		<cfif IsDefined("FORM.KOSEMAIL")>
			<cfset kosEmail = FORM.KOSEMAIL />
		</cfif>
		
		<cfif IsDefined("FORM.ODWOLANIA")>
			<cfset odwolania = FORM.ODWOLANIA />
		</cfif>
		
		<cfif IsDefined("FORM.SKLEP")>
			<cfset sklep = FORM.SKLEP />
		</cfif>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="kosU">
			<cfinvokeargument name="groupname" value="KOS" />
		</cfinvoke>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
			<cfinvokeargument name="groupname" value="Partner prowadzacy sklep" />
		</cfinvoke>
		
		<cfif pps is true>
			<cfset redirectTo(controller="Users",action="view",key=session.user.id) />
		</cfif>
		
		<cfif kosU is true>
			<cfset kosEmail = session.user.mail />
		</cfif>
		
		<cfset ccount = application.cfc.eleader.definicjeZadanColumnCount() />
		<cfset listaZagadnien = application.cfc.eleader.listaZagadnien() />
		<cfset arkuszeDlaSprzedazy = application.cfc.eleader.aosSklepu(
			aosSklepuOd = aosSklepuOd,
			aosSklepuDo = aosSklepuDo,
			kosEmail = kosEmail,
			odwolania = odwolania,
			sklep = sklep) />
		
		<cfset structListaZagadnien = {} />
		<cfloop query="listaZagadnien">
			<cfset structListaZagadnien[iddefinicjizadania]['nazwazadania'] = nazwazadania />
			<cfset structListaZagadnien[iddefinicjizadania]['iloscpunktow'] = sum />
		</cfloop>
		
	</cffunction>
	
</cfcomponent>