<cfoutput>
<div id="userTabsDiv" class="tabsHeader tabs_wrapper">
	<ul>
		<li>
			#linkTo(
				text="<span>Mój profil</span>",
				controller="Users",
				action="view",
				key=session.userid,
				class="home",
				title="Mój profil")#
		</li>
		<li>
			#linkTo(
				text="<span>Podgląd dokumentu</span>",
				controller="Workflows",
				action="descriptionPreview",
				key=params.key,
				class="preview",
				title="Podgląd dokumentu")#
		</li>
		<li>
			#linkTo(
				text="<span>Historia dokumentu</span>",
				controller="Workflows",
				action="workflowPreviewHistory",
				key=params.key,
				class=" info",
				title="Historia dokumentu")#
		</li>
	</ul>
</div>
</cfoutput>