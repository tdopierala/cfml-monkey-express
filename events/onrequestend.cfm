<!--- Place code here that should be executed on the "onRequestEnd" event. --->

<cfif IsDefined("session.logid") >
	<cfset tbllog = model("tbl_log").findByKey(session.logid)>
	<cfset tbllog.update(rendertime="#Now() - tbllog.logdatetime#")>
</cfif>
