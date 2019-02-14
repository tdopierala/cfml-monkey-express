<cfcomponent displayname="Mmarket" extends="Model" output="false" hint="">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("mmarket") />
	</cffunction>
	
	<!---
		Import wersji MMarketu znajdującego się na sklepach odbywa się
		w kilku krokach. Pierwszyk krokiem jest zalogowanie się do serwera
		FTP i wylistowanie wszystkich sklepów. Następnie skrypt wchodzi w
		każdy sklep i pobiera wszystkie pliki o określonej nazwie i kopiuje
		je do katalogu /var/www/intranet/ftp.
		
		Drugim krokiem jest przelecenie przez wszystkie pliki w katalogu
		/var/www/intranet/cft a następnie zaimportowanie danych z pliku do
		bazy.
	--->
	<cffunction name="importAppVersionFiles" output="false" access="public" hint="">
		
		<cfsetting requesttimeout="3600" />
		
		<!--- Obiekt reprezentujący połączenie z FTP --->
		<cfset f = createObject("component", "#get('loc').intranet.directory#.cfc.ftp").init(
			usr="superuser",
			passwd="iSichei",
			prt="21",
			hst="10.99.9.3"
		) />
		
		<!--- Obsługa połączenia FTP --->
		<cfset fa = createObject("component", "#get('loc').intranet.directory#.cfc.ftpActions").init(obj=f) />
		<cfset var listaSklepow = "" />
		<cfset var zawartoscKatalogu = "" />
		<cfset listaSklepow = fa.changeDirectory("sklepy").changeDirectory("in").listDirectory() />
		<!---
		<cfset listaSklepow = fa.changeDirectory("sklepy") />
		<cfdump var="#listaSklepow.listDirectory()#" />
		<cfabort />
		--->
		
		<cfloop query="listaSklepow">
			<cfset var numerSklepu = name />
			
			<!---<cfset var name = "B13169" />--->
			<cfset zawartoscKatalogu = fa.changeDirectory("/").changeDirectory("sklepy").changeDirectory("in").changeDirectory("#name#").listDirectory() />
	
			<!---
				Będąc w katalogu sklepu kopiuje wszystkie pliki spełniające 
				warunek do /var/www/intranet/ftp
			--->
			<cfquery dbtype="query" name="plikiDoZgrania" >
				select NAME from zawartoscKatalogu
				where NAME like 'AS_%_AppVersionInfo_%.xml';
			</cfquery> 
			
			<!---<cfloop query="plikiDoZgrania">
				<cfset fa.getFile("#name#") />
			</cfloop>--->

			<cfloop query="plikiDoZgrania">
				<cfset fa.getFile("#name#").bakFile("#name#").bakFile("#name#.flg").moveFile(fileName="#name#.bak", sourceDir="/sklepy/in/#numerSklepu#", destinationDir="/sklepy/arch/#numerSklepu#").moveFile(fileName="#name#.flg.bak", sourceDir="/sklepy/in/#numerSklepu#", destinationDir="/sklepy/arch/#numerSklepu#") />
			</cfloop>
			
		</cfloop>

		<cfreturn true />

	</cffunction>
	
	<!---
		Aby zapisać wersję MMarketu w bazie przechodzę przez wszystkie pliki
		znajdujące się w katalogu /var/www/intranet/ftp i jeden po drugim
		zapisuje w tabelce.
	--->
	<cffunction name="saveAppVersionInDb" output="false" access="public" hint="">
		
		<cfsetting requesttimeout="3600" />
		
		<cfset var listaPlikow = directoryList(expandPath("ftp"), false, "query") />
		<cfset var plik = "" />
		
		<cfloop query="listaPlikow">
			
			<cftry>
			
				<cfset var tablicaNazwy = listToArray(name, "_") />
				
				<cfset plik = fileRead(directory & "/" & name) />
				
				<cfset var store = xmlSearch(plik, "VersionInfo/LocationInfo") />
				<cfset var host = xmlSearch(plik, "VersionInfo/Hosts/Host") />
				<cfset var app = xmlSearch(plik, "VersionInfo/Hosts/Host/Applications/Application") />
				
				<cfset var xmlStore = xmlParse(store[1]) />
				<cfset var xmlHost_typ1 = xmlParse(host[1]) />
				<cfset var xmlHost_typ2 = xmlParse(host[2]) />
				
				<cfset var xmlApp_1 = xmlParse(app[1]) />
				<cfset var xmlApp_2 = xmlParse(app[2]) />
				<cfset var xmlApp_3 = xmlParse(app[3]) />
				
				<cfquery name="insertQuery" datasource="#get('loc').datasource.intranet#">
					insert into mmarket (
						kodsklepu, 
						typ1_ip, 
						typ1_app1_id, typ1_app1_version, 
						typ1_app2_id, typ1_app2_version, 
						typ2_ip, 
						typ2_app2_id, typ2_app2_version, 
						created,
						version_date)
					values (
						<!---<cfif Left(xmlStore.LocationInfo.LocationNumber.XmlText, 1) IS "B">
							<cfqueryparam value="#xmlStore.LocationInfo.LocationNumber.XmlText#" cfsqltype="cf_sql_varchar" />,
						
						<cfelseif Left(xmlStore.LocationInfo.LocationNumber.XmlText, 1) IS "C">
							<cfqueryparam value="#xmlStore.LocationInfo.LocationNumber.XmlText#" cfsqltype="cf_sql_varchar" />,
						
						<cfelse>
							<cfqueryparam value="C#xmlStore.LocationInfo.LocationNumber.XmlText#" cfsqltype="cf_sql_varchar" />,
						</cfif>--->
						<cfqueryparam value="#tablicaNazwy[2]#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#xmlHost_typ1.Host.InternalIP.XmlText#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#xmlApp_1.Application.AppId.XmlText#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#xmlApp_1.Application.AppVersion.XmlText#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#xmlApp_2.Application.AppId.XmlText#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#xmlApp_2.Application.AppVersion.XmlText#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#xmlHost_typ2.Host.InternalIP.XmlText#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#xmlApp_3.Application.AppId.XmlText#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#xmlApp_3.Application.AppVersion.XmlText#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />,
						<cfqueryparam value="#tablicaNazwy[4]#" cfsqltype="cf_sql_date" />  
					);
				</cfquery>
				
				<cfset fileDelete(directory & "/" & name) />
				
				
			<cfcatch type="any">
				
				<cfmail from="intranet@monkey.xyz" subject="mmarket" to="admin@monkey.xyz" type="html" >
					<cfdump var="#name#" />
					<cfdump var="#cfcatch#" />
				</cfmail>
				
			</cfcatch>
			
			</cftry>

		</cfloop>
		
		<cfreturn true />
		
	</cffunction>
	
	<cffunction name="pobierzZestawienie" output="false" access="public" hint="">
		<cfargument name="kodsklepu" type="string" required="false" />
		
		<cfset var mmarket = "" />
		<cfquery name="mmarket" datasource="#get('loc').datasource.intranet#">
			select 
				a.kodsklepu,
				MAX(a.typ1_ip) as typ1_ip,
				MAX(a.typ1_app1_version) as typ1_app1_version,
				MAX(a.typ1_app2_id) as typ1_app2_id,
				MAX(
					CONVERT(
						CONCAT(
							SUBSTRING_INDEX(a.typ1_app2_version, '.', 1),
							SUBSTRING_INDEX(SUBSTRING_INDEX(a.typ1_app2_version, '.', 2), '.', -1),
							SUBSTRING_INDEX(a.typ1_app2_version, '.', -1)
						)
					, SIGNED)
				) as typ1_app2_version,
				MAX(a.typ2_ip) as typ2_ip,
				MAX(a.typ2_app2_id) as typ2_app2_id,
				MAX(
					CONVERT(
						CONCAT(
							SUBSTRING_INDEX(a.typ2_app2_version, '.', 1),
							SUBSTRING_INDEX(SUBSTRING_INDEX(a.typ2_app2_version, '.', 2), '.', -1),
							SUBSTRING_INDEX(a.typ2_app2_version, '.', -1)
						)
					, SIGNED)
				) as typ2_app2_version,
				
				<!---MAX(a.typ2_app2_version) as typ2_app2_version,--->
				MAX(a.created) as created,
				MAX(a.version_date) as version_date_max
			from mmarket a
			inner join store_stores b on (a.kodsklepu = b.projekt and b.is_active = 1)
			
			<cfif IsDefined("arguments.kodsklepu") AND Len(arguments.kodsklepu) GT 0>
				where a.kodsklepu like <cfqueryparam value="%#arguments.kodsklepu#%" cfsqltype="cf_sql_varchar" />
			</cfif>
			
			group by a.kodsklepu
		</cfquery>
		
		<cfreturn mmarket />
	</cffunction>
	
</cfcomponent>