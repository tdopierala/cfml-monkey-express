<cfoutput>
<div id="userTabsDiv" class="tabsHeader">

	<div class="scroll_back">
		<span class="">&nbsp;</span>
	</div>

	<div class="tabs_wrapper">
		<ul>
			<li>
				<a
							href="javascript:ColdFusion.navigate('#URLFor(controller="Users",action="getUserActiveWorkflow",key=session.user.id)#', 'user_profile_cfdiv');"
					class="docs"
					title="Moje aktywne dokumenty">
						<span>Aktywne dokumenty</span>
				</a>
			</li>
			<li>
				<a
							href="javascript:ColdFusion.navigate('#URLFor(controller="Users",action="getUserWorkflow",key=session.user.id)#', 'user_profile_cfdiv');"
					class="folder"
					title="Wszystkie dokumenty">
						<span>Wszystkie dokumenty</span>
				</a>

			</li>
			<!---<li>
				#linkTo(
					text="<span>Komunikaty</span>",
					controller="Messages",
					action="index",
					key=session.userid,
					class="message",
					title="Komunikaty")#
			</li>
			<li class="">
				#linkTo(
					text="<span>Projekty</span>",
					controller="Projects",
					action="index",
					class="projects",
					title="Projekty")#
			</li>--->
			<li class="fr">
				#linkTo(
					text="<span>Raporty faktur</span>",
					controller="InvoiceReports",
					action="index",
					class="ajaxlink statistics",
					title="Raporty faktur")#
			</li>
		</ul>
	</div>

	<div class="scroll_next">
		<span class="">&nbsp;</span>
	</div>

</div>
</cfoutput>