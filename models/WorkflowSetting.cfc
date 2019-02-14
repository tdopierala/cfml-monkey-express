<cfcomponent extends="Model" displayname="workflowSetting">

	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("workflowsettings") />
	</cffunction>
	
	<cffunction name="pobierzNumerFaktury" output="false" access="public" hint="">
		<cfset var numerFaktury = "" />
		<cfquery name="numerFaktury" datasource="#get('loc').datasource.intranet#">
			start transaction;
			select workflowsettingvalue into @nrFakt from workflowsettings where workflowsettingname = "invoicenumber";
			update workflowsettings set workflowsettingvalue = workflowsettingvalue + 1 where workflowsettingname = "invoicenumber";
			select @nrFakt as nrfakt;
			commit;
		</cfquery>
		<cfreturn numerFaktury />
	</cffunction>
	
	<cffunction name="aktualizujNumerFaktury" output="false" access="public" hint="" returntype="void">
		<cfset var aktualizacjaNumeru = "" />
		<cfquery name="aktualizacjaNumeru" datasource="#get('loc').datasource.intranet#">
			start transaction;
				update workflowsettings set workflowsettingvalue = <cfqueryparam value="#Application.workflowDocumentNumber#" cfsqltype="cf_sql_varchar" />
				where workflowsettingname = <cfqueryparam value="invoicenumber" cfsqltype="cf_sql_varchar" />;
			commit;
		</cfquery>
	</cffunction>

</cfcomponent>