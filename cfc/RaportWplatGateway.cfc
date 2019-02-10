<cfcomponent displayname="RaportWplatGateway" output="false" hint="">
	
	<cfproperty name="dsn" type="string" default="" />
	
	<cffunction name="init" output="false" access="public" hint="" returntype="RaportWplatGateway">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="pobierzRaportWplat" output="false" access="public" hint="" returntype="any">
		<cfargument name="dzienOd" type="string" required="false" />
		<cfargument name="dzienDo" type="string" required="false" />
		
		<cfset var raportWplatTemp = "" />
		<cfset var raportWplatDane = "" />
		<cfset var raportWplat = "" />
		<cfset var raportWplatUsun = "" />
		
		<cfquery name="raportWplatTemp" datasource="#variables.dsn#">
			begin transaction;
				create table ##temp_raportWplat (contributionReportDate date, fullLocationNumber nvarchar(16), minVer int, maxVer int);
			commit;
		</cfquery>
		
		<cfquery name="raportWplatDate" datasource="#variables.dsn#">
			begin transaction;
				insert into ##temp_raportWplat (contributionReportDate, fullLocationNumber, minVer, maxVer)
				select a.contributionReportDate, a.fullLocationNumber, MIN(a.ver) as minVer, MAX(a.ver) as maxVer
				from dbo.raport_wplat_raporty a
				group by a.contributionReportDate, a.fullLocationNumber
				order by a.contributionReportDate desc;
			commit;
		</cfquery>
		
		<cfquery name="raportWplat" datasource="#variables.dsn#">
			begin transaction;
				select a.*, 
				b.productsSaleAmount as minVerProductsSaleAmount, b.productsProductionAmount as minVerProductsProductionAmount, 
				b.promoDiscountAmount as minVerPromoDiscountAmount, b.electronicPaymentAmount as minVerElectronicPaymentAmount, 
				b.paymentPercent as minVerPaymentPercent, b.paymentAmount as minVerPaymentAmount,
				
				c.productsSaleAmount as maxVerProductsSaleAmount, c.productsProductionAmount as maxVerProductsProductionAmount, 
				c.promoDiscountAmount as maxVerPromoDiscountAmount, c.electronicPaymentAmount as maxVerElectronicPaymentAmount, 
				c.paymentPercent as maxVerPaymentPercent, c.paymentAmount as maxVerPaymentAmount,
				
				(select sum(d.saleAmount) from raport_wplat_sprzedazElektroniczna d where d.idRaportu = b.idRaportu) as minVerElectronicSaleAmount,
				(select sum(e.saleAmount) from raport_wplat_sprzedazElektroniczna e where e.idRaportu = c.idRaportu) as maxVerElectronicSaleAmount
				
				from ##temp_raportWplat a 
				inner join raport_wplat_raporty b on (a.minVer = b.ver and a.fullLocationNumber = b.fullLocationNumber and a.contributionReportDate = b.contributionReportDate)
				inner join raport_wplat_raporty c on (a.maxVer = c.ver and a.fullLocationNumber = c.fullLocationNumber and a.contributionReportDate = c.contributionReportDate);
				
			commit;
		</cfquery>
		
		<cfquery name="raportWplatUsun" datasource="#variables.dsn#">
			begin transaction;
				drop table ##temp_raportWplat;
			commit;
		</cfquery>

		<cfreturn raportWplat />
	</cffunction>
	
</cfcomponent>