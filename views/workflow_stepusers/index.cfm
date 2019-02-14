<cfprocessingdirective pageencoding="utf-8" />
	
<div class="wrapper">

	<div class="admin_wrapper">
		<h2 class="admin_users">Użytkownicy w obiegu dokumentów</h2>
		
		<div class="tree_group_admin">
			<div class="inner">
				<ul class="pzwr_admin_nav">
					<li>
						<a href="javascript:void(0)" class="place_options workflow_adduser" onclick="javascript:showCFWindow('placeConnectFields', 'Dodaj użytkownika do etapu', <cfoutput>'#URLFor(controller='Workflow_stepusers',action='addUser')#'</cfoutput>, 500, 750);">
							<span>Dodaj użytkownika do etapu</span>
						</a>
					</li>

				</ul>
			</div>
		</div>
		
		<div class="tree_group_admin workflow_stepusers">
			<div class="inner">
				<cfloop collection="#workflowStepUsers#" item="i" >
					<ul class="" style="width: <cfoutput>#100/StructCount(workflowStepUsers)#</cfoutput>%; float: left;">
						<li class="title"><cfoutput>#i#</cfoutput></li>
						<cfset qry = workflowStepUsers[i] />
						<cfloop query="qry">
							<li>
									
								<cfscript>
									writeOutput("
									<span class=""uiListElement"">
										#givenname# #sn#
									</span>
									");
								</cfscript>
								
							</li>
						</cfloop>
					</ul>
				</cfloop>
				
				<div class="clear"></div>
			</div>
		</div>
		
		
	</div>

</div>