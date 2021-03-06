<cfoutput>
<!---	<div class="workflowfilters">
		#startFormTag(controller="Users",action="getUserActiveWorkflow",key=session.userid,class="workflowfiltersform")#
		<ol>
			<cfif IsDefined("types")>
				<li>
					#selectTag(
						name="typeid",
						options=types,
						label="Typ faktury",
						labelPlacement="before")#
				</li>
				<li>
					#submitTag(value=">>",class="cssbutton filterworkflows")#
				</li>
			</cfif>
		</ol>
		#endFormTag()#
	</div>--->
	
	<div class="workflowActions">
		<ul>
			<!---
				04.02.2013
				Grupowe akceptowanie jest dostępne tylko dla dyrektorów i
				Controllingu.
			--->
			<cfif checkUserGroup(userid=session.userid,usergroupname="root") OR
				checkUserGroup(userid=session.userid,usergroupname="Dyrektorzy") OR
				checkUserGroup(userid=session.userid,usergroupname="Controlling")>
					
			<li class="accept_workflow_elements">
				#linkTo(
					text="<span>zaakceptuj zaznaczone</span>",
					controller="Workflows",
					action="acceptGroup",
					class="acceptGroup",
					title="Zaakceptuj zaznaczone dokumenty")#
			</li>
			
			</cfif>
			
			<li class="moveWorkflowElements">
				#linkTo(
					text="<span>przekaż zaznaczone</span>",
					controller="Workflows",
					action="moveWorkflowStep",
					class="moveWorkflowStep",
					title="Przekaż zaznaczony/e dokument/y")#
			</li>
		</ul>
	</div>
</cfoutput>

<div class="clear"></div>