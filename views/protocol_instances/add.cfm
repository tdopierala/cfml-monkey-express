<cfoutput>
	
	<div class="wrapper">
		
		<h3>Nowy protokół</h3>
		
		<div class="wrapper">
			
			<div class="protocol_types">
			<ul>
				<cfloop query="mytypes">
					<li>
						#linkTo(
							text=imageTag("protocol.png") & "<span>#typename#</span>",
							controller="Protocol_instances",
							class="protocol_type",
							action="newProtocol",
							key=typeid)#
					</li>
				</cfloop>
			</ul>
			</div>
			
		</div>
		
	</div>
	
</cfoutput>