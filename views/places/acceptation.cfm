<cfoutput>

	<div class="wrapper">

		<h4>Weryfikacja</h4>
		
		<ul class="placenav">
			<li>
				#linkTo(
					text="<span>Wygeneruj etap weryfikacji</span>",
					controller="Places",
					action="agreementReport",
					key=place.id,
					params="format=pdf",
					target="_blank",
					class="report",
					title="Wygeneruj raport nieruchomości")#
			</li>
		</ul>
		
		<div class="clear"></div>
		
		#includePartial(partial="changestatus")#
		
	</div>

</cfoutput>