<cfcomponent extends="Model">
	
	<cffunction name="init" >
		
		<cfset table("proposal_businesstrip") />
		<cfset hasOne(name="triggerHolidayProposal", foreignKey="statusid") />
		
	</cffunction>
</cfcomponent>