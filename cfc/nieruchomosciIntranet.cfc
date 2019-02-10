<cfcomponent displayName="nieruchomosciIntranet" output="false" hint="">

	<cfproperty name="dsn" type="string" default="intranet" />
	
	<!--- PSEUDO-CONSTRUCTOR --->
	<cfscript>
		variables = {
			dsn = "intranet"
		};
	</cfscript>
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfargument name="dsn" type="string" required="true" />
		
		<cfscript>
			setDsn(arguments.dsn);
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDsn" output="false" access="public" hint="">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
	</cffunction>
	
	<cffunction name="getDsn" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.dsn />
	</cffunction>
	
	<cffunction name="cacheFormularzyNieruchomosci" output="false" access="public" hint="">
		
		<cfsetting requestTimeout="3600" />
		
		<cfset var formularze = "" />
		<cfquery name="formularze" datasource="#getDsn()#">
			start transaction;
			
			drop table if exists cache_place_forms_filledfields;
			create table cache_place_forms_filledfields as
			select 
				pif2.formid, 
				pif2.instanceid, 
				sum(
					case 
						when Length(Trim(pif2.formfieldvalue)) > 0 
							then 1
							else 0
					end
				) as filledfield
			from place_instanceforms pif2 
			group by pif2.formid, pif2.instanceid;
			
			drop table if exists cache_place_forms_allfields;
			create table cache_place_forms_allfields as
			select 
				id as formid,
				(select count(distinct id) 
					from place_formfields pff
					where pff.formid = f.id and pff.fieldvisible = 1) as allfields
			from place_forms f;
			
			drop table if exists cache_place_forms_accepted;
			create table cache_place_forms_accepted as
			select sum(accepted) as accepted, pif3.formid, pif3.instanceid 
			from place_instanceforms pif3 
			group by pif3.formid, pif3.instanceid;
			
			commit;
		</cfquery>
		<cfreturn true />
	</cffunction>
	
</cfcomponent>