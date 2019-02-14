<cfcomponent extends="abstract_component_intranet" displayname="SmsApi">

	<cfproperty name="api_key" type="string" required="true" />
	
	<cfproperty name="dopietApiKey" type="string" default="e10adc3949ba59abbe56e057f20f883e" />
	<cfproperty name="dopietUsername" type="string" default="dopiet" />
	<cfproperty name="dopietPassword" type="string" default="e10adc3949ba59abbe56e057f20f883e" />
	
	<cfset this.dopietApiKey = "e10adc3949ba59abbe56e057f20f883e" />
	<cfset this.dopietUsername = "dopiet" />
	<cfset this.dopietPassword = "e10adc3949ba59abbe56e057f20f883e" />

	<cfset THIS.api_key		= "70ad466a26ba6b58c29e7048bc6322d1" />
	<cfset THIS.username 	= 'dopiet' />
	<cfset THIS.password 	= 'c43fa80865d60730ebbc3720ae7c57e9' />
	
	<cfset title="Monkey (#get('loc').intranet.directory#)" />
	
	<cffunction name="init">
		<cfset super.init() />
		<!--- <cfset filters(through="afterRender",type="after") /> --->
	</cffunction>
	
	<cffunction name="receive" output="false" access="public" hint="Metoda wywoływana po otrzymaniu prze SMSAPI wiadomości SMS.">
		
		<cftry>
			<cfif true>
				
				<cfif StructKeyExists(params, "sms_from") and StructKeyExists(params, "sms_text") and StructKeyExists(params, "sms_date")>
					
					<!--- 
						Zadaniem tej metody jest przeparsowanie wiadomości SMS 
						i wysłanie stosownego komunikatu.
						
						Treść przesłanego SMSa znajduje się w sms_text.
						
						Na tym etapie, trzeba się zastanowić, jak wyodrębnić
						różne szablony wiadomości SMS.
						
						Szablon 1. 99999,GODZINA,PALETY 
					--->

					<cfset parsedSms = ListToArray(params.sms_text, ",.", false) />
					
					<!---
						Przeparsowany SMS z szablonu 1:
						[1] - numer sklepu bez C na początku
						[2] - godzina dostawy
						[3] - liczba palet
					--->
					
					<!--- Sprawdzam, czy ten numer może wysłać wiadomość --->
					<cfif not model("sms_sender_number").ifNumberExists( params.sms_from, 1 )>
						<cfthrow type="NumberException" message="Numer nie istnieje w bazie." />
					</cfif>
					
					<cfset storeProjekt = "C" & parsedSms[1] /> <!--- Tworzę numer sklepu --->
					
					<cfset sms_date = dateAdd("s", params.sms_date, createDateTime(1970, 1, 1, 0, 0, 0)) /> <!--- Po co to jest? --->
					<cfset sms_date = Now() />
					
					<cfset sms = model("Sms_notice").new() /> <!--- Tworzę instancję wiadomości SMS w Intranecie --->
					<cfset sms.sms_from	= params.sms_from />
					<cfset sms.store	= storeProjekt />
					<cfset sms.sms_text	= params.sms_text />
					<cfset sms.sms_date	= sms_date />
					<cfset sms.status	= 0 />
					<cfset sms.save() />
					
					<cfset smsid = sms.id />
					
					<!--- Wyszukuje numer ajenta, na który mam wysłać sms --->
					<cfset store = model("Store").findOne(where="projekt='#storeProjekt#' AND is_active = 1") />
					
					<cfif IsObject(store) and IsStruct(store) and Len(store.telefonkom)>
						
						<cfset mobile = onlyChars(store.telefonkom) />
						<cfset msg = "Przewidziana godzina dostawy " & Insert(":", parsedSms[2], 2) & ". Ilosc palet: " & parsedSms[3] />
						
						<!--- Wysłanie sms do PPS ---> 
						<cfhttp
							url="http://api.smsapi.pl/sms.do?username=#THIS.username#&password=#THIS.password#&to=#mobile#&from=INTRANET&eco=0&message=#msg#"
							resolveurl="Yes"
							throwOnError="No"
							result="status"
							timeout="60" > 
						</cfhttp>
						
						<cfmail
							to="intranet@monkey.xyz"
							from="SMS - Monkey<intranet@monkey.xyz>"
							replyto="#get('loc').intranet.email#"
							subject="SMS #status.Filecontent#"
							type="html">
							
							<cfdump var="#status#" />
							<cfdump var="#sms#" />
						
						</cfmail>
						
						<!--- Parsuje odpowiedź z serwera --->
						<cfset result = ListToArray(status.Filecontent, ':', false, true) />
						
						<!--- Aktualizuje informacje o smsie o status z serwera --->
						<cfif ArrayLen(result) eq 3>
							
							<cfset sms = model("sms_notice").findByKey(smsid) />
							
							<cfset sms.update(
								status	= 1,
								sms_id	= result[2],
								sms_err	= 1,
								sms_points= result[3]
							)/>
							
						<!--- Status błędu ma tylko 2 pola --->
						<cfelseif ArrayLen(result) EQ 2>
							
							<cfset sms = model("sms_notice").findByKey(smsid) />
							<cfset sms.update( sms_err = result[2] )/>
						
						<!--- Błąd SmsApi, brak ustalonego komunikatu --->
						<cfelse>
						
							<cfset sms = model("sms_notice").findByKey(smsid) />
							<cfset sms.update( sms_err = status.Filecontent )/>
						
						</cfif>
					
					<cfelse>
						
						<!---<!--- SMS zwrotny do dostawcy o błędnym sms'ie --->
						<cfset msg = 'Bledny numer sklepu lub format sms. Prawidlowy format np.: C12000,Tresc wiadomosci' />
						<cfset mobile = params.sms_from />
						
						<cfhttp
							url="http://api.smsapi.pl/sms.do?username=#THIS.username#&password=#THIS.password#&to=#mobile#&from=INTRANET&eco=0&message=#msg#"
							resolveurl="Yes"
							throwOnError="No"
							result="status"
							timeout="60" > 
						</cfhttp>--->
						
						<cfmail
							to="intranet@monkey.xyz"
							from="SMS - Monkey<intranet@monkey.xyz>"
							replyto="#get('loc').intranet.email#"
							subject="Błędny numer sklepu przy próbie wysłania SMS"
							type="html">
								
								<cfdump var="#store#" />
								<cfdump var="#sms#" />
								
								<cfoutput>Błędny numer sklepu lub format wiadomości.</cfoutput>
								
						</cfmail>
						
					</cfif>
				
				</cfif>
				
			</cfif>
			
			<cfset response = "OK" />
			
			<cfcatch type="NumberException">
				<cfmail
					to="intranet@monkey.xyz"
					from="BŁĄD - Monkey<intranet@monkey.xyz>"
					subject="#cfcatch.message#"
					type="html">
					
						<cfdump var="#cfcatch#" />
					
				</cfmail>
				
				<cfset response = "OK" />
				<cfset renderWith(data=response,layout=false, template="/text") />
			</cfcatch>
			
			<cfcatch type="any">
				
				<cfset response = cfcatch.message />
				<cfmail
					to="intranet@monkey.xyz"
					from="BŁĄD - Monkey<intranet@monkey.xyz>"
					subject="#cfcatch.message#"
					type="html">
					
						<cfdump var="#cfcatch#" />
						<cfdump var="#session#" />
						<cfif isDefined("Request")>
							<cfdump var="#Request#" />
						</cfif>
					
				</cfmail>
				
			</cfcatch>
			
		</cftry>
		
		<cfset renderWith(data=response,layout=false, template="/text") />
		
	</cffunction>
	
	<cffunction name="callback" output="false" access="public" hint="Metoda aktualizująca status wysłanej wiadomości SMS">
