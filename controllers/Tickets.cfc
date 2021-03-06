<!--- 
Komponent obsługujący zgłoszenia błędów w systemie.
Wysyłany jest email do administratora/programisty. Nadawany jest status błędu. Przy odpowiedzi wybiera się status zgłoszonego błędu.
--->
<cfcomponent extends="Controller">

	<cffunction name="init">
	
		<cfset super.init()>
	
	</cffunction>
	
	<cffunction name="index" hint="Lista wszystkich zgłoszonych błędów w systemie. 
									Zgłoszenia są paginowane po 20 na stonie i sortowane po dacie dodania.">
	
		<cfif !IsDefined("params.page")>
		
			<cfset params.page = 1>
		
		</cfif>
		
		<cfset tickets = model("ticket").findAll(page=params.page,perPage=20,include="ticketStatus")>
	
	</cffunction>
	
	<cffunction name="add" hint="Formularz dodawania nowego zgłoszenia">
	
		<cfset tickettypes = model("ticketType").findAll()>
		<cfset ticket = model("ticket").new()>
			
	</cffunction>
	
	<cffunction name="actionAdd" hint="Zapisanie nowego zgłoszenia w bazie danych">	
		
		<cfset ticket = model("ticket").new(params.ticket)>
		<cfset ticket.ticketcreated = Now()>
		<cfset ticket.userid = session.userid>
		<cfset ticket.ticketstatusid = -1>
		
		<!---
		Wysłanie wiadomości email o nowym wpisie
		--->
		<cfset ticket.save()>
		
		<cfset redirectTo(controller="tickets",action="index",success="Twoje zgłoszenie zostało dodane")>
	
	</cffunction>

</cfcomponent>