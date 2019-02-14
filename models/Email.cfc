<cfcomponent
	extends="Model">

	<cffunction
		name="init">

		<cfset table("emails") />

	</cffunction>

	<cffunction
		name="sendPlaceReminder"
		hint="Wysyłanie powiadomienia mailowego o zmianie statusu nieruchomości">

		<cfargument name="placeid" type="numeric" default="0" hint="Identyfikator nieruchomości" />
		<cfargument name="emails" type="struct" hint="Struktura z uzytkownikami, do których ma zostać wysłana wiadomość" />

		<cfset placeworkflow = model("placeWorkflow").getPlaceWorkflow(placeid="#arguments.placeid#") />
		<cfset place = model("place").findByKey(key=arguments.placeid,include="user") />

		<cfinclude template="../views/emails/sendplacereminder.cfm" />

	</cffunction>

	<cffunction
		name="changePlaceStatus"
		hint="Wysyłanie wiadomości do użytkowników z informacją o zmianie etapu obiegu nieruchomości">

		<cfargument name="users" type="any" required="true" />
		<cfargument name="oldstep" type="any" required="true" />
		<cfargument name="newstep" type="any" required="true" />



		<cfinclude template="../views/emails/changeplacestatus.cfm" />

	</cffunction>

	<cffunction
		name="partnerNotification"
		hint="Wysłanie powiadomienia do partnera o zalozeniu konta">

		<cfargument name="user" type="any" required="true" />
		<cfinclude template="../views/emails/partnernotification.cfm" />

	</cffunction>

	<cffunction
		name="nowyAjent"
		hint="Metoda wysyłająca wiadomość email do nowego Ajenta">

		<cfargument
			name="user"
			type="any"
			required="true" />

		<cfinclude
			template="../views/emails/nowyajent.cfm" />

	</cffunction>

	<cffunction
		name="placeMoveStep"
		hint="Wysłanie wiadomości informacyjnej o przeniesieniu nieruchomości do innego etapu.">

		<cfargument name="myinstance" type="any" required="false" />
		<cfargument name="new" type="any" required="false" />
		<cfargument name="myworkflow" type="any" reuired="true" />

		<cfset mymails = model("place_instance").getUsers(instanceid=arguments.myinstance.instanceid) />
		<cfset myuser = model("user").findByKey(arguments.myworkflow.user2) />

		<cfinclude template="../views/emails/placemovestep.cfm" />

	</cffunction>

	<cffunction
		name="placeAcceptStep"
		hint="Wysłanie wiadomości informacyjnej o zmianie etapu nieruchomości.">

		<cfargument name="myinstance" type="any" required="false" />
		<cfargument name="mystep" type="any" required="false" />
		<cfargument name="myworkflow" type="any" reuired="true" />

		<cfset mymails = model("place_instance").getUsers(instanceid=arguments.myinstance.instanceid) />
		<cfset myuser = model("user").findByKey(arguments.myworkflow.user2) />

		<cfset next = false />
		<cfif Len(arguments.mystep.next)>
			<cfset next = model("place_step").findByKey(arguments.mystep.next) />
		</cfif>

		<cfinclude template="../views/emails/placeacceptstep.cfm" />

	</cffunction>

	<cffunction
		name="placeRefuseStep"
		hint="Wysłanie wiadomości informacyjnej o odrzuceniu nieruchomości">

		<cfargument name="myinstance" type="any" required="false" />
		<cfargument name="mystep" type="any" required="false" />
		<cfargument name="myworkflow" type="any" reuired="true" />
		<cfargument name="myreason" type="any" required="true" />

		<cfset mymails = model("place_instance").getUsers(instanceid=arguments.myinstance.instanceid) />
		<cfset myuser = model("user").findByKey(arguments.myworkflow.user2) />

		<cfinclude template="../views/emails/placerefusestep.cfm" />

	</cffunction>

	<cffunction
		name="placeArchiveStep"
		hint="Wysłanie wiadomości informacyjnej o odrzuceniu nieruchomości">

		<cfargument name="myinstance" type="any" required="false" />
		<cfargument name="mystep" type="any" required="false" />
		<cfargument name="myworkflow" type="any" reuired="true" />
		<cfargument name="myreason" type="any" required="true" />

		<cfset mymails = model("place_instance").getUsers(instanceid=arguments.myinstance.instanceid) />
		<cfset myuser = model("user").findByKey(arguments.myworkflow.user2) />

		<cfinclude template="../views/emails/placearchivestep.cfm" />

	</cffunction>

	<cffunction
		name="partnerRemindPasswd"
		hint="Wysłanie wiadomości z przypomnieniem hasła">

		<cfargument name="user" type="any" required="true" />

		<cfinclude template="../views/emails/partnerremindpasswd.cfm" />

	</cffunction>

	<cffunction
		name="commentNotification"
		hint="Wysyłanie wiadomości email do autora nieruchomości"
		description="Email zawiera powiadomienie o nowododanym komentarzu do formularza nieruchomości">

		<cfargument
			name="user"
			type="any"
			required="true" />

		<cfargument
			name="instance"
			type="any"
			required="true" />

		<cfargument
			name="comment"
			type="any"
			required="true" />

		<cfset my_instance = model("trigger_place_instance").findOne(where="instanceid=#instance.id#") />
		<cfinclude template="../views/emails/comment_notifications.cfm" />

	</cffunction>

	<cffunction
		name="hello"
		hint="Wiadomość powitalna"
		description="Wiadomość powitalna">

		<cfargument
			name="user"
			type="any"
			required="true" />

		<cfinclude template="../views/emails/hello.cfm" />

	</cffunction>

	<cffunction
		name="instructionNotification"
		hint="Wysłanie informacji o dodaniu nowej instrukcji w Intranecie">

		<cfargument name="user" type="any" required="true" />
		<cfargument name="instruction" type="any" required="true" /> 

		<cfinclude template="../views/emails/instruction_notifications.cfm" />

	</cffunction>
	
	<cffunction
		name="indexNotification"
		hint="Wysłanie informacji o dodaniu nowej instrukcji w Intranecie">

		<cfargument
			name="user"
			type="any"
			required="true" />
			
		<cfargument
			name="message"
			type="any"
			required="true" />

		<cfinclude template="../views/emails/index_notifications.cfm" />

	</cffunction>
	
	<cffunction
		name="proposalPpsNotification"
		hint="Wysłanie informacji o dodaniu nowym wniosku o zmiane pps">
		
		<cfargument
			name="user"
			type="any"
			required="true" />
			
		<cfargument
			name="message"
			type="any"
			required="true" />
		
		<cfinclude template="../views/emails/proposalpps_notifications.cfm" />
		
	</cffunction>
	
	<cffunction
		name="findAllEmails"
		hint="Wyszukiwanie emaili do wysłania">
		
		<!---<cfargument name="user" type="any" required="true" />--->
		<!---<cfargument name="message" type="any" required="true" />--->
		
		<cfquery
			name="query_emails"
			result="result_emails"
			datasource="#get('loc').datasource.intranet#">
			
			select 
				e.id
				,e.subject
				,e.message
				,e.to
				,e.from
				,e.replayto
				,e.bcc
				,e.template
				,e.userid
				,e.username
				,e.createddate
				,e.senddate
				
			from emails e 
			where e.senddate is null
			order by e.createddate asc
			limit 100
			
		</cfquery>
		
		<cfreturn query_emails />
		
	</cffunction>
	
	<cffunction
		name="findAllEmailAttachments"
		hint="Wyszukiwanie załączników do maili">
		
		<cfargument name="emailid" type="numeric" required="true" />
		
		<cfquery
			name="query_email_attachments"
			result="result_email_attachments"
			datasource="#get('loc').datasource.intranet#">
			
			select 
				a.id
				,a.emailid
				,a.src
				,a.filename
			from email_attachments a 
			where a.emailid = <cfqueryparam value="#arguments.emailid#" cfsqltype="cf_sql_integer" />
			
		</cfquery>
		
		<cfreturn query_email_attachments />
		
	</cffunction>

</cfcomponent>