<!---		
		<cfmail from="intranet@monkey.xyz" subject="smsapi" to="admin@monkey.xyz" type="html">
			<cfdump var="#URL#" />
			<cfdump var="#params#" />
		</cfmail>--->
		
		<cftry>
			<!---
			<cfif IsDefined("Url.sms_id") and IsDefined("Url.api_key")>
				<cfset var smsId = ListToArray(Url.sms_id) />
				<cfset var smsReportCode = ListToArray(Url.sms_status) />
				<cfset var smsReportDate = ListToArray(Url.sms_date) />
				
				<cfloop array="#smsId#" index="sId" >
					<cfset currentSms = model("sms").pobierzSms(smsId[sId]) />
					<cfif currentSms.RecordCount EQ 1>
						<cfset aktualizujSms = model("sms").aktualizujStatus(smsId = smsId[sId], smsReportCode = smsReportCode[sId], smsReportDate = smsReportDate[sId]) />
					</cfif>
				</cfloop>
				
			</cfif>
			--->
			
			
			<cfif true>
			
				<cfif StructKeyExists(params, "sms_id") and StructKeyExists(params, "sms_status") and StructKeyExists(params, "sms_date")>
					
					<cfset sid = ListToArray(params.sms_id) />
					<cfset sstatus = ListToArray(params.sms_status) />
					<cfset srdate = ListToArray(params.sms_date) />
					
					<cfloop index="idx" from="1" to="#ArrayLen(sid)#">
						
						<cfset sms1 = model("sms_notice").findOne(where="sms_id=#sid[idx]#") />
						<cfset sms2 = model("sms").findOne(where="sms_id=#sid[idx]#") />
						
						<cfif IsObject(sms1)>
						
							<cfset sms1.update(
								status		= 2,
								sms_err		= sstatus[idx],
								report_date	= dateAdd("s", srdate[idx], createDateTime(1970, 1, 1, 0, 0, 0))
							)/>
						
						<cfelseif IsObject(sms2)>
							
							<cfset sms2.update(sms_report_code = sstatus[idx], sms_report_date = dateAdd("s", srdate[idx], createDateTime(1970, 1, 1, 0, 0, 0))) />
							
						<cfelse>
							
						</cfif>
						
					</cfloop>
				
				</cfif>
			
			</cfif>
			
			<cfset response = "OK" />
			
			<cfcatch>
				
				<cfset response = cfcatch.message />
				<cfmail
					to="intranet@monkey.xyz"
					from="BŁĄD - Monkey<intranet@monkey.xyz>"
					replyto="intranet@monkey.xyz"
					subject="#cfcatch.message#"
					type="html">
					
					<cfdump var="#cfcatch#" />
					<cfdump var="#session#" />
					<cfif isDefined("Request")>
						<cfdump var="#Request#" />
					</cfif>
					
				</cfmail>
				
			</cfcatch>
		</cftry>
		
		<cfset renderWith(data=response,layout=false, template="/text") />
		
	</cffunction>
	
	<!--- PRIVATE --->
	
	<cffunction
		name="onlyChars"
		hint="Metoda usuwająca Wszystkie znaki inne niż litery i cyfry."
		description="Metoda widoczna we wszystkich kontrolerach. Pozostawia tylko litery i cyfry."
		returnType="string"
		access="private">

		<cfargument name="text" type="string" default="" required="true" />

		<cfset loc.text = arguments.text />

		<cfset loc.text = ReplaceNoCase(loc.text, " ", "", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "+", "", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "-", "", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "(", "", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, ")", "", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "/", "", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "\", "", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "_", "", "all") />

		<cfreturn loc.text />

	</cffunction>

</cfcomponent>