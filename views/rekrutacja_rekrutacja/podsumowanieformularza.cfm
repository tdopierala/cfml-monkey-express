<cfdocument format="PDF" name="myPdf">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Test</title>
<style type="text/css">
	body { font-family:"Tahoma"; line-height:1.8em; }
	ul li { list-style-type: none; display: block; font-style: italic; }
	ul li span { display: inline-block; width: 250px; font-style: normal; }
@font-face { font-family:"Arial"; }
@font-face { font-family:"Lucida Sans Unicode"; }
@font-face { font-family:"Tahoma"; }
</style>
</head>
<body>
	<h3 style="font-size:14pt;font-weight: normal;">Podsumowanie rekrutacji</h3>
	
	<ul>
		<cfoutput query="formularz">
			<cfif Len(WARTOSCPOLAFORMULARZA) GT 0>
				<li><span>#NAZWAPOLA#:</span> #WARTOSCPOLAFORMULARZA#</li>
			</cfif>
		</cfoutput>
	</ul>
	
	<h3 style="font-size:14pt;font-weight: normal;">Ankiety</h3>
	<cfloop collection="#ankiety#" item="a">
		<h5 style="font-size:10pt; text-decoration:underline;font-weight: normal;"><cfoutput>#ankiety[a]["NAZWAANKIETY"]#</cfoutput></h5>
		<cfset polaAnkiety = ankiety[a]["POLAANKIETY"] />
		
		<ul>
		<cfloop query="polaAnkiety" >
			<cfif Len(WARTOSCPOLAANKIETY) gt 0>
				<cfoutput>
				<li><span>#polaAnkiety.NAZWAPOLA#:</span> #polaAnkiety.WARTOSCPOLAANKIETY#</li>
				</cfoutput>
			</cfif>
		</cfloop>
		</ul>
		
	</cfloop>
	
	<div style="border:1px solid ##000000; padding:10px;">Brak danych oznacza, że pola nie zostały zapisane w formularzu lub ankiecie.</div>
	 
</body>
</html>
</cfdocument>

<cfheader name="Content-Disposition" value="attachment; filename=myFile.pdf">
<cfcontent type="application/pdf" reset="true" variable="#toBinary(myPdf)#">