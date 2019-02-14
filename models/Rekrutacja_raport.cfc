<cfcomponent displayname="Rekrutacja_raport" output="false" hint="" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("a") />
	</cffunction>
	
	<cffunction name="raportZaproszonych" output="false" access="public" hint="" returntype="query">
		<cfset var zaproszonych = "" />
		<cfquery name="zaproszonych" datasource="#get('loc').datasource.mssql#">
			select d.userId,
				sum(case b.wartoscPolaAnkiety
					when 'TAK' then 1
					when 'NIE' then 0
					else 0
				end) as tak,
				
				sum(case b.wartoscPolaAnkiety
					when 'TAK' then 0
					when 'NIE' then 1
					else 0
				end) as nie,
				
				sum(case b.wartoscPolaAnkiety
					when 'TAK' then 0
					when 'NIE' then 0
					else 1
				end) as brakDecyzji
			from rekrutacja_ankiety a
			inner join rekrutacja_wartosciAnkiet b on (a.idDefinicjiAnkiety = b.idDefinicjiAnkiety and a.idAnkiety = b.idAnkiety)
			inner join rekrutacja_ankietyFormularza c on (a.idAnkiety = c.idAnkiety and a.idDefinicjiAnkiety = c.idDefinicjiAnkiety)
			inner join rekrutacja_formularze d on c.idFormularza = d.idFormularza
			where a.idDefinicjiAnkiety = 1 and b.idDefinicjiPola = 1
			group by d.userId
		</cfquery>
		
		<cfreturn zaproszonych />
	</cffunction>
	
	<cffunction name="raportZainteresowanych" outut="false" access="public" hint="" returntype="query" >
		<cfset var zainteresowanych = "" />
		<cfquery name="zainteresowanych" datasource="#get('loc').datasource.mssql#">
			select d.userId,
				sum(case b.wartoscPolaAnkiety
					when 'TAK' then 1
					when 'NIE' then 0
					else 0
				end) as tak,
				
				sum(case b.wartoscPolaAnkiety
					when 'TAK' then 0
					when 'NIE' then 1
					else 0
				end) as nie,
				
				sum(case b.wartoscPolaAnkiety
					when 'TAK' then 0
					when 'NIE' then 0
					else 1
				end) as brakDecyzji
			from rekrutacja_ankiety a
			inner join rekrutacja_wartosciAnkiet b on (a.idDefinicjiAnkiety = b.idDefinicjiAnkiety and a.idAnkiety = b.idAnkiety)
			inner join rekrutacja_ankietyFormularza c on (a.idAnkiety = c.idAnkiety and a.idDefinicjiAnkiety = c.idDefinicjiAnkiety)
			inner join rekrutacja_formularze d on c.idFormularza = d.idFormularza
			where a.idDefinicjiAnkiety = 2 and b.idDefinicjiPola = 2
			group by d.userId
		</cfquery>
		
		<cfreturn zainteresowanych />
	</cffunction>
	
	<cffunction name="raportSzkolenie" output="false" access="public" hint="" returntype="query">
		<cfset var szkolenie = "" />
		<cfquery name="szkolenie" datasource="#get('loc').datasource.mssql#">
			select d.userId,
				sum(case b.wartoscPolaAnkiety
					when 'TAK' then 1
					when 'NIE' then 0
					else 0
				end) as tak,
				
				sum(case b.wartoscPolaAnkiety
					when 'TAK' then 0
					when 'NIE' then 1
					else 0
				end) as nie,
				
				sum(case b.wartoscPolaAnkiety
					when 'TAK' then 0
					when 'NIE' then 0
					else 1
				end) as brakDecyzji
			from rekrutacja_ankiety a
			inner join rekrutacja_wartosciAnkiet b on (a.idDefinicjiAnkiety = b.idDefinicjiAnkiety and a.idAnkiety = b.idAnkiety)
			inner join rekrutacja_ankietyFormularza c on (a.idAnkiety = c.idAnkiety and a.idDefinicjiAnkiety = c.idDefinicjiAnkiety)
			inner join rekrutacja_formularze d on c.idFormularza = d.idFormularza
			where a.idDefinicjiAnkiety = 3 and b.idDefinicjiPola = 3
			group by d.userId
		</cfquery>
		
		<cfreturn szkolenie />
	</cffunction>
</cfcomponent>