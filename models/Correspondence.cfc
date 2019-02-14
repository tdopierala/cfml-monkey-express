<cfcomponent
	extends="Model"
	output="false">

	<cffunction
		name="init" >

		<cfset table("correspondence_correspondences") />

	</cffunction>

	<cffunction
		name="todayCount"
		hint="Zliczam ilość dodanych listów na dany dzień">

		<cfquery
			name="query_today_count"
			result="result_today_count"
			datasource="#get('loc').datasource.intranet#">

			select
				count(id) as c
			from correspondence_correspondences
			where
				Day(correspondencecreated) = #DateFormat(Now(), "dd")# and
				Month(correspondencecreated) = #DateFormat(Now(), "mm")# and
				Year(correspondencecreated) = #DateFormat(Now(), "yyyy")#;

		</cfquery>

		<cfreturn query_today_count />
		<!---<cfreturn this.QueryToStruct(Query=query_today_count) />--->

	</cffunction>

	<cffunction
		name="listCount"
		hint="Zliczam liczbę listów w danym przedziale dat od-do" >

		<cfargument
			name="data_od"
			required="true" />

		<cfargument
			name="data_do"
			required="true"	/>

		<cfquery
			name="query_list_count"
			result="result_list_count"
			datasource="#get('loc').datasource.intranet#" >

			select
				count(id) as c
			from correspondence_correspondences
			where
				Date_format(correspondencecreated, "%Y-%m-%d") between
					'#DateFormat(arguments.data_od, "yyyy-mm-dd")#' and
					'#DateFormat(arguments.data_do, "yyyy-mm-dd")#';

		</cfquery>

		<cfreturn query_list_count />

	</cffunction>

	<cffunction
		name="todayList"
		hint="Pobieram dzisiejszą listę poczty" >

		<cfquery
			name="query_today_list"
			result="result_today_list"
			datasource="#get('loc').datasource.intranet#" >

			select
				c.id as id
				,c.addresseeid as addresseeid
				,c.kwota_zl as kwota_zl
				,c.kwota_gr as kwota_gr
				,c.masa_kg as masa_kg
				,c.masa_g as masa_g
				,c.nr_nadawczy as nr_nadawczy
				,c.uwagi as uwagi
				,c.oplata_zl as oplata_zl
				,c.oplata_gr as oplata_gr
				,c.pobranie_zl as pobranie_zl
				,c.pobranie_gr as pobranie_gr
				,c.lp as lp
				,c.adresat as adresat
				,c.miejsce_doreczenia as miejsce_doreczenia
			from correspondence_correspondences c
			where
				Day(c.correspondencecreated) = #DateFormat(Now(), "dd")# and
				Month(c.correspondencecreated) = #DateFormat(Now(), "mm")# and
				Year(c.correspondencecreated) = #DateFormat(Now(), "yyyy")#;

		</cfquery>

		<cfreturn query_today_list />

	</cffunction>

	<cffunction
		name="updateField"
		hint="Aktualizuje wartość pola opisującego listę">

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

			update correspondence_correspondences
			set #arguments.fieldname# = '#arguments.fieldvalue#'
			where id = #arguments.id#;

		</cfquery>

		<cfreturn result_update_field />

	</cffunction>

	<cffunction
		name="getList"
		hint="Pobieram listę listów na dany dzień."
		description="Zakres dat, z których mam brać listę przekazana jest w
			parametrze. Data jest parsowana i wyciągane z niej jest dzień, miesiąc
			oraz rok">

		<cfargument
			name="data_od"
			required="false"
			default="#Now()#" />

		<cfargument
			name="data_do"
			required="false"
			default="#Now()#" />

		<cfargument
			name="adresat"
			required="false"
			default="" />

		<cfquery
			name="query_get_list"
			result="result_get_list"
			datasource="#get('loc').datasource.intranet#" >

			select
				c.id as id
				,c.addresseeid as addresseeid
				,c.kwota_zl as kwota_zl
				,c.kwota_gr as kwota_gr
				,c.masa_kg as masa_kg
				,c.masa_g as masa_g
				,c.nr_nadawczy as nr_nadawczy
				,c.uwagi as uwagi
				,c.oplata_zl as oplata_zl
				,c.oplata_gr as oplata_gr
				,c.pobranie_zl as pobranie_zl
				,c.pobranie_gr as pobranie_gr
				,c.lp as lp
				,c.adresat as adresat
				,c.miejsce_doreczenia as miejsce_doreczenia
				,c.correspondencecreated as correspondencecreated
			from correspondence_correspondences c
			where
				Date_format(c.correspondencecreated, "%Y-%m-%d") between
					'#DateFormat(arguments.data_od, "yyyy-mm-dd")#' and
					'#DateFormat(arguments.data_do, "yyyy-mm-dd")#'
				
				<cfif IsDefined("arguments.adresat")>
					and
					c.adresat like '%#arguments.adresat#%';
				</cfif>

		</cfquery>

		<cfreturn query_get_list />

	</cffunction>

	<cffunction
		name="autocomplete"
		hint="Autouzupełnianie adresata">

		<cfargument
			name="search"
			type="any"
			default="" />

		<cfquery
			name="query_autocomplete"
			result="result_autocomplete"
			datasource="#get('loc').datasource.intranet#" >

			select
				distinct
				adresat
				,miejsce_doreczenia
			from correspondence_correspondences
			where adresat like '%#arguments.search#%';

		</cfquery>

		<cfreturn this.QueryToStruct(Query=query_autocomplete) />

	</cffunction>

	<!---
		Zliczam ilość korespondencji, która wychodzi danego dnia.
		Dane są prezentowane na stronie profilowej użytkownika.
	--->
	<cffunction
		name="statCorrespondences"
		hint="Ilość korespondencji wychodzącej, książka nadawcza."
		description="Metoda zliczająca ilość wychodzącej korespondencji.">

		<cfquery
			name="qC"
			result="rC"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select count(id) as c
			from correspondence_correspondences
			where DATE_FORMAT(correspondencecreated, "%Y-%m-%d") = CURDATE()

		</cfquery>

		<cfreturn qC />

	</cffunction>


</cfcomponent>