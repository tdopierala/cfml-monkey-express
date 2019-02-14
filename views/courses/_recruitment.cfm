	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pdsr_priv" >
		<cfinvokeargument name="groupname" value="Partner ds rekrutacji" />
	</cfinvoke>
	
	<cfoutput>
			<cfset counter=0 /> 
				<cfloop query="students">
				
					<cfset _steps = ListToArray(stepid) />
					<cfset _stepstatuses = ListToArray(stepstatusid) />
					
					<cfset counter++ />
					<tr data-sid="#id#">
						<td>#counter#</td>
						<td>#name#</td>
						<td>#phone#</td>
						<td>#email#</td>
						<td>#place#</td>
						<td>#username#</td>
						<td>
							<cfswitch expression="#recruitmentstatusid#">
								<cfcase value="1">
									<span>Ankieta&nbsp;rekrutacyjna</span>
								</cfcase>
								<cfcase value="2">
									<span>Spotkanie&nbsp;z&nbsp;kandydatem</span>
								</cfcase>
								<cfcase value="3">
									<span>Potwierdzenie&nbsp;chęci&nbsp;współpracy</span>
								</cfcase>
								<cfcase value="4">
									<span>Skierowanie&nbsp;na&nbsp;weryfikację&nbsp;KOS</span>
								</cfcase>
								<cfcase value="5">
									<span>Weryfikacja&nbsp;KOS</span>
								</cfcase>
							</cfswitch>
						</td>
						
						<cfif pdsr_priv is true>
							
							<cfset idx = ArrayFind(_steps, 1) />
							<cfset class="" />
							<cfif idx gt 0>
								<cfif _stepstatuses[idx] eq 1>
									<cfset class&="active_btn " />
								<cfelse>
									<cfset class&="stepactive " />
								</cfif>
							</cfif>
							
							<td class="tdstep step_button #class#" data-stepid="1">#imageTag(source="invoice.png", alt="Ankieta rekrutacyjna", title="Dodaj ankietę rekrutacyjną", width="16", height="16")#</td>
							
							<cfset idx = ArrayFind(_steps, 2) />
							<cfset class="" />
							<cfif idx gt 0>
								<cfif _stepstatuses[idx] eq 1>
									<cfset class&="active_btn " />
								<cfelse>
									<cfset class&="stepactive " />
								</cfif>
							</cfif>
							
							<td class="tdstep step_button #class#" data-stepid="2">#imageTag(source="new_tree_group.png", alt="Spotkanie", title="Spotkanie", width="16", height="16")#</td>
							
							<cfset idx = ArrayFind(_steps, 3) />
							<cfset class="" />
							<cfif idx gt 0>
								<cfif _stepstatuses[idx] eq 1>
									<cfset class&="active_btn " />
								<cfelse>
									<cfset class&="stepactive " />
								</cfif>
							</cfif>
							
							<td class="tdstep step_button #class#" data-stepid="3">#imageTag(source="stamp.png", alt="Potwierdzenie chęci współpracy", title="Potwierdź chęć współpracy", width="16", height="16")#</td>
							
							<cfset idx = ArrayFind(_steps, 4) />
							<cfset class="" />
							<cfif idx gt 0>
								<cfif _stepstatuses[idx] eq 1>
									<cfset class&="active_btn " />
								<cfelse>
									<cfset class&="stepactive " />
								</cfif>
							</cfif>
							
							<td class="tdstep step_button #class#" data-stepid="4">#imageTag(source="wap.png", alt="Przekaż do KOS", title="Przekaż do KOS", width="16", height="16")#</td>
							
						</cfif>
						
						<td>
							#linkTo(
								text=imageTag(source="materials.png", alt="podgląd kandydata", width="16", height="16"),
								title="Podgląd kandydata",
								class="vw_student",
								controller="Courses",
								action="recruitment-view",
								key=id)#
						</td>
					</tr>
				</cfloop>
	</cfoutput>