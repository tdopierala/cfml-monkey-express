<!--- GENERUJE DOKUMENT PDF --->
<cfsilent>

<cfdocument format="PDF" name="myPdf">

	<style type="text/css">
	<!--
		.clear { clear: both; float: none; }
		.admin_table tr td { width:100%; font-family: Arial; font-size: 12px; }
		.c { text-align: center; }
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
			Data utworzenia dokumentu: <cfoutput>#DateFormat(Now(), "dd-mm-yyyy")#&nbsp;#TimeFormat(Now(), "HH:mm:ss")#</cfoutput>
		</span>
	</cfdocumentitem>

	<cfdocumentsection >

		<div>
			<cfloop query="my_photos">
				
				<cfif not fileExists(expandPath("files/places/#phototypesrc#"))>
					<cfcontinue />
				</cfif>
				
				<div class="single_photo" style="text-align:center;margin-bottom:30px;">

					<h3 style="font-family:Arial;font-size:15px;text-align:center;font-weight:normal;"><cfoutput>#phototypename#</cfoutput></h3>

					<!---
						22.03.2013
						Jeżeli plik jest obrazkiem to tworzę z niego miniaturke.
						Jeżeli plik nie jest obrazkiem, to sprawdz, czy jest to
						pdf. Jak nie PDF to nic z nim nie robie... :)
					--->
					<cfif IsImageFile(ExpandPath("files/places/#phototypesrc#"))>

						<cfset myImage = ImageNew(ExpandPath("files/places/#phototypesrc#")) />
						<cfset ImageResize(myImage, 500, 300, "highestperformance") />
						<cfimage
							action="writeToBrowser"
							source="#myImage#" />

					<cfelseif isPDFFile(expandPath("files/places/#phototypesrc#"))>
						
						<cfpdf
							source="#ExpandPath('files/places/#phototypesrc#')#"
							action="read"
							name="myPDF"/>

						<!---
							Jak plik jest plikiem PDF to robie miniaturkę z niego
						--->
						<cfif IsPDFObject(myPDF)>

							<cfset prefix = TimeFormat(Now(), "HH_mm_ss") />
							<cfpdf
								action = "thumbnail"
								source = "#ExpandPath('files/places/#phototypesrc#')#"
								destination="#ExpandPath('files/places/pdfthumb')#"
								overwrite="yes"
								pages="1"
								imageprefix="#prefix#"
								format = "png" />

							<cfset myImage = ImageNew(ExpandPath("files/places/pdfthumb/#prefix#_page_1.png")) />
							<cfset ImageResize(myImage, 500, 300, "highestperformance") />
							<cfimage
								action="writeToBrowser"
								source="#myImage#" />

							<cffile
								action="delete"
								file="#ExpandPath("files/places/pdfthumb/#prefix#_page_1.png")#" />

						</cfif>

					</cfif>

				</div>
			</cfloop>
		</div>

	</cfdocumentsection>

</cfdocument>

</cfsilent>

<!--- NAGŁÓWEK DOKUMENTU PRZEKAZANY DO PRZGLĄDARKI --->
<cfheader name="Content-Disposition" value="inline; filename=#DateFormat(Now(), 'dd.mm.yyyy')#-#TimeFormat(Now(), 'HH:mm:ss')#.pdf" />

<!--- TREŚĆ DOKUMENTU --->
<cfcontent type="application/pdf" variable="#myPdf#" />