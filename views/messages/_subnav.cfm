<cfoutput>
	<div class="tabsHeader">
		<ul>
			<li>
				#linkTo(
					text="<span>Wstecz</span>",
					controller="Users",
					action="view",
					key=session.userid,
					class="prev",
					title="Poprzednia strona")#
			</li>
			<li>
				#linkTo(
					text="<span>Mój profil</span>",
					controller="Users",
					action="view",
					key=session.userid,
					class="home",
					title="Mój profil")#
			</li>
			<!---
			<li>
				#linkTo(
					text="<span>Dalej</span>",
					controller="Messages",
					action="index",
					class="next",
					title="Następna strona")#
			</li>
			--->
		</ul>
	</div>
</cfoutput>