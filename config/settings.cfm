<!---
	If you leave these settings commented out,
	Wheels will set the data source name to the same name as the
	folder the application resides in.

--->

	<cfset set(dataSourceName="intranet")>
	<cfset set(dataSourceUserName="")>
	<cfset set(dataSourcePassword="")>


<!---
	If you leave this setting commented out, Wheels will try to determine the URL
	rewrite capabilities automatically.
	The URLRewriting setting can bet set to "On", "Partial" or "Off".
	To run with "Partial" rewriting, the "PATH_INFO" variable needs to be
	supported by the web server.
	To run with rewriting "On", you need to apply the necessary rewrite rules on
	the web server first.
	<cfset set(URLRewriting="Partial")>
--->

	<cfset set(URLRewriting="Off") >
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
<cfset set(sendEmailOnError = true)>
<cfset set(errorEmailAddress = "admin@monkey.xyz")>