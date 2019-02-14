<cfprocessingdirective pageEncoding="utf-8" />

<div class="cfwindow_container">
	<div class="inner">
		
		<div class="headerArea">
			<div class="headerArea uiHeader">
				<h3 class="uiHeaderTitle">Dodaj użytkownika do obiegu dokumentów</h3>
			</div>
		</div>
		
		<div class="contentArea">
			<div class="contentArea uiContent">
					<cfform name="workflow_add_uset_to_step_form"
							action="#URLFor(controller='Workflow_stepusers',action='adduser')#">
						<ul class="uiList uiForm">
							<li>
								<label for="user">Nazwa użytkownika</label>
								<cfinput type="text"
										 name="user"
										 class="input"
										 placeholder="Wyszukaj" />
										 
								<select name="userid" id="userid" class="select_box required"></select>
							</li>
							<li>
								<label for="workflowstepid">Etap obiegu</label>
								<cfselect 
									name="workflowstepid"
									query="workflowSteps"
									display="workflowstepstatusname"
									value="id"
									queryPosition="below"
									class="select_box required">
								
									<option value="">[wybierz]</option>
										
								</cfselect>
							</li>
							<li>
								<cfinput type="submit"
										 name="workflow_add_user_to_step_form_submit"
										 value="Dodaj"
										 class="admin_button green_admin_button" />
							</li>	
						</ul>
					</cfform>
				<div class="uiFooter">
					<cfloop collection="#workflowStepUsers#" item="i" >
						<ul class="uiFooterList" style="width: <cfoutput>#100/StructCount(workflowStepUsers)#</cfoutput>%; float: left;">
							<li class="title"><cfoutput>#i#</cfoutput></li>
							<cfset qry = workflowStepUsers[i] />
							<cfloop query="qry">
								<li>
									
									<cfscript>
										writeOutput("
										<span class=""uiListElement"">
											#givenname# #sn#
										</span>
								<a href=""#URLFor(controller='Workflow_stepusers',action='removeUser',key=id)#"" class=""remove remove_connection"">x</a>
										");
									</cfscript>
									
								</li>
							</cfloop>
						</ul>
					</cfloop>
				</div>
		
			</div>
		</div>

		<div class="footerArea">

		</div>
		
	</div>
</div>

<cfset ajaxOnLoad("initWorkflowStepUsers") />
<cfset ajaxOnLoad("validateForm") />