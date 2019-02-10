<cfcomponent 
	extends="Controller">
	
	<cffunction name="init">
		<cfset super.init() />
	</cffunction>
	
	<cffunction name="index">
		<cfset sms = model("sms_notice").findAll(order="id DESC", include="sms_report") />
	</cffunction>
	
	<cffunction name="report" output="false" access="public" hint="">
		
		<cfparam name="year" type="string" default="#Year(Now())#" />
		<cfparam name="month" type="string" default="#Month(Now())#" />
		<cfparam name="groupid" type="numeric" default="0" />
		
		<cfif StructKeyExists(session, "sms_notice") &&
			StructKeyExists(session.sms_notice, "year")>
			<cfset year = session.sms_notice.year />
		</cfif>
		
		<cfif StructKeyExists(session, "sms_notice") &&
			StructKeyExists(session.sms_notice, "month")>
			<cfset month = session.sms_notice.month />
		</cfif>
		
		<cfif StructKeyExists(session, "sms_notice") &&
			StructKeyExists(session.sms_notice, "groupid")>
			<cfset groupid = session.sms_notice.groupid />
		</cfif>
		
		<cfif StructKeyExists(FORM, "year")>
			<cfset year = FORM.YEAR />
		</cfif>
		
		<cfif StructKeyExists(FORM, "month")>
			<cfset month = FORM.MONTH />
		</cfif>
		
		<cfif StructKeyExists(FORM, "groupid")>
			<cfset groupid = FORM.GROUPID />
		</cfif>
		
		<cfset session.sms_notice = {
			year = year,
			month = month,
			groupid = groupid
		} />
		
		<cfset years	=	model("workflow").getYears() />
		<cfset months	=	model("workflow").getMonths() />
		<cfset groups = model("sms_sender_group").getGroups() />
		
		<cfset reports = model("sms_notice").getReport( year = year, month = month, groupId = groupid ) />
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset renderWith(data="years,months,groups,reports",template="_report",layout=false) />
		<cfelse>
			<cfset renderPage(template="_report") />
		</cfif>
		
	</cffunction>
	
	<cffunction name="pallets" output="false" access="public" hint="">
		
		<cfparam name="year" type="string" default="#Year(Now())#" />
		<cfparam name="month" type="string" default="#Month(Now())#" />
		
		<cfif StructKeyExists(session, "sms_notice") &&
			StructKeyExists(session.sms_notice, "year")>
			<cfset year = session.sms_notice.year />
		</cfif>
		
		<cfif StructKeyExists(session, "sms_notice") &&
			StructKeyExists(session.sms_notice, "month")>
			<cfset month = session.sms_notice.month />
		</cfif>
		
		<cfif StructKeyExists(FORM, "year")>
			<cfset year = FORM.YEAR />
		</cfif>
		
		<cfif StructKeyExists(FORM, "month")>
			<cfset month = FORM.MONTH />
		</cfif>
		
		<cfset session.sms_notice = {
			year = year,
			month = month
		} />
		
		<cfset years	=	model("workflow").getYears() />
		<cfset months	=	model("workflow").getMonths() />
		
		<cfset pallets = model("sms_notice").getPallets(
			year = year,
			month = month) />
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset renderWith(data="years,months,pallets",template="_pallets",layout=false) />
		<cfelse>
			<cfset renderPage(template="_pallets") />
		</cfif>
		
	</cffunction>
	
</cfcomponent>