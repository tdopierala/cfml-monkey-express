<!---
 <cfoutput>
<div id="userTabsDiv" class="tabsHeader tabs_wrapper">
	<ul>
		<li class="fl">
			#linkTo(
				text="<span>Mój profil</span>",
				controller="Users",
				action="view",
				key=session.userid,
				params="cfdebug",
				class="home",
				title="Mój profil")#
		</li>
		<li>
			#linkTo(
				text="<span>Aktywne dokumenty</span>",
				controller="Users",
				action="getUserActiveWorkflow",
				key=session.userid,
				params='cfdebug',
				class="docs",
				title="Moje aktywne dokumenty")#
		</li>
		<li>
			#linkTo(
				text="<span>Mój etap</span>",
				controller="Workflows",
				action="userStep",
				key=params.key,
				class="step",
				title="Mój etap obiegu dokumentów")#
		</li>
		<li>
			#linkTo(
				text="<span>Historia dokumentu</span>",
				controller="Workflows",
				action="workflowHistory",
				key=params.key,
				class="info",
				title="Historia dokumentu")#
		</li>
		<li>
			#linkTo(
				text="<span>Podgląd dokumentu</span>",
				controller="Workflows",
				action="preview",
				key=params.key,
				class="preview",
				title="Podgląd dokumentu")#
		</li>
		<li class="fr deleteWorkflow">
			#linkTo(
				text="<span>Usuń dokument</span>",
				controller="Workflows",
				action="delete",
				key=params.key,
				class="delete_workflow",
				title="Usuń dokument z obiegu")#
		</li>
	</ul>
</div>
</cfoutput>
--->