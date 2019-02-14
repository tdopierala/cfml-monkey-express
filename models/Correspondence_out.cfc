<cfcomponent
	extends="Model"
	output="false">

	<cffunction
		name="init">
		<cfset table("correspondence_correspondences_out") />
	</cffunction>

	<cffunction
		name="getCorrespondences"
		hint="Metoda pobierająca korespondencje wychodzącą">

		<cfargument
			name="data_wyslania"
			default=""
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
			name="page"
			default="1" />

		<cfargument
			name="elements"
			default="12" />

		<cfargument
			name="count"
			type="boolean"
			default="false" />

		<cfargument
			name="allRows"
			type="boolean"
			default="false" />

		<cfset a = (arguments.page-1)*arguments.elements />
		<cfset w = "" />
		<!---
			Tworzę warunek zapytania
		--->
		<cfif Len(arguments.typeid)>
			<cfset w &= " co.typeid = #arguments.typeid# and " />
		</cfif>

		<cfif Len(arguments.categoryid)>
			<cfset w &= " co.categoryid = #arguments.categoryid# and" />
		</cfif>

		<cfif Len(data_wyslania)>
			<cfset w &= " co.data_wyslania = " & DE( '#DateFormat(arguments.data_wyslania, 'yyyy-mm-dd')#' ) & " and " />
		</cfif>

		<cfif Len(w)>
			<cfset w = Left(w, Len(w)-4)>
		</cfif>

		<cfquery
			name="query_get_correspondences_out"
			result="result_get_correspondences_out"
			datasource="#get('loc').datasource.intranet#">

			select
				co.id as id
				,co.data_wyslania as data_wyslania
				,co.typeid as typeid
				,ct.typename as typename
				,co.categoryid as categoryid
				,cc.categoryname as categoryname
				,co.ilosc as ilosc
				,co.uwagi as uwagi
				,u.givenname as givenname
				,u.sn as sn
			from correspondence_correspondences_out co
			left join correspondence_types ct on co.typeid = ct.id
			left join correspondence_categories cc on co.categoryid = cc.id
			inner join users u on co.userid = u.id
			where

				<cfif Len(w)>
					#w#
				<cfelse>
					1=1
				</cfif>

				<cfif (arguments.count is not true) and (arguments.allRows is not true)>
					limit #a#, #arguments.elements#
				</cfif>

		</cfquery>

		<cfif arguments.count is true>
			<cfreturn query_get_correspondences_out.RecordCount />
		</cfif>

		<cfreturn query_get_correspondences_out />

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

			update correspondence_correspondences_out
			set #arguments.fieldname# = '#arguments.fieldvalue#'
			where id = #arguments.id#;

		</cfquery>

		<cfreturn result_update_field />

	</cffunction>
	
	<cffunction
		name="del"
		hint="Usunięcie wiersza korespondencji wychodzącej"
		returntype="boolean" >
	
		<cfargument
			name="id"
			type="numeric"
			required="true" />
			
		<cfquery
			name="qDelRow"
			result="rDelRow"
			datasource="#get('loc').datasource.intranet#">
				
			delete from correspondence_correspondences_out where id  = <cfqueryparam
																			value="#arguments.id#"
																			cfsqltype="cf_sql_integer" />
				
		</cfquery>
		
		<cfreturn true />
		
	</cffunction>

</cfcomponent>