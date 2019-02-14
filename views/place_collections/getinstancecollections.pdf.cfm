<!--- GENERUJE DOKUMENT PDF --->
<cfsilent>

<!---<cfscript>
function atan2(firstArg, secondArg) {
   Math = createObject("java","java.lang.Math");
   return 
Math.atan2(javacast("double",firstArg),javacast("double",secondArg));
}
</cfscript>

	<cffunction name="C">
		<cfargument name="lat" type="numeric" required="false" />
		<cfargument name="lng" type="numeric" required="false" />
		<cfargument name="rad" type="numeric" required="false" />
		<cfargument name="detail" type="numeric" default="8" required="false" />
		
		<cfset R = 6371 />
		<cfset lat = (arguments.lat * Pi()) / 180 />
		<cfset lng = (arguments.lng * Pi()) / 180 />
		<cfset d = arguments.rad / R />
		
		<cfset points = ArrayNew(1) />
 		<cfset i = 0 />
		
		<cfloop condition="i neq 360" >
		
			<cfset brng = i * Pi() / 180 />
			<cfset plat = ASin(Sin(lat)*Cos(d) + Cos(lat)*Sin(d)*Cos(brng)) />
			<cfset plng = ((lng + atan2(Sin(brng)*Sin(d)*Cos(lat), Cos(d)-Sin(lat)*Sin(plat))) * 180) / Pi() />
			
			<cfset points = [lat,lng] />
			<cfset i++ />
		
		</cfloop>

 		<cfreturn points />
	
	</cffunction>--->


	
	<cfset key = "AIzaSyCbhawdE5RviSqV-G2hUknkYambol6zh2U" />
	<cfset size = "640x480" />
	<cfset loc = myinstance.instanceplace & " " & myinstance.instancestreet & " " & myinstance.streetnumber & " " & myinstance.instancepostalcode />
	<cfset zoom = 15 />
	<cfset monkeyicon = "http://monkey.xyz/pinezka_otwarta_1.png" />
	<cfset img = "http://maps.google.com/maps/api/staticmap?center=#urlEncodedFormat(loc)#&zoom=#zoom#&key=#urlEncodedFormat(key)#&sensor=false&size=#size#&markers=icon:#urlEncodedFormat(monkeyicon)#%7Cshadow:false%7C" & urlEncodedFormat(loc) />
	<cfset i = 1 />
	
	<cfloop query="mycollections">
		
		<cfset img &= "&markers=color:red%7Clabel:" & i & "%7C" & urlEncodedFormat("#rivalstreet# #rivalstreetnumber#,#rivalcity#,#rivalprovince#") />
		<cfset i++ />
		
	</cfloop>
	
	<cfset img &= "&scale=1" />

<cfdocument format="PDF" name="myPdf">
	
	<style type="text/css"> 
	<!-- 
	
		.clear { clear: both; float: none; }
		.admin_table tr td { width:100%; font-family: Arial; font-size: 12px; }
	--> 
	</style>
	
	<cfdocumentitem type="header" >
		<span style="font-family:Arial;font-size:12px;float:left;">
			Monkey Group, 
			ul. Wojskowa 6,
			60-792&nbsp;Poznań
		</span>
	</cfdocumentitem>

	<cfdocumentitem type="footer" >
		<span style="font-family:Arial;font-size:12px;float:left;">
			<cfoutput>#cfdocument.currentpagenumber#/#cfdocument.totalpagecount#</cfoutput>
		</span>
		
		<span style="font-family:Arial;font-size:12px;float:right;text-align:right;">
			Zbiór: <cfoutput>#mycollection.collectionname#</cfoutput><br />
			Data utworzenia dokumentu: <cfoutput>#DateFormat(Now(), "dd.mm.yyyy")# #TimeFormat(Now(), "HH:mm:ss                 ")#</cfoutput>
		</span>
	</cfdocumentitem>
	
	<cfdocumentsection >
		
		<div style="float:left;width:100%;">
			<h3 style="font-family:Arial;font-size:14px;font-weight:normal;">Nieruchomość</h3>
			<p style="font-family:Arial;font-size:12px"><cfoutput>#myinstance.instancestreet#</cfoutput></p>
			<p style="font-family:Arial;font-size:12px"><cfoutput>#myinstance.instanceplace#, #myinstance.instancepostalcode#</cfoutput></p>
		</div>
		
		<div class="clear">&nbsp;</div>
		
		<h1 style="font-family:Arial;font-size:18px;font-weight:normal;text-align:center"><cfoutput>#mycollection.collectionname#</cfoutput></h1>
		
		<div style="width:100%;text-align:center;">
			<cfoutput><img src="#img#" /></cfoutput>
		</div>
		
		<div style="width:640px;margin:20px auto 0;">
			<cfset i = 1 />
			<cfloop query="mycollections">
				<div style="width:300px;float:left;margin:0 10px;">
					<h4 style="font-family:Arial;font-weight:normal;font-size:14px;"><cfoutput>#i# #rivalname#</cfoutput></h4>
					
					
					<cfif Len(file_thumb) GT 0 and fileExists("#expandPath('files/collections/#file_thumb#')#")>
						
						<cfimage source="#expandPath('files/collections/#file_thumb#')#" action="writeToBrowser" />
									
					</cfif>
					
					<p style="font-family:Arial;font-size:10px;"><cfoutput>#rivalstreet# #rivalstreetnumber#<cfif Len(rivalhomenumber)>/#rivalhomenumber#</cfif></cfoutput></p>
					<p style="font-family:Arial;font-size:10px"><cfoutput>#rivalcity#, #rivalprovince#</cfoutput></p>
					<p style="font-family:Arial;font-size:10px;">Godziny otwarcia: <cfoutput>#otwarte_od# - #otwarte_do#</cfoutput></p>
					<p style="font-family:Arial;font-size:10px;">Szacowany obrót: <cfoutput>#szacowany_obrot#</cfoutput></p>
					<p style="font-family:Arial;font-size:10px;">Liczba klientów: <cfoutput>#liczba_klientow#</cfoutput></p>
				</div>
			<cfset i++ />
			</cfloop>
		</div>
		
	</cfdocumentsection>

</cfdocument>

</cfsilent>

<!--- NAGŁÓWEK DOKUMENTU PRZEKAZANY DO PRZGLĄDARKI --->
<cfheader name="Content-Disposition" value="inline; filename=#DateFormat(Now(), 'dd.mm.yyyy')#-#TimeFormat(Now(), 'HH:mm:ss')#.pdf" />

<!--- TREŚĆ DOKUMENTU --->
<cfcontent type="application/pdf" variable="#myPdf#" />
