<!---  getprotocolpdf.pdf.cfm.cfc --->
<!--- @@Created By: TD Monkey Group 2012 --->
<!---
Widok generujący dokuemnt PDF z podsumowaniem nieruchomości.
Dokument prezentuje dane tekstowe zebrane z formularzy oraz galerię zdjęć/

TODO
Dorobić AJAXowe generowanie widoku. Wtedy zaoszczędzimy czas na generowaniu odpowiedniego zapytania.
	
--->
	
<cfset filename = "#ExpandPath('files/places/#place.id#/')#raport_weryfikacji_#place.id#_#DateFormat(place.placecreated, 'dd-mm-yyyy')#.pdf" />
<cfset savefilename = "raport_weryfikacji_#place.id#_#DateFormat(place.placecreated, 'dd-mm-yyyy')#.pdf" />

<cfdocument 
	format="pdf" 
	fontEmbed="yes" 
	pageType="A4" 
	name="pdfdoc">

	<style type="text/css"> 
	<!-- 
		body { font-family: "Arial"; font-size: 11px; }
		table tr td { border: 1px solid #000; }
		table tr td.btm { }
		table tr td.top { }
		li { list-style-type: none; text-align: center; margin-bottom: 12px; }
		.h1 { display: block; font-family: "Arial"; font-size: 18px; }
		.h2 { display: block; font-family: "Arial"; font-size: 18px; margin: 20px 0 10px; }
		.h3 { display: block; font-family: "Arial"; font-size: 14px; }
		.h4 { display: block; font-family: "Arial"; font-size: 12px; margin: 4px 0 8px; }
		.red { color: #eb0f0f; }
		.green { color: #75bd4e; }
		
		dl { margin: 0; }
		dl dt { background: #d7d7d7; color: #000; font-weight: normal; float: left; padding: 5px; width: 150px; clear: both; margin: 0 10px 0 0; }
		dl dd { float: left; padding: 5px 0; margin: 0 0 1px 10px; width: 150px; }
		dl .header { font-weight: bold; }
		.l { float: left; }
		.r { text-align: right; }
		.clear { clear: both; float: none; }
			
	--> 
	</style>

	<cfdocumentitem 
		type="header">
	
		<span style="font-family: 'Arial';font-size: 12px;float:left;">Moduł nieruchomości</span>
		<span style="font-family: 'Arial';font-size: 12px;float:right;">Monkey Group</span>
	
	</cfdocumentitem> 
	
	<cfdocumentitem 
		type="footer"> 
		
		<span style="font-family:'Arial';font-size:12px;float:left;">
			<cfoutput>#cfdocument.currentpagenumber#/#cfdocument.totalpagecount#</cfoutput>
		</span>
	
	</cfdocumentitem>

	<div class="heading">
		
		<cfset myImage = ImageNew("#ExpandPath('images/logo_monkey_RGB.png')#") />
		<cfset ImageResize(myImage, "50%", "", "lanczos", 1) /> 
		
		<!--- Save the modified image to a file called "test_myImage.jpeg" and display the image in a browser. ---> 
		<cfimage source="#myImage#" action="write" destination="#ExpandPath('images/777/resized_logo.png')#" overwrite="yes" />

		<div style="text-align:center;margin-bottom:20px;"><cfoutput>#imageTag(source="777/resized_logo.png")#</cfoutput></div>
		
		<span class="h1" style="text-align:center;margin-bottom:20px;">Raport weryfikacji nieruchomości</span>
		
	</div>

	<div class="clear"></div>
	
	<table cellpadding="0" cellspacing="0" style="width:100%;">
		<tr>
			<td style="width:30%;border-right:0;font-size:14px;padding:12px;"><cfoutput>#DateFormat(Now(), "dd.mm.yyyy")#</cfoutput></td>
			<td style="background-color:#efefef;font-size:14px;width:70%;padding:12px;"><cfoutput>#place.address#<br/>#place.cityname#</cfoutput></td>
		</tr>
	</table>
	
	<span class="h2">Opis nieruchomości</span>
	<table cellpadding="0" cellspacing="0" style="width:100%;">
		<!--- Zawartość tabeli --->
		<cfloop query="attributes">
			<tr>
				<td style="font-size:12px;padding:8px;border-bottom:0;border-right:0;width:40%;"><cfoutput>#attributename#</cfoutput></td>
				<td style="font-size:12px;padding:8px;border-bottom:0;width:60%;"><cfoutput>#placeattributevaluetext#</cfoutput></td>
			</tr>
		</cfloop>
		<tr>
			<td colspan="2"></td>
		</tr>
	</table>
	
	<span class="h2">Galeria</span>
	<ul>
		<cfloop query="placephotos">
			<cfif toexport neq 0>
				<li>
					<span class="h4"><cfoutput>#placefilecategoryname#</cfoutput></span>
					<cfoutput><img src="files/places/#place.id#/#filename#" /></cfoutput>
				</li>
			</cfif>
		</cfloop>
	</ul>
	
	
</cfdocument>

<cfpdf 
    action="write" 
    source="pdfdoc" 
    destination="#filename#"
    overwrite="yes" />

<cfheader name="Content-Disposition" value="inline; filename=#savefilename#" />
<cfheader name="Expires" value="#Now()#" />
<cfcontent type="application/pdf" file="#filename#" />