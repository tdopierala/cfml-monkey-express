<cfset filename = "#ExpandPath('files/ideas/')#Idea-#idea.id#-#DateFormat(idea.date, 'dd-mm-yyyy')#.pdf" />
<cfset savefilename = "Idea-#idea.id#-#DateFormat(idea.date, 'dd-mm-yyyy')#.pdf" />

<!--- Jeśli plik już istnieje to go usuwam i generuje nowy --->
<cfif FileExists(filename)>
	<cffile action="delete" file="#filename#">
</cfif>

<cfdocument format="pdf" fontEmbed="yes" pageType="A4" name="protocolpdf">

<style type="text/css" media="screen">
<!--
	div, span, strong { font-family: "Tahoma" !important; }
	.pdf { font-family: "Tahoma"; font-size: 13px; line-height: 1.3em; }
	.contactincofmation { font-size: 12px; color: #eb0f0f; margin: 10px 0; line-height: 1.3em; }
	.h0 { color: #eb0f0f; font-size: 16px; display: block; margin-bottom: 2px; }
	.h1 { display: block; font-size: 18px; text-align: center; margin: 40px 0; }
	.h2 { display: block; font-size: 16px; text-align: left; margin: 50px 0 10px; }
	.b { font-weight: bold; }
	
	.idea-details { /*font-style: italic;*/ font-size: 10px; }
	.idea-main-text { margin: 5px; padding: 0 10px; }
	.idea-main-head { margin-top: 25px; font-weight: bold; }
	
	.idea-comment { margin: 10px 0; }
	.idea-commentdetails { /*font-style: italic;*/ font-size: 10px; padding: 2px 0; }
	.idea-commenttext { padding-bottom: 5px; }
	.subcomment { margin-left: 20px; }
-->
</style>

	<div class="wrapper pdf">
	
		<cfoutput>#imageTag("logo_monkey_RGB.png")#</cfoutput>
		
		<div class="contactincofmation">
			<span class="h0">Monkey Group</span>ul. Wojskowa 6, 60-792 Poznań
		</div>
		
		<h1><cfoutput>#idea.title#</cfoutput></h1>
				
		<cfset counter = 0 />
		<cfloop query="texts">
			<cfset counter = counter + 1 />
			<div class="idea-text">
				<div class="idea-details">
					<cfoutput>Dodał: #texts.givenname# #texts.sn#
					<cfif texts.partner_prowadzacy_sklep eq 1>
						(#texts.login#)
					</cfif>
					, #DateFormat(texts.date, "yyyy.mm.dd")# #TimeFormat(texts.date, "HH:mm:ss")#</cfoutput>
				</div>
				<!---<div class="idea-main-head">Treść pomysłu:</div>--->
				<div class="idea-main-text"><cfoutput>#texts.text#</cfoutput></div>
						
				<cfif counter lte 1>
					<div class="idea-main-head">Uzasadnienie pomysłu:</div>
					<div class="idea-main-text"><cfoutput>#texts.reason#</cfoutput></div>
				</cfif>
						
				<div class="idea-details-files">
					<cfloop query="files">
						<cfif files.textid eq texts.id>
									
							<cfswitch expression="#files.ext#">
								<cfcase value="jpg">
									<cfoutput><img width="600" src="files/ideas/#files.file#" alt="#files.file#" /></cfoutput>
								</cfcase>
										
								<cfcase value="png">
									<cfoutput><img width="600" src="files/ideas/#files.file#" alt="#files.file#" /></cfoutput>
								</cfcase>
							</cfswitch>
									
						</cfif>
					</cfloop>
					<div style="clear:both;"></div>
				</div>
			</div>				
		</cfloop>
		
		<div class="idea-main-head">Komentarze:</div>	
		<cfloop query="comments">
				
			<cfif comments.parent eq 0 >
				<cfoutput>
					<div class="idea-comment">
						<div class="idea-commentdetails">
							<span>[#DateFormat(comments.date, "yyyy.mm.dd")# #TimeFormat(comments.date, "HH:mm:ss")#]</span>
							<strong>#comments.givenname# #comments.sn#</strong> (#userStatus(comments)#)
						</div>
						<div class="idea-commenttext">
							#comments.text#
						</div>
					</div>
						
					<cfset tmp_id = comments.id />
					<cfloop query="subcomments">
								
						<cfif subcomments.parent eq tmp_id>
							<div class="idea-comment subcomment">
								<div class="idea-commentdetails">
									<span>[#DateFormat(subcomments.date, "yyyy.mm.dd")# #TimeFormat(subcomments.date, "HH:mm:ss")#]</span>
									<strong>#subcomments.givenname# #subcomments.sn#</strong> (#userStatus(subcomments)#)
								</div>
								<div class="idea-commenttext">
									#subcomments.text#
								</div>
							</div>						
						</cfif>
							
					</cfloop>
				</cfoutput>
			</cfif>
				
		</cfloop>
		
		<div class="idea-main-head">Komentarze komisji:</div>
		<cfloop query="vipcomments">
			<cfoutput>
				<cfif vipcomments.parent eq 0 >
					
					<div class="idea-comment">
						<div class="idea-commentdetails">
							<span>[#DateFormat(vipcomments.date, "yyyy.mm.dd")# #TimeFormat(vipcomments.date, "HH:mm:ss")#]</span>
							<strong>#vipcomments.givenname# #vipcomments.sn#</strong> (#userStatus(vipcomments)#)
						</div>
						<div class="idea-commenttext">
							#vipcomments.text#
						</div>
					</div>
						
					<cfset tmp_id = vipcomments.id />
					<cfloop query="vipsubcomments">
								
						<cfif vipsubcomments.parent eq tmp_id>
							<div class="idea-comment subcomment">
								<div class="idea-commentdetails">
									<span>[#DateFormat(vipsubcomments.date, "yyyy.mm.dd")# #TimeFormat(vipsubcomments.date, "HH:mm:ss")#]</span>
									<strong>#vipsubcomments.givenname# #vipsubcomments.sn#</strong> (#userStatus(vipsubcomments)#)
								</div> 
								<div class="idea-commenttext">
									#vipsubcomments.text#
								</div>
							</div>
						</cfif>
							
					</cfloop>

				</cfif>
			</cfoutput>	
		</cfloop>
		
		<div class="idea-main-head">Historia głosowania:</div>
		<cfloop query="history">
			<cfif history.activity gte 6 and history.activity lte 8>
				<div class="idea-vote-list">
					<div class="idea-details">
						<cfoutput>
                        	[#DateFormat(history.date, "yyyy.mm.dd")# #TimeFormat(history.date, "HH:mm:ss")#]  
							#history.givenname# #history.sn# #history.name# <strong>#history.idea_statusName#</strong>
                        </cfoutput>
					</div>
				</div>
			</cfif>
		</cfloop>
	</div>

</cfdocument>

<cfpdf 
    action = "write" 
    source = "protocolpdf" 
    destination="#filename#"
	overwrite="yes" />

<cfheader name="Content-Disposition" value="inline; filename=#savefilename#">
<!---<cfcontent type="application/octet-stream" file="#filename#" deletefile="Yes">--->

<cfheader name="Expires" value="#Now()#" />
<cfcontent type="application/pdf" file="#filename#" />