<cfoutput>

	<div class="wrapper">
	
		<h3>#workflow.workflowname#</h3>
	
		<div class="wrapper">
			<cfloop query="workflow">
				<div class="sequence">
					<div class="sequenceOrd">#ord#</div>
					<div class="sequenceName">
						<span>#sequencename# (#statusname#)</span><br/>
						#login# (#companyemail#)
					</div>
				</div>
			</cfloop>
		</div>
	</div>

</cfoutput>