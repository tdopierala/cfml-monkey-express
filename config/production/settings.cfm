<!---
	This file is used to configure specific settings for the "production" environment.
	A variable set in this file will override the one in "config/settings.cfm".
	Example: <cfset set(errorEmailAddress="someone@somewhere.com")>
--->

<cfset set(showDebugInformation=false)>

<!---
	Ustawienia konta email, z którego będą wychodziły powiadomienia, np. o
	obiegu dokumentów.
--->

	<cfset set(
		functionName="sendEmail",
		server="coldfusion.mc",
		username="",
		password="") />

<!---
	Wysyłanie wiadomości email o błędzie w systemie.
--->
<cfset set(sendEmailOnError = true) />
<cfset set(errorEmailAddress = "admin@monkey.xyz") />

<!---

	Cache elementów Intranetu
--->
<cfset set(cacheImages = true) />	<!--- Cache dla obrazków --->
<cfset set(cachePartials = false) />	<!--- Cache dla elementów widoków --->