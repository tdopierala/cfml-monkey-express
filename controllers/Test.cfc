<cfcomponent extends="Controller"> 
	
	<cffunction name="init">
    	<cfset super.init() />
    	<cfset usesLayout(template="/layout.cfm", only="canvas", useDefault="false")>
	</cffunction>

	
	<cffunction name="index">		
			<cfscript>				
				myfile = FileOpen("#ExpandPath("files/brandbank_productdata/2014-02-28_11-12-37.xml")#", "read");				
				xml = FileRead(myfile, 449);				
				x = Right(xml, 36);				
				FileClose(myfile);
			</cfscript>
	</cffunction>
	
	<cffunction 
		name="indexestest">
			
		<cfset _product = StructNew()>
		<cfset myVariable = StructInsert(_product,"abc","ColdFusion 'MX' Bible")>
		<cfset myVariable = StructInsert(_product,"xyz","HTML ""Visual"" QuickStart")>
		<cfset myVariable = StructInsert(_product,"qwe","Inside 'XML")>
		
		<cfloop collection="#_product#" item="idx">
			<cfset StructUpdate(_product, idx, cf_escape_string(StructFind(_product, idx))) />
			
			<cfset StructUpdate(_product, idx, ReplaceNoCase(_product[idx], '"', '""', "all")) />
    	</cfloop>
		
		<cfset variable = _product />
		<cfset renderWith(data="variable",template="/dump",layout=false) />
	</cffunction>
	
	<cffunction 
		name="canvas">
			
		
		
	</cffunction>
	
	<cffunction 
		name="test" output="false" access="public" hint="To jest hint dla metody test komponentu Test">
		
		<cfset variable = This />
		<cfset renderWith(data="variable",template="/dump",layout=false) />
		
	</cffunction>
	
	<cffunction name="sms">
		
		<cfset sms = {
			nr = "600364485",
			text = "Twoj numer zostal przypisany do konta o loginie: kistom"
		}>
		
		<cfhttp
			url="http://api.smsapi.pl/sms.do?"
			resolveurl="Yes"
			throwOnError="No"
			result="status"
			timeout="60" >

		</cfhttp>
		
		<cfmail
			to="dopiet@monkey"
			from="SMS - Monkey <intranet@monkey>"
			replyto="intranet@monkey"
			subject="SMS"
			type="html">

			<cfdump var="#status#" />
			<cfdump var="#sms#" />

		</cfmail>
		
		<cfset renderNothing() />
		
	</cffunction>
	
	<cffunction
		name="stores" output="false" access="public" hint="">
		
		<cfset APPLICATION.cfc.asseco.setDatasource(datasource="asseco") />
		<cfset stores = APPLICATION.cfc.asseco.getStores() />
		
		<cfset variable = stores />
		<cfset renderWith(data="variable",template="/dump",layout=false) />
	</cffunction>
	
	<cffunction 
		name="sales" output="false" access="public" hint="">
		
		<cfset var asseco = createObject("component", "cfc.assecoConnector").init(
			assecoConnectorDsn = "assecoConnector",
			intranetDsn = "intranet",
			assecoDsn = "asseco") />
			
		<cfset salesreport = asseco.salesContestReport3() />
		
		<cfset variable = salesreport />
		<cfset renderWith(data="variable",template="/dump",layout=false) />
		
		
	</cffunction>
	
	<cffunction 
		name="salesperday" output="false" access="public" hint="">
		
		<cfset var asseco = createObject("component", "cfc.assecoConnector").init(
			assecoConnectorDsn = "assecoConnector",
			intranetDsn = "intranet",
			assecoDsn = "asseco") />
			
		<cfset salesreport = asseco.salesContestReport2() />
		
		<cfset variable = salesreport />
		<cfset renderWith(data="variable",template="/dump",layout=false) />
		
		
	</cffunction>
	
	<cffunction 
		name="salesreport" output="false" access="public" hint="">
		
		<cfset var asseco = createObject("component", "cfc.assecoConnector").init(
			assecoConnectorDsn = "assecoConnector",
			intranetDsn = "intranet",
			assecoDsn = "asseco") />
		
		<cfset salessum = asseco.salesContestReport3() />
		<cfset salesdayly = asseco.salesContestReport2() />
		
		
	</cffunction>
	
	<cffunction 
		name="workflowstep" output="false" access="public" hint="">
				
		<cfset ws = model("workflowStep").findOne(where="workflowid=#params.key#", order="workflowstepcreated DESC") />
		
		<cfset ws.workflowsteptransfernote = 'test' />
		<cfset ws.save(callbacks=false) />
		
		<cfset variable = ws />
		<cfset renderWith(data="variable",template="/dump",layout=false) />
		
		
	</cffunction>
	
	<cffunction 
		name="apilogin">
		
		<cfhttp 
			url = "http://intranet.monkey/api/index.cfm?controller=authentication&action=login"
			method = "POST"
			result = "httpResult">
			
			<cfhttpparam type="FormField" name="userlogin" value="B12011" />
			
			<cfhttpparam type="FormField" name="userpassword" value="WCAKUSW6PPH" />
			
			<cfhttpparam type="FormField" name="token" value="#Hash(DateFormat(Now(),"yyyymmdd")&TimeFormat(Now(),"HHmm")&get('loc').intranet.securitysalt)#" />
		
		</cfhttp>
		
		<cfset xmldoc = XmlParse(httpResult.Filecontent) />
	
		<cfset variable  = xmldoc />
		<cfset renderWith(data="variable",template="/dump",layout=false) />
	
	</cffunction>
	
</cfcomponent>