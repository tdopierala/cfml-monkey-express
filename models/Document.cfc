<!---
Komponent zawierający operacje na dokumentach.
Dokumenty znajdują się w bazie danych. Informacje, które są przechowywane w bazie to m.in: nazwa pliku, typ. wielkość, plik w wersji binarnej, ocr dokumentu.
--->
<cfcomponent extends="Model" output="false" hint="">

	<cffunction name="init">
		<cfset hasMany("documentAttributeValue") />		
		<!---<cfset hasOne("documentInstance") />--->
	</cffunction>
	
	<cffunction name="getDocuments" hint="Metoda zwracająca strukturę dla pojedyńczego dokumentu. Wyświetlane są wszystkie atrybuty i ich wrtości w jednym wierszu."
	returnType="struct">
	
		<cfargument name="page" type="numeric" default="1" hint="Strona, którą trzeba zwrócić" />
		<cfargument name="perPage" type="numeric" default="10" hint="Ilość elementów na stronie" />
	
		<!--- Lista dokumentów, które zostaną wyświetlane. Kolejnym krokiem jest pobieranie wszystkich atrybutów każdego dokumentu. --->
		<cfset documents = model("document").findAll(page=arguments.page,perPage=arguments.perPage,select="id,documentcreated,documentname",order="documentcreated desc",include="") />
		
		<!--- Tworzę strukturę dla dokumentów. --->
		<cfset loc.documents = {}>
		
		<!--- Przechodzę przez wszystkie dokumenty --->
		<cfset index = 0> <!--- Indeks elementu w strukturze --->
		<cfloop query="documents">
		
			<!--- Pobieram listę atrybutów dla danego dokumentu. --->
			<cfset documentattributes = model("documentAttributeValue").findAll(where="documentid=#id#",include="attribute")>
		
			<cfset loc.documents[index] = {}>
			<cfset loc.documents[index].documentname = documentname>
			<cfset loc.documents[index].documentcreated = documentcreated>
			<cfset loc.documents[index].documentid = id>
			
			<!--- Przechodzę przez wszystkie atrybuty dokumentu i dodaje je do struktury. --->
			<cfloop query="documentattributes">
				<cfset loc.documents[index][#attributename#] = documentattributetextvalue>
			</cfloop>
			
			<cfset index++>
		</cfloop>
		
		<cfreturn loc.documents />
	
	</cffunction>
	
	<cffunction 
		name="getDocumentAttributes"
		hint="Metoda pobierająca listę atrybutów opisujących dokument." >
			
		<cfargument 
			name="documentid"
			type="numeric" 
			required="true" />
			
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_documents_get_document_attributes"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.documentid#"
				dbVarName="@document_id" />
				
			<cfprocresult name="documentattributes" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn documentattributes />
		
	</cffunction>
	
	<cffunction name="zmienKontrahenta" output="false" access="public" hint="">
		<cfargument name="documentid" type="numeric" required="true" />
		<cfargument name="contractorid" type="numeric" required="true" />
		
		<cfset var zmienionyDokument = "" />
		<cfquery name="zmienionyDokument" datasource="#get('loc').datasource.intranet#">
			select id, nip, nazwa1, nazwa2 into @id, @nip, @nazwa1, @nazwa2
			from contractors
			where id = <cfqueryparam value="#arguments.contractorid#" cfsqltype="cf_sql_integer" />;
			
			update documents set contractorid = @id
			where id = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
			
			update trigger_workflowsearch set contractorid = @id, nazwa1 = @nazwa1, nazwa2 = @nazwa2, nip = @nip
			where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
			
			update trigger_workflowsteplists set contractorname = @nazwa2
			where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
			
			select * from trigger_workflowsearch 
			where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />; 
		</cfquery>
		<cfreturn zmienionyDokument />
	</cffunction>

	<cffunction name="getBasicInformations" output="false" access="public" hint="">
		<cfargument name="documentid" type="numeric" required="true" />
		
		<cfset var info = "" />
		<cfquery name="info" datasource="#get('loc').datasource.intranet#">
			select u.givenname, u.sn, d.documentcreated 
			from documents d
			inner join users u on d.userid = u.id
			where d.id = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn info />
	</cffunction>
	
	<cffunction name="przeniesDoArchiwum" output="false" access="public" hint="">
		<cfargument name="documentid" type="numeric" required="true" />
		
		<cfset var oznaczenieFaktury = "" />
		<cfset var res = true />
		<cftry>
			<cfquery name="oznaczenieFaktury" datasource="#get('loc').datasource.intranet#">
				update workflows set to_archive = 1
				where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfcatch type="datasource">
				<cfset res = false />
			</cfcatch>
			
		</cftry>
		
		<cfreturn res />
	</cffunction>
	
	<cffunction name="markAsPaid" output="false" access="public" hint="">
		<cfargument name="documentid" type="numeric" required="true" />
		
		<cfset var mark = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dokument został oznaczony jako opłacony" />
		
		<cftry>
			<cfquery name="mark" datasource="#get('loc').datasource.intranet#">
				update documents set paid = 1
				where id = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_intager" />
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie można oznaczyć dokumentu jako opłaconego: #CFCATCH.Message#" />
			</cfcatch> 
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="rankingBledow" output="false" access="public" hint="">
		<cfargument name="documentid" type="numeric" required="true" />
		
		<cfset var ranking = "" />
		<cfquery name="ranking" datasource="#get('loc').datasource.intranet#">
			select documentid, numer_faktury, data_wplywu 
			into @did, @nr, @dw
			from trigger_workflowsearch
			where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
			
			select userid, documentcreated 
			into @ui, @dc
			from documents
			where id = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
			
			insert into raport_bledy_w_dokumentach (documentid, numer_faktury, data_wplywu, userid, data_wprowadzenia)
			values (@did, @nr, @dw, @ui, @dc);
		</cfquery>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="pobierzBledyWFakturach" output="false" access="public" hint="">
		<cfset var bledy = "" />
		<cfquery name="bledy" datasource="#get('loc').datasource.intranet#">
			select count(*) as ilosc, a.userid, Year(a.data_wprowadzenia) as y, Month(a.data_wprowadzenia) as m, b.givenname, b.sn 
			from raport_bledy_w_dokumentach a
			inner join users b on a.userid = b.id
			group by a.userid, Year(a.data_wprowadzenia), Month(a.data_wprowadzenia)
		</cfquery>
		
		<cfreturn bledy />
	</cffunction>
	
	<cffunction name="pobierzWprowadzoneFaktury" output="false" access="public" hint="">
		<cfargument name="params" type="struct" required="false" /> 
		<cfset var wprowadzone = "" />
		<cfquery name="wprowadzone" datasource="#get('loc').datasource.intranet#">
			select count(*) as ilosc, a.userid, Year(a.documentcreated) as y, Month(a.documentcreated) as m, b.givenname, b.sn
			from documents a
			inner join users b on a.userid = b.id
			where 1=1
			
			<cfif IsDefined("arguments.params") and IsDefined("arguments.params.miesiac_od")>
				and Month(a.documentcreated) >= <cfqueryparam value="#arguments.params.miesiac_od#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			<cfif IsDefined("arguments.params") and IsDefined("arguments.params.miesiac_do")>
				and Month(a.documentcreated) <= <cfqueryparam value="#arguments.params.miesiac_do#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			<cfif IsDefined("arguments.params") and IsDefined("arguments.params.rok")>
				and Year(a.documentcreated) = <cfqueryparam value="#arguments.params.rok#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			group by a.userid, Year(a.documentcreated), Month(a.documentcreated)
			order by y, m
		</cfquery>
		<cfreturn wprowadzone />
	</cffunction>
	
	<cffunction name="pobierzSciezkePliku" output="false" access="public" hint="" returntype="query">
		<cfargument name="idDokumentu" type="numeric" required="true" />
		
		<cfset var dok = "" />
		<cfquery name="dok" datasource="#get('loc').datasource.intranet#">
			select document_file_name, document_src from documents where id = <cfqueryparam value="#arguments.idDokumentu#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfreturn dok />
	</cffunction>

</cfcomponent>