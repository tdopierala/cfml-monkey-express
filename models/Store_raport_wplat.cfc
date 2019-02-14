<cfcomponent displayname="Store_raport_wplat" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("a") />
	</cffunction>
	
	<cffunction name="dodaj" output="false" access="public" hint="" returntype="numeric">
		<cfargument name="ver" type="numeric" required="false" />
		<cfargument name="fullLocationNumber" type="string" required="false" />
		<cfargument name="locationId" type="string" required="false" />
		<cfargument name="contributionReportDate" type="date" required="false" />
		<cfargument name="productsSaleAmount" type="numeric" required="false" />
		<cfargument name="productsPromotionAmount" type="numeric" required="false" />
		<cfargument name="promoDiscountAmount" type="numeric" required="false" />
		<cfargument name="electronicPaymentAmount" type="numeric" required="false" />
		<cfargument name="paymentPercent" type="numeric" required="false" />
		<cfargument name="paymentAmount" type="numeric" requuired="false" />
		
		<cfset var nowyWiersz = "" />
		<cfset var nowyWierszResult = "" />
		<cftry>
			<cfquery name="nowyWiersz" result="nowyWierszResult" datasource="#get('loc').datasource.mssql#">
				insert into raport_wplat_raporty (dataUtworzenia, ver, fullLocationNumber, locationId, contributionReportDate, productsSaleAmount, productsProductionAmount, promoDiscountAmount, electronicPaymentAmount, paymentPercent, paymentAmount) values (
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="#arguments.ver#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.fullLocationNumber#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.locationId#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.contributionReportDate#" cfsqltype="cf_sql_date" />,
					<cfqueryparam value="#arguments.productsSaleAmount#" cfsqltype="cf_sql_float" />,
					<cfqueryparam value="#arguments.productsProductionAmount#" cfsqltype="cf_sql_float"  />,
					<cfqueryparam value="#arguments.promoDiscountAmount#" cfsqltype="cf_sql_float" />,
					<cfqueryparam value="#arguments.electronicPaymentAmount#" cfsqltype="cf_sql_float" />,
					<cfqueryparam value="#arguments.paymentPercent#" cfsqltype="cf_sql_float" />,
					<cfqueryparam value="#arguments.paymentAmount#" cfsqltype="cf_sql_float" />
				);
			</cfquery>
			
			<cfcatch type="any">
				<cfdump var="#cfcatch#" />
				<cfabort />
			</cfcatch>
		</cftry>
		<cfreturn nowyWierszResult.generatedKey />
	</cffunction>
	
	<cffunction name="dodajSprzedazElektroniczna" output="false" access="public" hint="" returntype="struct">
		<cfargument name="idRaportu" type="numeric" required="false" />
		<cfargument name="idTypuSprzedazyElektronicznej" type="string" required="false" />
		<cfargument name="saleAmount" type="numeric" required="false" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dodalem wpiersz" / >
		
		<cftry>
			
			<cfquery datasource="#get('loc').datasource.mssql#">
				insert into raport_wplat_sprzedazElektroniczna (idRaportu, idTypuSprzedazyElektronicznej, saleAmount) values (
					<cfqueryparam value="#arguments.idRaportu#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.idTypuSprzedazyElektronicznej#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.saleAmount#" cfsqltype="cf_sql_float" />
				);
			</cfquery>
			
			<cfcatch type="any">
				
				<cfset results.success = false />
				<cfset results.message = "Nie dodalem wiersza" />
				
				<cfdump var="#cfcatch#" />
				<cfabort />
			</cfcatch>
		</cftry>
		<cfreturn results />
	</cffunction>
	
</cfcomponent>
