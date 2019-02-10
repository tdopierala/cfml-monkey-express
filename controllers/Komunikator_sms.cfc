<cfcomponent displayname="Komunikator_sms" output="false" extends="Controller">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="" returntype="void">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="wyslij" output="false" access="public" hint="">
		<cfif isDefined("FORM.FIELDNAMES")>
			<cfset tablicaNumerow = arrayNew(1) />
			<cfset var tmpNumerTel = "" />
			<cfloop list="#FORM.LISTAODBIORCOW#" index="i" delimiters="," >
				<cfset var tmpStruct = {telefon=Trim(onlyChars(text=i)),nazwa=""} />
				<cfset arrayAppend(tablicaNumerow, tmpStruct) />
			</cfloop>
			
			<cfif IsDefined("FORM.GRUPYUZYTKOWNIKOW")>
				<cfloop list="#FORM.GRUPYUZYTKOWNIKOW#" index="j" delimiters=",">
					<cfset var tmpGroup = j />
					<cfset var daneKontaktowe = queryNew("id") />
					
					<cfswitch expression="#tmpGroup#" >
						
						<cfcase value="sklepy" >
							<cfset daneKontaktowe = model("store_store").pobierzDaneKontaktowePps() />
						</cfcase>
						
						<cfcase value="kos">
							
						</cfcase>
					</cfswitch>
					
					<cfloop query="daneKontaktowe">
						<cfset var tmpStructGrupy = {telefon=onlyChars(text=daneKontaktowe.telefonkom),nazwa=daneKontaktowe.nazwaajenta} />
						<cfset arrayAppend(tablicaNumerow, tmpStructGrupy) />
					</cfloop>
					
				</cfloop>
			</cfif>
			
			<cfset trescWiadomosci = "#FORM.TRESCWIADOMOSCI#" />
			
			<!---
				Tutaj odbywa się wysyłka wiadomości SMS
			--->

			<cfthread action="run" name="komunikatorSms" priority="NORMAL">
				
				<cfloop array="#tablicaNumerow#" index="odbiorca" >
					
					<cftry>
					
					<cfset sms = model("sms").new() />
					<cfset sms.sms_to = odbiorca["telefon"] />
					<cfset sms.sms_text = "#trescWiadomosci#" />
					<cfset sms.sms_created = Now() />
					<cfset sms.sms_typ_wiadomosci = 2 />
					<cfset sms.save(callbacks=false) />
					
					<cfhttp url="https://ssl.smsapi.pl/sms.do?username=#Application.sms.username#&password=#Application.sms.password#&to=#odbiorca['telefon']#&message=#trescWiadomosci#" resolveurl="Yes" throwOnError="No" result="statusSms" timeout="60" > 
					</cfhttp>
					
					<cfset response = ListToArray(statusSms.Filecontent, ':', false, true) />
					<cfif ArrayLen(response) eq 3>

						<cfset mysms = model("sms").findByKey(sms.id) />
						<cfset mysms.sms_status = response[1] />
						<cfset mysms.sms_id = response[2] />
						<cfset mysms.sms_points = response[3] />
						<cfset mysms.save(callbacks=false) />

					<!---
						Status błędu ma tylko 2 pola
					--->
					<cfelseif ArrayLen(response) EQ 2>
	
						<cfset mysms = model("sms").findByKey(sms.id) />
						<cfset mysms.sms_status = response[1] />
						<cfset mysms.sms_id = response[2] />
						<cfset mysms.save(callbacks=false) />
					
					<cfelse>
						
						<cfset mysms = model("sms").findByKey(sms.id) />
						<cfset mysms.sms_status =  status.Filecontent/>
						<cfset mysms.save(callbacks=false) />
						
					</cfif>
					
					<cfcatch type="any">
						<cfmail from="intranet.monkey" subject="smsapi" to="admin@monkey" type="html" >
							<cfdump var="#cfcatch#" />
							<cfdump var="#response#" />
						</cfmail>
					</cfcatch>
					
					</cftry>
					
				</cfloop>
			
			</cfthread>
			
			<cfset results = structNew() />
			<cfset results.success = true />
			<cfset results.message = "Wiadomosci sa wysylane" />
			
			<cfset session.results = results />
		</cfif>
	</cffunction>
	
</cfcomponent>