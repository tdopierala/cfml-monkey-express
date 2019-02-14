<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	
		<cfset belongsTo(name="user",modelName="user",foreignKey="userid") />
		<cfset setPrimaryKey("proposalid") />
<!--- 		<cfset hasOne(name="triggerHolidayProposal",foreignKey="proposalid") /> --->
<!--- 		<cfset belongsTo(name="triggerHolidayProposal",foreignKey="proposalid") /> --->
	
	</cffunction>

</cfcomponent>