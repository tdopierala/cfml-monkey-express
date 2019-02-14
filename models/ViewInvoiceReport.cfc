<cfscript>
	
	component
		extends="Model"
		output="false" {
		
		public function init(){
			
			table("cron_invoicereports");
			setPrimaryKey(property="workflowid,documentid,contractorid");
		}
		
		public function getReport(
			String invoice_payment_date_from,
			String invoice_payment_date_to,
			String invoice_income_date_from,
			String invoice_income_date_to,
			String invoice_sold_date_from,
			String invoice_sold_date_to,
			boolean group_by_contractor
		){
			
			try {
				
				var invoiceQuery = new query(
					datasource = get('loc').datasource.intranet,
					cachedwithin = createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds));
							
				invoiceQuery.addParam(name="a1", value="#arguments.invoice_payment_date_from#", cfsqltype="cf_sql_date");
				invoiceQuery.addParam(name="a2", value="#arguments.invoice_payment_date_to#", cfsqltype="cf_sql_date");
				invoiceQuery.addParam(name="b1", value="#arguments.invoice_income_date_from#", cfsqltype="cf_sql_date");
				invoiceQuery.addParam(name="b2", value="#arguments.invoice_income_date_to#", cfsqltype="cf_sql_date");
				invoiceQuery.addParam(name="c1", value="#arguments.invoice_sold_date_from#", cfsqltype="cf_sql_date");
				invoiceQuery.addParam(name="c2", value="#arguments.invoice_sold_date_to#", cfsqltype="cf_sql_date");
				
				invoiceResult = invoiceQuery.execute(sql="
				select 
					a.nazwa1, 
					a.nazwa2, 
					" & iif(arguments.group_by_contractor, DE(' sum(replace(a.netto, ",", ".")) '), DE(' replace(a.netto, ",", ".") ')) & " as netto, 
					" & iif(arguments.group_by_contractor, DE(' sum(replace(a.brutto, ",", ".")) '), DE(' replace(a.brutto, ",", ".") ')) & " as brutto,
					a.contractorid,
					" & iif( not arguments.group_by_contractor , DE( ' a.data_wystawienia, ' ), "" ) & "
					" & iif( not arguments.group_by_contractor , DE( ' a.data_sprzedazy, ' ), "" ) & "
					" & iif( not arguments.group_by_contractor , DE( ' a.data_platnosci, ' ), "" ) & "
					" & iif( not arguments.group_by_contractor , DE( ' a.data_wplywu, ' ), "" ) & "
					" & iif( not arguments.group_by_contractor , DE( ' a.nip, ' ), "" ) & "
					" & iif( not arguments.group_by_contractor , DE( ' a.departmentname, ' ), "" ) & "
					" & iif( not arguments.group_by_contractor , DE( ' a.numer_faktury, ' ), "" ) & "
					" & iif( not arguments.group_by_contractor , DE( ' a.numer_faktury_zewnetrzny, ' ), "" ) & "
					" & iif( not arguments.group_by_contractor , DE( ' c.categoryname '), "" ) & "
				from cron_invoicereports a
				inner join documents b on a.documentid = b.id
				left join tree_workflowcategories c on b.categoryid = c.id
				where  
					" & iif(Len(arguments.invoice_payment_date_from) and Len(arguments.invoice_payment_date_to), DE(' a.data_platnosci between :a1 and :a2 '), " 1 ") & "
					and " & iif(Len(arguments.invoice_income_date_from) and Len(arguments.invoice_income_date_to), DE(' a.data_wplywu between :b1 and :b2 '), " 1 ") & "
					and " & iif(Len(arguments.invoice_sold_date_from) and Len(arguments.invoice_sold_date_to), DE(' a.data_sprzedazy between :c1 and :c2 '), " 1 ") & iif(arguments.group_by_contractor, DE(' group by a.contractorid '), "")).getResult();
					
				return invoiceResult;
				
			} catch (Exception e) {
				WriteOutput(e);
				abort;
			}
			
		}
		
	}
	
