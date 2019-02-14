<div class="widgetBox">
<div class="inner">

	<div class="widgetHeaderArea">
		<div class="widgetHeaderArea uiWidgetHeader">
			<h3 class="uiWidgetHeaderTitle">Wewnętrzne akty prawne</h3>
		</div>
	</div>

	<div class="widgetContentArea">
		<div class="widgetContentArea uiWidgetContent">
			<ul class="uiWidgetList">
				<cfloop query="widgetInstructions">
					<li>
						<a
							href="<cfoutput>#URLFor(controller='Instructions',action='view',key=instruction_id)#</cfoutput>"
							title="<cfoutput>#instruction_number#</cfoutput>"
							class="uiWidgetListLink"
							target="_blank">

								<h3 class="uiWidgetListItemLabel"><cfoutput>#instruction_number#</cfoutput></h3>

								<span class="uiWidgetListItemContent">
									<cfif Len(instruction_about)>
										<cfoutput>#instruction_about#</cfoutput>
									<cfelse>
										&nbsp;
									</cfif>
								</span>

								<span class="uiWidgetListItemContent rgt">
									<cfoutput>
										#DateFormat(instruction_created, "dd.mm.yyyy")#
									</cfoutput>
								</span>

						</a>
						
						<!---<a href="javascript:void(0)"
							onclick="javascript:showCFWindow('instruction-<cfoutput>#instruction_id#</cfoutput>', 'Podgląd dokumentu', 'index.cfm?controller=instructions&action=preview&key=<cfoutput>#instruction_id#</cfoutput>', 600, 320);"
							title="Podgląd dokumentu <cfoutput>#instruction_number#</cfoutput>"
							class="clearfix uiListLink preview {key:<cfoutput>#instruction_id#</cfoutput>}">
						
							<span class="uiListItemPreview prevInstruction {key:<cfoutput>#instruction_id#</cfoutput>}">
								Podgląd
							</span>
						
						</a>--->
						
						<a href="<cfoutput>#URLFor(controller='instructions',action='preview',key=instruction_id)#</cfoutput>" title="Podgląd dokumentu <cfoutput>#instruction_number#</cfoutput>" class="clearfix uiListLink preview {key:<cfoutput>#instruction_id#</cfoutput>}" target="_blank">
							
							<span class="uiListItemPreview prevInstruction {key:<cfoutput>#instruction_id#</cfoutput>}">
								Podgląd
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