<cfcomponent displayname="Store_gps" extends="Model" output="false" hint="">

	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("a") />
	</cffunction>

	<cffunction name="getAllStores" output="false" access="public" hint="" returntype="query">
		<cfset var istniejeTabela = "" />
		<cfquery name="istniejeTabela" datasource="#get('loc').datasource.intranet#">
			select count(*) as c from information_schema.TABLES WHERE (TABLE_SCHEMA = 'intranet') AND (TABLE_NAME = 'store_stores_gps');
		</cfquery>
		
		<cfset var sklepy="" />
		<cfquery name="sklepy" datasource="#get('loc').datasource.intranet#">
			
			<cfif istniejeTabela.c EQ 0 >
				call sp_intranet_store_stores_create_gps_table();
			</cfif>

			<!---create table if not exists store_stores_gps as select id as storeid, longitude,
			trim(
				left(
					substring_index(longitude, ":", 1),
						1
					)
				) as lng,
				
			cast(trim(
				substring_index(
					substring_index(longitude, "°", 1)
						, ":",
						-1
					)
				) as decimal(12, 8)) as lng_degree,
				
			cast(trim(
				substring_index(
					substring_index(longitude, "'", 1)
						, "°",
						-1
					)
				) as decimal(12, 8)) as lng_minutes,
				
			cast(trim(
				substring_index(
					substring_index(longitude, '"', 1)
						, "'",
						-1
					)
				) as decimal(12, 8)) as lng_seconds,
				
			latitude,
			
			trim(
				left(
					substring_index(latitude, ":", 1),
						1
					)
				) as lat,
				
			cast(trim(
				substring_index(
					substring_index(latitude, "°", 1)
						, ":",
						-1
					)
				) as decimal(12, 8)) as lat_degree,
				
			cast(trim(
				substring_index(
					substring_index(latitude, "'", 1)
						, "°",
						-1
					)
				) as decimal(12, 8)) as lat_minutes,
				
			cast(trim(
				substring_index(
					substring_index(latitude, '"', 1)
						, "'",
						-1
					)
				) as decimal(12, 8)) as lat_seconds
				
			from store_stores;--->
			
			select
				b.projekt,
		        a.storeid,
		        case a.lng
		                when 'W'
		                        then -1 * (((a.lng_minutes * 60) + a.lng_seconds) / 3600 + a.lng_degree)
		                        else ((a.lng_minutes * 60) + a.lng_seconds) / 3600 + a.lng_degree end as longitude,
		        (((a.lat_minutes * 60) + a.lat_seconds) / 3600 + a.lat_degree) as latitude
	        from store_stores_gps a
	        inner join store_stores b on (a.storeid = b.id and b.is_active = 1)
	        where a.longitude is not null and a.latitude is not null;
		</cfquery>

		<cfreturn sklepy />
	</cffunction>
	
	<cffunction name="tworzTabeleGps" output="false" access="public" hint="">
		<cfset var gps = "" />
		<cfquery name="gps" datasource="#get('loc').datasource.intranet#">
			drop table if exists store_stores_gps;
			create table store_stores_gps as 
			select id as storeid, 
		longitude, 
		trim( left( substring_index(longitude, ":", 1), 1 ) ) as lng, 
		cast(
			trim( substring_index( trim(substring_index(
			case LOCATE('"', longitude)
			when 0 then CONCAT(longitude, '"')
			else longitude end
			, "°", 1)) , ":", -1 ) ) as decimal(12, 8)) as lng_degree, 
		cast(
			trim( substring_index( trim(substring_index(
			case LOCATE('"', longitude)
			when 0 then CONCAT(longitude, '"')
			else longitude end
			, "'", 1)) , "°", -1 ) ) as decimal(12, 8)) as lng_minutes, 
		cast(
			trim( substring_index( trim(substring_index(
			case LOCATE('"', longitude)
			when 0 then CONCAT(longitude, '"')
			else longitude end
			, '"', 1)) , "'", -1 ) ) as decimal(12, 8)) as lng_seconds, 
		latitude, 
		trim( left( substring_index(latitude, ":", 1), 1 ) ) as lat, 
		cast(
			trim( substring_index( trim(substring_index(
			case LOCATE('"', latitude)
			when 0 then CONCAT(latitude, '"')
			else latitude end
			, "°", 1)) , ":", -1 ) ) as decimal(12, 8)) as lat_degree, 
		cast(
			trim( substring_index( trim(substring_index(
			case LOCATE('"', latitude)
			when 0 then CONCAT(latitude, '"')
			else latitude end
			, "'", 1)) , "°", -1 ) ) as decimal(12, 8)) as lat_minutes, 
		cast(
			trim( substring_index( trim(substring_index(
			case LOCATE('"', latitude)
			when 0 then CONCAT(latitude, '"')
			else latitude end
			, '"', 1)) , "'", -1 ) ) as decimal(12, 8)) as lat_seconds 
	from store_stores where is_active = 1 and length(latitude) > 0 and length(longitude) > 0; 

			drop table if exists store_stores_google_gps;
			create table store_stores_google_gps as select
				b.projekt,
				a.storeid,
				case a.lng
					when 'W'
						then -1 * (((a.lng_minutes * 60) + a.lng_seconds) / 3600 + a.lng_degree)
						else ((a.lng_minutes * 60) + a.lng_seconds) / 3600 + a.lng_degree end as longitude,
				(((a.lat_minutes * 60) + a.lat_seconds) / 3600 + a.lat_degree) as latitude
			from store_stores_gps a
			inner join store_stores b on (a.storeid = b.id and b.is_active = 1);
		</cfquery>
		
		<cfreturn "" />
	</cffunction>

</cfcomponent>