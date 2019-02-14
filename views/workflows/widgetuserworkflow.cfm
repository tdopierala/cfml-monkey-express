<div class="widgetBox">
<div class="inner">

	<div class="widgetHeaderArea">
		<div class="widgetHeaderArea uiWidgetHeader">
			<h3 class="uiWidgetHeaderTitle">Faktury</h3>
		</div>
	</div>

	<div class="widgetContentArea">
		<div class="widgetContentArea uiWidgetContent">
			<ul class="uiWidgetList">
				<cfloop query="qUWidgets">
					<li class="workflowWidgetLine <cfif todelete EQ 1>strikethrough</cfif>">

						<a href="<cfoutput>#URLFor(controller='Workflows',action='tooltip',key=workflowid)#</cfoutput>"
							class="tTip"
							title="Podgląd faktury">

							<span>&nbsp;</span>

						</a>

						<a
							href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Workflows",action="edit",key=workflowid)#</cfoutput>', 'user_profile_cfdiv');"
							title="<cfoutput>#documentname#</cfoutput>"
							class="uiWidgetListLink holder"
							id="<cfoutput>#workflowid#</cfoutput>">

								<h3 class="uiWidgetListItemLabel"><cfoutput>#documentname#</cfoutput></h3>

								<span class="uiWidgetListItemContent">
									<cfif Len(contractorname)>
										<cfoutput>#contractorname#</cfoutput>
									<cfelse>
										&nbsp;
									</cfif>
								</span>

								<span class="uiWidgetListItemContent">
									<cfoutput>#DateFormat(workflowcreated, "dd-mm-yyyy")#</cfoutput>
								</span>

								<cfset dtDiff = (DateFormat(Now(), "yyyy-mm-dd") - workflowcreated) />
								<cfset daysDuration = DateFormat(dtDiff, "d") />
								<span class="uiWidgetListItemContent rgt <cfif dtDiff GT 3> uiRed </cfif>">
									<cfoutput>#dtDiff#</cfoutput> dni
								</span>

						</a>

					</li>
				</cfloop>
			</ul>
			<div class="uiWidgetFooter">

			</div>
		</div>
	</div>

	<div class="clearfix"></div>

</div>
</div>

<cfset AjaxOnLoad("initWorkflowTooltip") />