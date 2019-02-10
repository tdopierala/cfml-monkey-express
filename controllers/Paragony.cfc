<cfcomponent extends="Controller" output="false">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		
		<cfset filters(through="before",type="before") />
	</cffunction>
	
	<cffunction name="before" output="false" access="public" hint="">
		<cfset usesLayout(template="/layout") />
	</cffunction>
	
	<cffunction name="index" output="false" access="public" hint="Lista dodanych paragonów">
		<cfset adresySklepow = model("paragon_adres").pobierzAdresy(session.user.id) />
		<cfif adresySklepow.recordCount EQ 0>
			<cfset redirectTo(controller="Paragony",action="dodajAdres") />
		<cfelse>
			<cfset redirectTo(controller="Paragony",action="dodajParagon") />
		</cfif>
		
	</cffunction>
	
	<cffunction name="dodajAdres" output="false" access="public" hint="Dodanie nowego adresu sklepu konkurencji">
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset nowyAdres = model("paragon_adres").new() />
			<cfset nowyAdres.userid = session.user.id />
			<cfset nowyAdres.miasto = FORM.MIASTO />
			<cfset nowyAdres.nazwasklepu = FORM.NAZWASKLEPU />
			<cfset nowyAdres.adres = FORM.ADRES />
			<cfset nowyAdres.save(callbacks=false) />
			
			<cfset redirectTo(controller="Paragony",action="dodajParagon",params="t=1") />
		</cfif>
		
		<cfif IsDefined("url.t")>
			<cfset usesLayout(false) />
		</cfif>
	</cffunction>
	
	<cffunction name="dodajParagon" output="false" access="public" hint="Zapisanie paragonu">
		<cfset adresy = model("paragon_adres").pobierzAdresy(session.user.id) />
		<cfif adresy.recordCount EQ 0>
			<cfset redirectTo(controller="Paragony",action="DodajAdres",params="t=1") />
		</cfif>
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset tmp = ListToArray(FORM.DATAPARAGONU, "/") />
			<cfset myDate = CreateDate(tmp[3], tmp[2], tmp[1]) />
			
			<cfset nowyParagon = model("paragon_paragon").new() />
			<cfset nowyParagon.adresid = FORM.adresid />
			<cfset nowyParagon.userid = session.user.id />
			<cfset nowyParagon.dataParagonu = myDate />
			<cfset nowyParagon.iloscklientow = FORM.iloscklientow />
			<cfset nowyParagon.save(callbacks=false) />
			
			<cfset komunikat = true />
			
			<cfset usesLayout(false) />
		</cfif>
		
		<cfif IsDefined("url.t")>
			<cfset usesLayout(false) />
		</cfif>
	</cffunction>
	
	<cffunction name="raport" output="false" access="public" hint="Raport dla DS z paragonów">
		<cfparam name="days" type="numeric" default="3" />
		
		<cfif IsDefined("session.paragony.days")>
			<cfset days = session.paragony.days />
		</cfif>
		
		<cfif IsDefined("FORM.DAYS")>
			<cfset days = FORM.DAYS />
		</cfif>
		
		<cfset session.paragony = {
			days = days
		} />
		
		<cfset raport = model("paragon_paragon").pobierzRaport(days) />
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset usesLayout(false) />
		</cfif>
	</cffunction>
	
	<cffunction name="xls" output="false" access="public" hint="Eksport do pliku Excel">
		
		<cfparam name="days" type="numeric" default="3" />
		
		<cfif IsDefined("session.paragony.days")>
			<cfset days = session.paragony.days />
		</cfif>
		
		<cfset raport = model("paragon_paragon").pobierzRaport(days) />
		
		<cfset xlsObj = spreadsheetNew("Paragony") />
		<cfset spreadsheetAddRow(xlsObj, "DATA_PARAGONU,ILOSCKLIENTOW,MIASTO,ADRES,NAZWASKLEPU,GIVENNAME,SN,LOGIN") />
		<cfset spreadsheetAddRows(xlsObj, raport) />
			
		<cfcontent type="application/msexcel">
		<cfheader name="content-disposition" value="inline; filename=Raport_paragonow[#DateFormat(Now(), 'yyyy-mm-dd')#].xls">
		<cfcontent type="application/msexcel" variable="#spreadsheetReadBinary(xlsObj)#" reset="true">


	</cffunction>
</cfcomponent>