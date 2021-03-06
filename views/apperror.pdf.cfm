<cfset filename = "#ExpandPath('files/protocols/')##ReplaceNoCase(protocol.protocolnumber, '/', '_', 'all')#_#DateFormat(protocol.instance_created, 'dd-mm-yyyy')#.pdf" />
<cfset savefilename = "#ReplaceNoCase(protocol.protocolnumber, '/', '_', 'all')#_#DateFormat(protocol.instance_created, 'dd-mm-yyyy')#.pdf" />

<cfif FileExists(filename)>

	<cfheader name="Content-Disposition" value="inline; filename=#savefilename#" />
	<cfheader name="Expires" value="#Now()#" />
	<cfcontent type="application/pdf" file="#filename#" />
	
<cfelse>

	<cfdocument format="pdf" fontEmbed="yes" pageType="A4" name="protocolpdf">
	
	<style type="text/css" media="screen">
	<!--
	  @import url("stylesheets/protocolpdf.css");
	-->
	</style>
	
		<div class="wrapper pdf">
		
			<span class="h1">Wystąpił błąd przy generowaniu dokumentu</span>
		
		</div> <!--- koniec wrapper dla ca?ego widoku --->
	
	</cfdocument>
	
	<cfpdf 
	    action = "write" 
	    source = "protocolpdf" 
	    destination="#filename#"
		overwrite="yes" />
	
	<cfheader name="Content-Disposition" value="inline; filename=#savefilename#" />
	<cfheader name="Expires" value="#Now()#" />
	<cfcontent type="application/pdf" file="#filename#" />

</cfif>