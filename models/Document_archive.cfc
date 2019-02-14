<cfcomponent displayname="Document_archive" output="false" extends="Model">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("document_archives") />
	</cffunction>
	
	<cffunction name="dodajKomunikat" output="false" access="public" hint="">
		<cfargument name="documentid" type="numeric" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="reason" type="string" required="true" />
		
		<cfset var dodajWpis = "" />
		<cfquery name="dodajWpis" datasource="#get('loc').datasource.intranet#">
			select workflowid, numer_faktury into @wid, @nrf from trigger_workflowsearch
			where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
			
			insert into document_archives (workflowid, documentid, userid, created, reason, nr)
			values (
				@wid,
				<cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />,
				<cfqueryparam value="#arguments.reason#" cfsqltype="cf_sql_varchar" />,
				@nrf  
			); 
		</cfquery>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="szukajWArchiwum" output="false" access="public" hint="">
		<cfargument name="text" type="string" required="true" />
		
		<cfset var dokumenty = "" />
		<cfquery name="dokumenty" datasource="#get('loc').datasource.intranet#">
			select * from document_archives a
			left join arch_trigger_workflowsearch b on a.documentid = b.documentid
			where a.nr like <cfqueryparam value="%#arguments.text#%" cfsqltype="cf_sql_varchar" />
			or b.nazwa2 like <cfqueryparam value="%#arguments.text#%" cfsqltype="cf_sql_varchar" />
			or b.workflowstepnote like <cfqueryparam value="%#arguments.text#%" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfreturn dokumenty />
	</cffunction>
	
	<cffunction name="ustawKorekte" output="false" access="public" hint="">
		<cfargument name="documentid" type="numeric" required="true" />
		<cfargument name="archiveid" type="numeric" required="true" />
		
		<cfset var korekta = "" />
		<cfquery name="korekta" datasource="#get('loc').datasource.intranet#">
			update documents set archiveid = <cfqueryparam value="#arguments.archiveid#" cfsqltype="cf_sql_integer" />
			where id = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="pobierzElement" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var element = "" />
		<cfquery name="element" datasource="#get('loc').datasource.intranet#">
			select a.id, a.workflowid, a.documentid, a.userid, a.created, a.reason, a.nr, u.givenname, u.sn from document_archives a
			inner join users u on a.userid = u.id
			where a.id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn element />
	</cffunction>
	
	<cffunction name="searchCondition" access="remote" returntype="string" hint="" >
		<cfargument name="search" type="array" required="true" />
		
		<cfif ArrayIsEmpty(arguments.search)>
			<cfreturn "1=1" />
		</cfif>
		
		<cfset var condition = "(" />
		<cfloop array="#arguments.search#" index="element">
			<cfset condition &= " LOWER(`a`.`nr`) like '%#LCase(element)#%' and " />
		</cfloop>
		
		<cfset condition = Left(condition, Len(condition) - 4) & " ) or ( " />
		<cfloop array="#arguments.search#" index="element">
			<cfset condition &= " LOWER(`b`.`numer_faktury_zewnetrzny`) like '%#LCase(element)#%' and " />
		</cfloop>
		
		<cfset condition = Left(condition, Len(condition) - 4) & " ) or ( " />
		<cfloop array="#arguments.search#" index="element">
			<cfset condition &= " LOWER(`b`.`nazwa1`) like '%#LCase(element)#%' and " />
		</cfloop>
		
		<cfset condition = Left(condition, Len(condition) - 4) & " ) or ( " />
		<cfloop array="#arguments.search#" index="element">
			<cfset condition &= " LOWER(`b`.`nazwa2`) like '%#LCase(element)#%' and " />
		</cfloop>
		
		<cfset condition = Left(condition, Len(condition) - 4) & " ) or ( " />
		<cfloop array="#arguments.search#" index="element">
			<cfset condition &= " LOWER(`b`.`workflowstepnote`) like '%#LCase(element)#%' and " />
		</cfloop>
		
		<cfset condition = Left(condition, Len(condition) - 4) & " ) or ( " />
		<cfloop array="#arguments.search#" index="element">
			<cfset condition &= " LOWER(`a`.`reason`) like '%#LCase(element)#%' and " />
		</cfloop>
		
		<cfset condition = Left(condition, Len(condition) - 4) & " ) " />
		
		<cfreturn #REReplace(condition, "''", "'", "ALL")# />
		
	</cffunction>
	
	<cffunction name="search" output="false" access="public" hint="" returnvalue="query">
		<cfargument name="search" type="array" required="true" />
		
		<cfset var archiwum = "" />
		<cfquery name="archiwum" datasource="#get('loc').datasource.intranet#">
			select * from document_archives a
			left join arch_trigger_workflowsearch b on a.workflowid = b.workflowid
			where (#searchCondition(arguments.search)#)
				
		</cfquery>
		
		<cfreturn archiwum />
	</cffunction>
	
	<cffunction name="pobierzSciezkePdf" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var dane = "" />
		<cfquery name="dane" datasource="#get('loc').datasource.intranet#">
			select a.id, a.documentid, a.documentfilename 
			from arch_documentinstances a
			where a.documentid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfreturn dane />
	</cffunction>
	
	<cffunction name="przywrocDokument" output="false" access="public" hint="" returntype="struct">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="ip" type="string" required="true" />
		<cfargument name="documentid" type="numeric" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Przywróciłem fakturę" />
		
		<cfset var przeniesienie = "" />
		<cfset var przeniesienieResult = "" />
		
			<cftry>
				<cftransaction action="begin" >
				<cfquery name="przeniesienie" result="przeniesienieResult" datasource="#get('loc').datasource.intranet#">
			
					set @workflow_id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
					set @document_id = (select documentid from arch_workflows where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />);
					set @user_id = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />;
					set @ip = <cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />;
					set @autocommit = 0;
		
					insert into documents select * from arch_documents where id = @document_id;
					delete from arch_documents where id = @document_id;
					insert into arch_history (
					  arch_historydate,
					  arch_historytable,
					  arch_historytablefield,
					  arch_historytablekey,
					  arch_historyuserid,
					  arch_historyip)
					values (NOW(), 'arch_documents', 'id', @document_id, @user_id, @ip);
					
					insert into workflows select * from arch_workflows where id = @workflow_id;
					delete from arch_workflows where id = @workflow_id;
					insert into arch_history (
					  arch_historydate,
					  arch_historytable,
					  arch_historytablefield,
					  arch_historytablekey,
					  arch_historyuserid,
					  arch_historyip)
					values (NOW(), 'arch_workflows', 'id', @workflow_id, @user_id, @ip);
					
					insert into workflowstepdescriptions select * from arch_workflowstepdescriptions where workflowid = @workflow_id;
					delete from arch_workflowstepdescriptions where workflowid = @workflow_id;
					insert into arch_history (
					  arch_historydate,
					  arch_historytable,
					  arch_historytablefield,
					  arch_historytablekey,
					  arch_historyuserid,
					  arch_historyip)
					values (NOW(), 'arch_workflowstepdescriptions', 'workflowid', @workflow_id, @user_id, @ip);
					
					insert into workflowsteps select * from arch_workflowsteps where workflowid = @workflow_id;
					delete from arch_workflowsteps where workflowid = @workflow_id;
					insert into arch_history (
					  arch_historydate,
					  arch_historytable,
					  arch_historytablefield,
					  arch_historytablekey,
					  arch_historyuserid,
					  arch_historyip)
					values (NOW(), 'arch_workflowsteps', 'workflowid', @workflow_id, @user_id, @ip);
					
					<!---
					insert into documentinstances select * from arch_documentinstances where documentid = @document_id;
					delete from arch_documentinstances where documentid = @document_id;
					insert into arch_history (
					  arch_historydate,
					  arch_historytable,
					  arch_historytablefield,
					  arch_historytablekey,
					  arch_historyuserid,
					  arch_historyip)
					values (NOW(), 'arch_documentinstances', 'documentid', @document_id, @user_id, @ip);
					--->
					
					insert into documentattributevalues select * from arch_documentattributevalues where documentid = @document_id;
					delete from arch_documentattributevalues where documentid = @document_id;
					insert into arch_history (
					  arch_historydate,
					  arch_historytable,
					  arch_historytablefield,
					  arch_historytablekey,
					  arch_historyuserid,
					  arch_historyip)
					values (NOW(), 'arch_documentattributevalues', 'documentid', @document_id, @user_id, @ip);
					
					insert into workflowtosendmails select * from arch_workflowtosendmails where workflowid = @workflow_id;
					delete from arch_workflowtosendmails where workflowid = @workflow_id;
					insert into arch_history(
					  arch_historydate,
					  arch_historytable,
					  arch_historytablefield,
					  arch_historytablekey,
					  arch_historyuserid,
					  arch_historyip)
					values (NOW(), 'arch_workflowtosendmails', 'workflowid', @workflow_id, @user_id, @ip);
					
					delete from trigger_workflowsearch where workflowid = @workflow_id;
					delete from trigger_workflowsteplists where workflowid = @workflow_id;
					delete from cron_invoicereports where workflowid = @workflow_id;
					
					insert into trigger_workflowsearch select * from arch_trigger_workflowsearch where workflowid = @workflow_id;
					delete from arch_trigger_workflowsearch where workflowid = @workflow_id;
					insert into arch_history(
					  arch_historydate,
					  arch_historytable,
					  arch_historytablefield,
					  arch_historytablekey,
					  arch_historyuserid,
					  arch_historyip)
					values (NOW(), 'arch_trigger_workflowsearch', 'workflowid', @workflow_id, @user_id, @ip);
					
					insert into trigger_workflowsteplists select * from arch_trigger_workflowsteplists where workflowid = @workflow_id;
					delete from arch_trigger_workflowsteplists where workflowid = @workflow_id;
					insert into arch_history(
					  arch_historydate,
					  arch_historytable,
					  arch_historytablefield,
					  arch_historytablekey,
					  arch_historyuserid,
					  arch_historyip)
					values (NOW(), 'arch_trigger_workflowsteplists', 'workflowid', @workflow_id, @user_id, @ip);
					
					insert into cron_invoicereports select * from arch_cron_invoicereports where workflowid = @workflow_id;
					delete from arch_cron_invoicereports where workflowid = @workflow_id;
					insert into arch_history(
					  arch_historydate,
					  arch_historytable,
					  arch_historytablefield,
					  arch_historytablekey,
					  arch_historyuserid,
					  arch_historyip)
					values (NOW(), 'arch_cron_invoicereports', 'workflowid', @workflow_id, @user_id, @ip);
					
					delete from document_archives where workflowid = @workflow_id;
					update workflows set to_archive = 0 where id = @workflow_id;
				</cfquery>
				</cftransaction>
				
				<cfset var dokument = createObject("component", "cfc.models.Dokument").init(id = arguments.documentid) />
				<cfset var dokumentDAO = createObject("component", "cfc.models.DokumentDAO").init(get("loc").datasource.intranet) />
				<cfset dokumentDAO.read(dokument) />
				
				<cfset var sciezkaArch = rereplace(dokument.getDocument_file_name(), "faktury/", "faktury_arch/", "ALL") />
				<cffile action="move" destination="#expandPath( dokument.getDocument_file_name() )#" source="#expandPath( sciezkaArch )#" />
				
				<cfcatch type="database">
					<cftransaction action="rollback" />
						
					<cfset results.success = false />
					<cfset results.message = "Nie mogłem przywrócić faktury" />
				</cfcatch>
				
			</cftry>
			
		<cfreturn results />
	</cffunction>
	
</cfcomponent>