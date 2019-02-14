<cfsilent>
	<cfset intRunTimeInSeconds = DateDiff("s", GetPageContext().GetFusionContext().GetStartTime(), Now()) />	
</cfsilent>

<cfoutput>
	<div class="wrapper">

		<ul class="left">
			<li class="title">Szybkie linki</li>
			<li>
				#linkTo(
					text="Monkey Express",
					href="http://monkey.xyz")#
			</li>
	
			<li>
				#linkTo(
					text="Strona korporacyjna",
					href="http://monkey.xyz")#
			</li>
		</ul>
	
		<ul class="right">
			<li>Skontaktuj się z #mailTo(
					name="administratorem serwisu",
					emailAddress="admin@monkey.xyz")#
			</li>
		</ul>
	
		<div class="clear"></div>

		<ul class="right">
			<li>Strona wygenerowana w #intRunTimeInSeconds# sek.</li>
			<!---<cfif structKeyExists(url, "workflowCounter")>--->
				<!---<li>fv: #Application.workflowDocumentNumber#</li>--->
			<!---</cfif>--->
		</ul>	

	</div>

	<cfif isDefined("APPLICATION.bodyImportFiles")>
		<cfloop list="#APPLICATION.bodyImportFiles#" index="toLoad" delimiters="," >
			<script src="/<cfoutput>#get('loc').intranet.directory#</cfoutput>/javascripts/bodyimport/<cfoutput>#toLoad#</cfoutput>.js?<cfoutput>#DateFormat(Now(), "ddmmyyyy")##TimeFormat(Now(), "HHmmssll")#</cfoutput>" type="text/javascript"></script>
		</cfloop>
	</cfif>

</cfoutput>

<!---<cfdump var="#APPLICATION.bodyImportFiles#" />--->

<cfif structKeyExists(url, "debug")>
	<div class="debug">
	
	<h5>Cache</h5>
	<cfloop index="cache" array="#cacheGetAllIds()#">
		<cfdump var="#cacheGetMetadata(cache)#" label="#cache#" />
	</cfloop>
	
	</div>
</cfif>