</cfscript>

<!---<cfcomponent 
	extends="Model">

	<cffunction name="init">
	
		<cfset table('cron_invoicereports') />
		<cfset setPrimaryKey(property="workflowid,documentid,contractorid")>
	
	</cffunction>
	
	
	<cffunction
		name="byContractor"
		hint="Zwracanie raportu, którego wyniki grupowane są po kontrahencie"
		description="Metoda zwracająca raport. Kwoty są sumami kwot neggo pogrupowanych po kontrahencie.">
		
		<cfargument name="invoicepaymentdatefrom" default="0" type="string" required="false" />
		<cfargument name="invoicepaymentdateto" default="0" type="string" required="false" />
		<cfargument name="invoicepaymentincomefrom" default="" type="string" required="false" />
		<cfargument name="invoicepaymentincometo" default="" type="string" required="false" />
		<cfargument name="invoicepaymentsoldfrom" default="" type="string" required="false" />
		<cfargument name="invoicepaymentsoldto" default="" type="string" required="false" />
		
		<cfset whereconditions = "" />
		<cfset whereconditions = appendToWhere(where=whereconditions,append="1=1") />
		
		<!--- Data płatności od: --->
		<cfif Len(arguments.invoicepaymentdatefrom)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append='`data_platnosci` > "#arguments.invoicepaymentdatefrom#"') />
		
		</cfif>
		
		<!--- Data płatności do: --->
		<cfif Len(arguments.invoicepaymentdateto)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append='`data_platnosci` < "#arguments.invoicepaymentdateto#"') />
		
		</cfif>
		
		<!--- Data wpływu od --->
		<cfif Len(arguments.invoicepaymentincomefrom)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append='`data_wplywu` > "#arguments.invoicepaymentincomefrom#"') />
		
		</cfif>
		
		<!--- Data wpływu do --->
		<cfif Len(arguments.invoicepaymentincometo)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append='`data_wplywu` < "#arguments.invoicepaymentincometo#"') />
		
		</cfif>
		
		<!--- Data sprzedaży od --->
		<cfif Len(arguments.invoicepaymentsoldfrom)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append='`data_sprzedazy` > "#arguments.invoicepaymentsoldfrom#"') />
		
		</cfif>
		
		<!--- Data sprzedaży do --->
		<cfif Len(arguments.invoicepaymentsoldto)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append='`data_sprzedazy` < "#arguments.invoicepaymentsoldto#"') />
		
		</cfif>
		
		<cfquery  
			name = "invoice_report_by_contractor" 
			dataSource = "#get('loc').datasource.intranet#" >
			
			select nazwa1, nazwa2, count(contractorid) as rowcount, sum(replace(netto, ',', '.')) as netto, sum(replace(brutto, ',', '.')) as brutto, contractorid from cron_invoicereports where #whereconditions# group by contractorid
				
		</cfquery>
		
		<cfreturn invoice_report_by_contractor />
