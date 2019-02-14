<cfoutput>
	
		<div class="wrapper">
			<h3>Karta ocen</h3>
				
			<div class="formbox">
				<ol class="student-details">
					<li><label>Imię i naziwsko</label> <span>#student.name#</span></li>
				</ol>
			</div>
			
			<cfloop query="lesson">
				
				<cfif rate eq ''>
					<cfset _rate = "brak" />
				<cfelse>
					<cfset _rate = rate />
				</cfif>
				
				<cfif ratedate eq ''>
					<cfset _date = "--" />
				<cfelse>
					<cfset _date = ratedate />
				</cfif>
				
				<div class="gradebook-lesson formbox">
					<div class="gradebook-subject">#subject#</div>
					<div class="gradebook-trainer">prowadzący: #givenname# #sn#</div>
					
					<cfif coursetype eq 1>
						<table class="gradebook-lesson-table">
							<tbody>
								<cfset query = lessonRates[lesson.clsid] />
								<cfloop query="query">
									
									<cfif main eq 1>
										<cfset mainclass = "main-rate" />
									<cfelse>
										<cfset mainclass = "" />
									</cfif>
										<tr class="#mainclass#">
											<td class="question">#question#:</td>
											<td class="rate">
												<strong>#rate#</strong>
											
												<cfloop index="c" from="1" to="#rate#">
													#imageTag("star_blue.png")#
												</cfloop>
												
												<cfloop index="x" from="1" to="#6-rate#">
													#imageTag("star_lightgray.png")#
												</cfloop>
											</td>
											<td>#DateFormat(ratedate, 'yyyy-mm-dd')# #TimeFormat(ratedate, 'HH:mm')#</td>
										</tr>
										
									<cfif description neq ''>
										<tr class="#mainclass#">
											<td colspan="3" class="rate-desc">#description#</td>
										</tr>
									</cfif>
								</cfloop>
							</tbody>
						</table>
					</cfif>
							
					<cfif coursetype eq 2>
						<table class="gradebook-lesson-table gradebook-checklist">
							<caption>Lista tematów</caption>
							<tbody>
								<cfset day=1 />
								<tr class="trhead">
									<td>&nbsp;</td>
									<td class="tacenter">Dzień&nbsp;#day#</td>
									<td class="tacenter">Dzień&nbsp;#(day+3)#</td>
									<td class="tacenter">Dzień&nbsp;#(day+6)#</td>
								</tr>
								
								<cfset trgroup=0 />
								<cfset points=0 />
								
								<cfloop query="checklist">
									<cfif trgroup neq topicgroupid>
										<cfif trgroup neq 0>
											<cfset day++ />
											</tbody><tbody>
												<tr class="trhead">
													<cfif topicgroupid neq 4>
														<td>&nbsp;</td>
														<td class="tacenter">Dzień&nbsp;#day#</td>
														<td class="tacenter">Dzień&nbsp;#(day+3)#</td>
														<td class="tacenter">Dzień&nbsp;#(day+6)#</td>
													<cfelse>
														<td colspan="4">&nbsp;</td>
													</cfif>
												</tr>
										</cfif>
										<cfset trgroup=topicgroupid />
									</cfif>
									
									<tr>
										<td>#topicname#</td>
										<td class="tacenter" >
											<cfif ListFind(cltc,"1") gt 0>
												#imageTag("accept.png")#
											</cfif>
										</td>
										<td class="tacenter">
											<cfif ListFind(cltc,"2") gt 0>
												#imageTag("accept.png")#
											</cfif>
										</td>
										<td class="tacenter">
											<cfif ListFind(cltc,"3") gt 0>
												#imageTag("accept.png")#
											</cfif>
										</td>
									</tr>
								</cfloop>
							</tbody>
						</table>
						
						<table class="gradebook-lesson-table gradebook-files">
							<caption>Załączniki</caption>
							<tbody>
								<cfloop query="attachments">
									<tr>
										<td>
											<cfswitch expression="#typeid#">
												<cfcase value="1">
													<!---<label>Karta oceny kandydata</label>--->
													<a href="files/courses/#filename#"><img src="images/#GetIconForFile(filename=filename)#" alt="#filename#" />&nbsp;Karta oceny kandydata</a>
												</cfcase>
												<cfcase value="2">
													<!---<label>Zaświadczenie o ukończony szkoleniu</label>--->
													<a href="files/courses/#filename#"><img src="images/#GetIconForFile(filename=filename)#" alt="#filename#" />&nbsp;Zaświadczenie o ukończony szkoleniu</a>
												</cfcase>
												<cfdefaultcase>
													<!---<label>Załącznik</label>--->
													<a href="files/courses/#filename#"><img src="images/#GetIconForFile(filename=filename)#" alt="#filename#" />&nbsp;Załącznik</a>
												</cfdefaultcase>
											</cfswitch>
										</td>
									</tr>
								</cfloop>
							</tbody>
						</table>
								
					</cfif>
					<!---<div class="gradebook-rate">ocena: <strong>#_rate#</strong>, wystawiona: #_date#</div>--->
					<!---<div class="gradebook-opinion">#opinion#</div>--->
				</div>
				
			</cfloop>
			
		</div>
	
</cfoutput>
<!---<cfdump var="#checklist#">--->
<!---<cfdump var="#lesson#">--->
<!---<cfdump var="#lessonRates#">--->
<!---<cfdump var="#attachments#">--->