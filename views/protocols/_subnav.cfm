<cfoutput>

	<div id="protocolsTabsDiv" class="tabsHeader">
	
		<ul>
			<li>
				#linkTo(
					text="<span>Moje protokoły</span>",
					controller="Protocols",
					action="getProtocolsList",
					key=session.userid,
					class="ajaxlink protocolslist",
					title="Moje protokoły")#
			</li>
			<li>
				#linkTo(
					text="<span>Dodaj protokół</span>",
					controller="Protocols",
					action="addProtocol",
					key=session.userid,
					class="ajaxlink protocolsadd",
					title="Dodaj protokół")#
			</li>
		</ul>
	
	</div>

</cfoutput>