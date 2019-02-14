<div class="widgetBox">
<div class="inner">

	<div class="widgetHeaderArea">
		<div class="widgetHeaderArea uiWidgetHeader">
			<h3 class="uiWidgetHeaderTitle">Aktualności</h3>
		</div>
	</div>

	<div class="widgetContentArea">
		<div class="widgetContentArea uiWidgetContent">
			<ul class="uiWidgetList">
				<cfloop query="widgetPosts">
					<li>
						<a
							href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller='Posts',action='view',key=id)#</cfoutput>', 'user_profile_cfdiv');"
							title="<cfoutput>#posttitle#</cfoutput>"
							class="uiWidgetListLink">

								<h3 class="uiWidgetListItemLabel"><cfoutput>#posttitle#</cfoutput></h3>

								<span class="uiWidgetListItemContent">

								<cfif Len(filename) AND fileExists(ExpandPath("files/posts/thumb/#filename#"))>
									<cfset myImage = ImageNew(ExpandPath("files/posts/thumb/#filename#")) />
									<cfset ImageResize(myImage, 90, "", "highestperformance") />

									<span class="uiWidgetItemContentImage">
										<cfimage
											action="writeToBrowser"
											source="#myImage#" />
									</span>

								</cfif>

									<cfif Len(postcontent)>
										<cfoutput>#postcontent#</cfoutput>
									<cfelse>
										&nbsp;
									</cfif>
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