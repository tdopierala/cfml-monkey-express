<cfcomponent displayname="KontrahentDAO" output="false" hint="">
	<cffunction name="init" output="false" access="public" hint="" returntype="KontrahentDAO">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="create" output="false" access="public" hint="" returntype="struct">
		<cfargument name="kontrahent" type="Kontrahent" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dodano kontrahenta" />
		
		<cfset var nowyKontrahent = "" />
		<cfset var nowyKontrahentResult = "" />
		
		<cftry>
			
			<cfquery name="nowyKontrahent" result="nowyKontrahentResult" datasource="#variables.dsn#">
				insert into contractors (dzielnica, internalid, kli_kontrahenciid, kodpocztowy, logo, miejscowosc, nazwa1, nazwa2, 
				nip, nrdomu, nrlokalu, regon, typulicy, ulica, str_logo) values (
					<cfqueryparam value="#arguments.kontrahent.getDzielnica()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.kontrahent.getInternalid()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.kontrahent.getKli_kontrahenciid()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.kontrahent.getKodpocztowy()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.kontrahent.getLogo()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.kontrahent.getMiejscowosc()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.kontrahent.getNazwa1()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.kontrahent.getNazwa2()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.kontrahent.getNip()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.kontrahent.getNrdomu()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.kontrahent.getNrlokalu()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.kontrahent.getRegon()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.kontrahent.getTypulicy()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.kontrahent.getUlica()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.kontrahent.getLogo()#" cfsqltype="cf_sql_varchar" />
				);
			</cfquery>
			
			<cfset arguments.kontrahent.setId(nowyKontrahentResult.generatedKey) />
			
			<cfcatch type="database">
				<cfdump var="#cfcatch#" />
				<cfabort />
				
				<cfset results.success = false />
				<cfset results.message = "Nie można dodać kontrahenta" />
			</cfcatch>
		</cftry>
		<cfreturn results />
	</cffunction>
	
	<cffunction name="read" output="false" access="public" hint="" returntype="void">
		<cfargument name="kontrahent" type="Kontrahent" required="true" />
		
		<cfset var pobierzKontrahenta = "" />
		<cfquery name="pobierzKontrahenta" datasource="#variables.dsn#">
			select * from contractors where id = <cfqueryparam value="#arguments.kontrahent.getId()#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfif pobierzKontrahenta.recordCount EQ 1>
			
			<cfscript>
				arguments.kontrahent.setDzielnica(pobierzKontrahenta.dzielnica);
				arguments.kontrahent.setInternalid(pobierzKontrahenta.internalid);
				arguments.kontrahent.setKli_kontrahenciid(pobierzKontrahenta.kli_kontrahenciid);
				arguments.kontrahent.setKodpocztowy(pobierzKontrahenta.kodpocztowy);
				arguments.kontrahent.setLogo(pobierzKontrahenta.logo);
				arguments.kontrahent.setMiejscowosc(pobierzKontrahenta.miejscowosc);
				arguments.kontrahent.setNazwa1(pobierzKontrahenta.nazwa1);
				arguments.kontrahent.setNazwa2(pobierzKontrahenta.nazwa2);
				arguments.kontrahent.setNip(pobierzKontrahenta.nip);
				arguments.kontrahent.setNrdomu(pobierzKontrahenta.nrdomu);
				arguments.kontrahent.setNrlokalu(pobierzKontrahenta.nrlokalu);
				arguments.kontrahent.setRegon(pobierzKontrahenta.regon);
				arguments.kontrahent.setTypulicy(pobierzKontrahenta.typulicy);
				arguments.kontrahent.setUlica(pobierzKontrahenta.ulica);
				arguments.kontrahent.setStr_logo(pobierzKontrahenta.str_logo);
			</cfscript>
		</cfif>
	</cffunction>
</cfcomponent>