<div class="widgetBox">
<div class="inner">

	<div class="widgetHeaderArea">
		<div class="widgetHeaderArea uiWidgetHeader">
			<h3 class="uiWidgetHeaderTitle">Nieobecni</h3>
		</div>
	</div>

	<div class="widgetContentArea">
		<div class="widgetContentArea uiWidgetContent">
			<ul class="uiWidgetList">
				<cfloop query="qUSubstitutions">
					<li>
						<p class="uiWidgetListLink uiAvatars">

							<span class="uiWidgetListItemContent uiAvatar">
								<cfif FileExists(ExpandPath("images/avatars/thumbnailsmall")&"/#photo#")>
									<cfoutput>
                                    	#linkTo(
											text=imageTag(source="avatars/thumbnailsmall/#photo#",alt="#usergivenname#",title="#usergivenname#"),
											controller="Users",
											action="view",
											key=userid,
											title="#usergivenname#")#
                                    </cfoutput>
										<!---<cfimage
											action="writeToBrowser"
											source="#ExpandPath('images/avatars/thumbnailsmall/#photo#')#"
											alt="#usergivenname#"
											title="#usergivenname#" />--->
									
								<cfelse>
									<cfoutput>
                                    	#linkTo(
											text=imageTag(source="avatars/thumbnailsmall/monkeyavatar.png",alt="#usergivenname#",title="#usergivenname#"),
											controller="Users",
											action="view",
											key=userid,
											title="#usergivenname#")#
                                    </cfoutput>
									<!---<cfimage
										action="writeToBrowser"
										source="#ExpandPath('images/avatars/thumbnailsmall/monkeyavatar.png')#"
										alt="#usergivenname#"
										title="#usergivenname#" />--->

								</cfif>

								<span class="uiAvatarSubtitle">
									<cfoutput>#usergivenname#</cfoutput>
								</span>
							</span>

							<span class="uiWidgetListItemContent darkRed uiAvatar smallFont">
								od&nbsp;<cfoutput>#proposaldatefrom#</cfoutput>
								do&nbsp;<cfoutput>#proposaldateto#</cfoutput>
							</span>

							<span class="uiWidgetListItemContent uiAvatar">
								<cfif Len(substituteid) and FileExists(ExpandPath("images/avatars/thumbnailsmall")&"/#substitutephoto#")>
									<cfoutput>
										#imageTag(source="avatars/thumbnailsmall/#substitutephoto#",alt="#substitutename#",title="#substitutename#")#
									</cfoutput>
								<cfelseif Len(substituteid)>
									<cfoutput>
										#imageTag(source="avatars/thumbnailsmall/monkeyavatar.png",alt="#substitutename#",title="#substitutename#")#
									</cfoutput>
								</cfif>

								<span class="uiAvatarSubtitle">
									<cfoutput>#substitutename#</cfoutput>
								</span>

							</span>

						</p>
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