<cfoutput>
	
	<ul>
		<cfloop query="my_templates">
			
			<li>
				#linkTo(
					text=invoicetemplatename,
					controller="Documents",
					action="getTemplate",
					key=id,
					class="user_template")#
				
				<span class="delete_invoice_template" id="#id#">x</span>
			</li>
			
		</cfloop>
	</ul>
	
</cfoutput>