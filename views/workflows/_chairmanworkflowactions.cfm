<cfoutput>
	<div class="workflowActions">
		<ul>
			<li class="closeWorkflowElements">
				#linkTo(
					text="<span>Zamknij zaznaczone</span>",
					controller="Workflows",
					action="closeInvoiceRow",
					class="closeInvoiceRows",
					title="Zamknij zaznaczone")#
			</li>
		</ul>
	</div>
</cfoutput>