<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Aktualności</h3>
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent">
		<ul class="uiList">
			<cfloop query="qPosts">
				<li>


					<a
						href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller='Posts',action='view',key=id)#</cfoutput>', 'user_profile_cfdiv');"
						title="<cfoutput>#posttitle#</cfoutput>"
						class="uiListLink clearfix">
							<h3 class="uiListItemLabel">
								<cfoutput>#posttitle#</cfoutput>
							</h3>

							<span class="uiListItemContent">
								<cfoutput>#givenname# #sn# (#DateFormat(postcreated, "dd-mm-yyyy")#&nbsp;#TimeFormat(postcreated, "HH:mm")#)</cfoutput>
							</span>
							<span class="uiListItemIcon uiListItemRight">zobacz</span>
						</a>
				</li>
			</cfloop>
		</ul>

		<div class="uiFooter">
			<a
				href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Posts",action="add")#</cfoutput>', 'user_profile_cfdiv');"
				class=""
				title="Dodaj nową aktualność">

				<span>Dodaj nową aktualność</span>
			</a>
		</div>
	</div>
</div>

<div class="footerArea">

</div>