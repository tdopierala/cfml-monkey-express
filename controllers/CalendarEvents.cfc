<!---
Zarządzanie wydarzeniami w kalendarzu.
--->
<cfcomponent extends="Controller" >
	
	<cffunction name="index" hint="Lista wydarzeń użytkownika. Idektyfikator użytkownika jest przesyłany w GET.">
		<cfset calendar_events = model("calendarEvent").findAll(where="userid=#params.key#",order="startdate asc, starttime asc",include="userCalendar,calendar") >
	</cffunction>
	
	<cffunction name="add" hint="Formularz dodawania nowego wydarzenia do kalendarza">
		<cfset calendar = model("calendar").findByKey(params.key)>
		<cfset calendar_event = model("calendarEvent").new()>
	</cffunction>
	
	<cffunction name="actionAdd" hint="Dodanie nowego wydarzenia do kalendarza">
		<cfset calendar_event = model("calendarEvent").new(params.calendar_event)>
		<cfset calendar_event.calendarid = params.calendar.id>
		<cfset calendar_event.save()>
		
		<cfset redirectTo(
			controller="calendarEvents",
			action="add",
			key=params.calendar.id,
			success="Wpis do kalendarza został dodany")>
	</cffunction> 
	
	<cffunction name="view" hint="Pełny widow pojedyńczego wydarzenia. Identyfikator wydarzenia przesyłany jest w GET.">
		<cfset calendar_event = model("calendarEvent").findByKey(params.key)>
	</cffunction>

</cfcomponent>