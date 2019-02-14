<cfcomponent displayName="Document_attachment" extends="Model" hint="">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("document_attachments") />
	</cffunction>
	
	<cffunction name="pobierzPliki" output="false" access="public" hint="">
		<cfargument name="documentid" type="numeric" required="true" />
		
		<cfset var dokumenty = "" />
		<cfquery name="dokumenty" datasource="#get('loc').datasource.intranet#">
			select a.id as document_file_id, a.documentid, a.file_src, a.komentarz, a.userid, a.data_dodania,
			u.givenname, u.sn from document_attachments a
			inner join users u on a.userid = u.id 
			where a.documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />
			order by a.data_dodania desc;
		</cfquery>
		<cfreturn dokumenty />
	</cffunction>
	
	<cffunction name="pobierzPlikPoId" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var plik = "" />
		<cfquery name="plik" datasource="#get('loc').datasource.intranet#">
			select * from document_attachments 
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />; 
		</cfquery>
		
		<cfreturn plik />
	</cffunction>
	
	<cffunction name="pobierzIloscPlikow" output="false" access="public" hint="">
		<cfargument name="documentid" type="numeric" required="true" />
		
		<cfset var iloscPlikow = "" />
		<cfquery name="iloscPlikow" datasource="#get('loc').datasource.intranet#">
			select count(*) as iloscplikow from document_attachments
			where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
		</cfquery>

		<cfreturn iloscPlikow.iloscplikow />
	</cffunction>
</cfcomponent>