<!--- 		<cfreturn QueryToStruct(invoice_report_by_contractor) /> --->
	
	</cffunction>
	
	<cffunction
		name="getReport"
		hint="Metoda zwracająca raport do kontrolera"
		description="Metoda zwracająca raport do kontrolera.">
	
		<cfargument name="invoicepaymentdatefrom" default="" type="string" required="false" />
		<cfargument name="invoicepaymentdateto" default="" type="string" required="false" />
		<cfargument name="invoicepaymentincomefrom" default="" type="string" required="false" />
		<cfargument name="invoicepaymentincometo" default="" type="string" required="false" />
		<cfargument name="invoicepaymentsoldfrom" default="" type="string" required="false" />
		<cfargument name="invoicepaymentsoldto" default="" type="string" required="false" />
		
		<cfset whereconditions = "" />
		
		<!--- Data płatności od --->
		<cfif Len(arguments.invoicepaymentdatefrom)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append="data_platnosci > '#arguments.invoicepaymentdatefrom#'") />
		
		</cfif>
		
		<!--- Data płątności do --->
		<cfif Len(arguments.invoicepaymentdateto)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append="data_platnosci < '#arguments.invoicepaymentdateto#'") />
		
		</cfif>
		
		<!--- Data wpływu od --->
		<cfif Len(arguments.invoicepaymentincomefrom)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append="data_wplywu > '#arguments.invoicepaymentincomefrom#'") />
		
		</cfif>
		
		<!--- Data wpływu do --->
		<cfif Len(arguments.invoicepaymentincometo)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append="data_wplywu < '#arguments.invoicepaymentincometo#'") />
		
		</cfif>
		
		<!--- Data sprzedaży od --->
		<cfif Len(arguments.invoicepaymentsoldfrom)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append="data_sprzedazy > '#arguments.invoicepaymentsoldfrom#'") />
		
		</cfif>
		
		<!--- Data sprzedaży do --->
		<cfif Len(arguments.invoicepaymentsoldto)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append="data_sprzedazy < '#arguments.invoicepaymentsoldto#'") />
		
		</cfif>
		
		<cfset reportdata = model("viewInvoiceReport").findAll(where="#whereconditions#") />
		
		<cfreturn reportdata />
<!--- 		<cfreturn QueryToStruct(reportdata) /> --->
	
	</cffunction>
	
	<cffunction 
		name="getInvoiceByContractor"
		hint="Pobieranie listy faktur z przedziału czasu dla określonego kontrahenta"
		description="Metoda pobieraąca listę faktur dla określonego kontrahenta z przedziału czasu">
	
		<cfargument name="contractorid" default="0" type="numeric" required="true" />
		<cfargument name="invoicepaymentdatefrom" default="" type="string" required="false" />
		<cfargument name="invoicepaymentdateto" default="" type="string" required="false" />
		<cfargument name="invoicepaymentincomefrom" default="" type="string" required="false" />
		<cfargument name="invoicepaymentincometo" default="" type="string" required="false" />
		<cfargument name="invoicepaymentsoldfrom" default="" type="string" required="false" />
		<cfargument name="invoicepaymentsoldto" default="" type="string" required="false" />
		
		<cfset whereconditions = "" />
		
		<!--- Data płatności od --->
		<cfif Len(arguments.invoicepaymentdatefrom)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append="data_platnosci > '#arguments.invoicepaymentdatefrom#'") />
		
		</cfif>
		
		<!--- Data płątności do --->
		<cfif Len(arguments.invoicepaymentdateto)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append="data_platnosci < '#arguments.invoicepaymentdateto#'") />
		
		</cfif>
		
		<!--- Data wpływu od --->
		<cfif Len(arguments.invoicepaymentincomefrom)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append="data_wplywu > '#arguments.invoicepaymentincomefrom#'") />
		
		</cfif>
		
		<!--- Data wpływu do --->
		<cfif Len(arguments.invoicepaymentincometo)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append="data_wplywu < '#arguments.invoicepaymentincometo#'") />
		
		</cfif>
		
		<!--- Data sprzedaży od --->
		<cfif Len(arguments.invoicepaymentsoldfrom)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append="data_sprzedazy > '#arguments.invoicepaymentsoldfrom#'") />
		
		</cfif>
		
		<!--- Data sprzedaży do --->
		<cfif Len(arguments.invoicepaymentsoldto)>
		
			<cfset whereconditions = appendToWhere(where=whereconditions,append="data_sprzedazy < '#arguments.invoicepaymentsoldto#'") />
		
		</cfif>
		
		<cfset whereconditions = appendToWhere(where=whereconditions,append="contractorid=#arguments.contractorid#") />
		
		<cfset reportdata = model("viewInvoiceReport").findAll(where="#whereconditions#") />
		
		<cfreturn reportdata />
	
	</cffunction>

</cfcomponent>--->