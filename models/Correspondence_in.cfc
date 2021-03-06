<cfcomponent
	extends="Model"
	output="false">

	<cffunction
		name="init">

		<cfset table("correspondence_correspondences_in") />

	</cffunction>

	<cffunction
		name="getCorrespondences"
		hint="Popranie przychodzącej korespondencji">

		<cfargument
			name="data_wplywu"
			default="#Now()#"
			required="false" />

		<cfargument
			name="pismo_z_dn"
			default="#Now()#"
			required="false" />

		<cfargument
			name="typeid"
			default=""
			required="false" />

		<cfargument
			name="categoryid"
			default=""
			required="false" />

		<cfargument
			name="search"
			default=""
			required="false" />

		<cfargument
			name="page"
			default="1" />

		<cfargument
			name="elements"
			default="12" />

		<cfargument
			name="count"
			type="boolean"
			default="false" />

		<cfset a = (arguments.page-1)*arguments.elements />

		<cfquery
			name="query_get_correspondences"
			result="result_get_correspondences"
			datasource="#get('loc').datasource.intranet#">

			select
				ci.id as id
				,ci.nr as nr
				,ci.data_wplywu as data_wplywu
				,ci.pismo_z_dn as pismo_z_dn
				,ci.sygnatura as sygnatura
				,ci.typeid as typeid
				,ct.typename as typename
				,ci.categoryid as categoryid
				,cc.categoryname as categoryname
				,ci.nadawca as nadawca
				,ci.dotyczy as dotyczy
				,ci.adres as adres
			from correspondence_correspondences_in ci
			inner join correspondence_types ct on ci.typeid = ct.id
			inner join correspondence_categories cc on ci.categoryid = cc.id
			where
				<cfif Len(arguments.typeid)>
					ci.typeid = <cfqueryparam
									value="#arguments.typeid#"
									cfsqltype="cf_sql_integer" />
					and
				</cfif>

				<cfif Len(arguments.categoryid)>
					ci.categoryid = <cfqueryparam
										value="#arguments.categoryid#"
										cfsqltype="cf_sql_integer" />
					and
				</cfif>

				1=1

			<cfif arguments.count is not true>
				limit #a#, #arguments.elements#
			</cfif>

		</cfquery>

		<cfif arguments.count is true>
			<cfreturn query_get_correspondences.RecordCount />
		</cfif>

		<cfreturn query_get_correspondences />

	</cffunction>


	<cffunction
		name="updateField"
		hint="Aktualizuje wartość pola">

		<cfargument
			name="id"
			type="numeric"
			required="true" />

		<cfargument
			name="fieldname"
			type="string"
			required="true" />

		<cfargument
			name="fieldvalue"
			type="string"
			required="true" />

		<cfquery
			name="query_update_field"
			result="result_update_field"
			datasource="#get('loc').datasource.intranet#" >

			update correspondence_correspondences_in
			set #arguments.fieldname# = '#arguments.fieldvalue#'
			where id = #arguments.id#;

		</cfquery>

		<cfreturn result_update_field />

	</cffunction>

</cfcomponent>