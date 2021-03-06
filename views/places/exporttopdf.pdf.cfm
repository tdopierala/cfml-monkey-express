<!---  getprotocolpdf.pdf.cfm.cfc --->
<!--- @@Created By: TD Monkey Group 2012 --->
<!---
Widok generujący dokuemnt PDF z podsumowaniem nieruchomości.
Dokument prezentuje dane tekstowe zebrane z formularzy oraz galerię zdjęć/

TODO
Dorobić AJAXowe generowanie widoku. Wtedy zaoszczędzimy czas na generowaniu odpowiedniego zapytania.
	
--->
	
<cfset filename = "#ExpandPath('files/places/')#place_#place.id#_#DateFormat(place.placecreated, 'dd-mm-yyyy')#.pdf" />
<cfset savefilename = "place_#place.id#_#DateFormat(place.placecreated, 'dd-mm-yyyy')#.pdf" />

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
		.h1 { display: block; font-family: "Arial"; font-size: 22px; }
		.h2 { display: block; font-family: "Arial"; font-size: 18px; margin: 20px 0 10px;  }
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
		.c { text-align: center; }
			
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
		
		<span style="font-family:'Arial';font-size:12px;float:right;">
			<cfoutput>Data wygenerowania dokumentu #DateFormat(Now(), 'dd-mm-yyyy')# godz. #TimeFormat(Now(), 'HH:mm')#</cfoutput>
		</span>
	
	</cfdocumentitem>

	<div class="heading">
		
		<cfset myImage = ImageNew("#ExpandPath('images/logo_monkey_RGB.png')#") />
		<cfset ImageResize(myImage, "50%", "", "lanczos", 1) /> 
		
		<!--- Save the modified image to a file called "test_myImage.jpeg" and display the image in a browser. ---> 
		<cfimage source="#myImage#" action="write" destination="#ExpandPath('images/777/resized_logo.png')#" overwrite="yes" />

		<div style="text-align:center;margin-bottom:20px;"><cfoutput>#imageTag(source="777/resized_logo.png")#</cfoutput></div>
		
		<span class="h1" style="text-align:center;margin-bottom:20px;">Pełny opis nieruchomości</span>
	</div>

	<div class="clear"></div>
	
	<table cellpadding="0" cellspacing="0" style="width:100%;">
		<tr>
			<td class="c" style="width:25%;border-right:0;font-size:14px;padding:12px;">
				<cfoutput>#DateFormat(Now(), "dd.mm.yyyy")#</cfoutput>
			</td>
			<td class="c" style="background-color:#efefef;font-size:14px;width:50%;padding:12px;border-right:0;">
				<cfoutput>#place.address#<br/>#place.cityname#</cfoutput>
			</td>
			<td class="c" style="background-color:#efefef;font-size:14px;width:255;padding:12px;">
				<cfoutput>#place.user.givenname# #place.user.sn#</cfoutput>
			</td>
		</tr>
	</table>
	
	<span class="h2">Opis nieruchomości</span>
	<table cellpadding="0" cellspacing="0" style="width:100%;">
		<!--- Zawartość tabeli --->
		<cfloop collection="#r#" item="i">

			<cfset q = r[i] />
			<cfloop collection="#q#" item="p">

				<tr>
					<td colspan="2" style="font-size:14px;border-bottom:0;padding:8px 0;text-align:center;background-color:#FFFACD;">
						<cfoutput>#p#</cfoutput>
					</td>
				</tr>

				<cfset s = q[p] />
				<cfif s.recordCount>
					<cfloop query="s">
						<tr>
							<td style="font-size:12px;padding:8px;border-bottom:0;border-right:0;width:40%;"><cfoutput>#attributename#</cfoutput></td>
							<td style="font-size:12px;padding:8px;border-bottom:0;width:60%;"><cfoutput>#placeattributevaluetext#</cfoutput></td>
						</tr>
					</cfloop>

				</cfif>

			</cfloop>
	
		</cfloop>


<!---
		<cfloop collection="#r#" item="i">
			<tr>
				<td colspan="2" style="font-size:14px;border-bottom:0;padding:8px 0;text-align:center;background-color:#FFFACD;">
					<cfoutput>#i#</cfoutput>
				</td>
			</tr>
			<cfset q = r[i] />
			<cfif q.recordCount>
				<cfloop query="q">
					<tr>
						<td style="font-size:12px;padding:8px;border-bottom:0;border-right:0;width:40%;"><cfoutput>#attributename#</cfoutput></td>
						<td style="font-size:12px;padding:8px;border-bottom:0;width:60%;"><cfoutput>#placeattributevaluetext#</cfoutput></td>
					</tr>
				</cfloop>
			</cfif>
		</cfloop>
--->
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

	<!---
	<span class="h2">Historia</span>
	
	<dl class="workflow">
		<dt class="header">Osoba</dt>
		<dd class="header">Etap</dd>
		<dd class="header">Status</dd>
		<dd class="header">Data</dd>
		
		<cfloop query="placeworkflow">
			<dt><cfoutput>#givenname# #sn#</cfoutput></dt>
			<dd><cfoutput>#placestepname#</cfoutput></dd>
			<cfif placestatusid eq 2>
			
				<dd class="green"><cfoutput>#placestatusname#</cfoutput></dd>
			
			<cfelseif placestatusid eq 3>
			
				<dd class="red"><cfoutput>#placestatusname#</cfoutput></dd>
			
			<cfelse>
			
				<dd><cfoutput>#placestatusname#</cfoutput></dd>
				
			</cfif>
			<dd><cfoutput>#DateFormat(placeworkflowstart, 'dd.mm.yyyy')# #TimeFormat(placeworkflowstart, 'HH:mm')#</cfoutput></dd>
			
			<cfif Len(placeworkflowstop)>
			
				<dt><cfoutput>#newgivenname# #newsn#</cfoutput></dt>
				<dd><cfoutput>#placestepname#</cfoutput></dd>
				
				<cfif newplacestatusid eq 2>
	
					<dd class="green"><cfoutput>#newplacestatusname#</cfoutput></dd>
					
				<cfelseif newplacestatusid eq 3>
				
					<dd class="red"><cfoutput>#newplacestatusname#</cfoutput></dd>
				
				<cfelse>
				
					<dd><cfoutput>#newplacestatusname#</cfoutput></dd>
				
				</cfif>
				
				<dd><cfoutput>#DateFormat(placeworkflowstop, 'dd.mm.yyyy')# #TimeFormat(placeworkflowstop, 'HH:mm')#</cfoutput></dd>
			
			</cfif>
		</cfloop>
	</dl>
	--->
	
</cfdocument>

<cfpdf 
    action="write" 
    source="pdfdoc" 
    destination="#filename#"
    overwrite="yes" />

<cfheader name="Content-Disposition" value="inline; filename=#savefilename#" />
<cfheader name="Expires" value="#Now()#" />
<cfcontent type="application/pdf" file="#filename#" />