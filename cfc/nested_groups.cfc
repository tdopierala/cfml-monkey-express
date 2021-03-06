<cfcomponent
	displayname="nestedGroups"
	hint="Komponent realizujący koncepcje hierarchicznego modelu uprawnień"
	output="false"
	extends="dao" >
	
		
	<cfproperty
		name="grouptable"
		type="string"
		default="groups" />
		
	<cfproperty
		name="groupname"
		type="string" />
	
	<cfproperty
		name="groupcreated"
		type="date" />
	
	<cfproperty
		name="groupdescription"
		type="string" />
		
	<cfproperty
		name="lft"
		type="numeric" />
	
	<cfproperty
		name="rgt"
		type="numeric" />  
		
	<cfset variables.instance = {
		group_table			=	'groups',
		groupname			=	'Użytkownik',
		groupcreated		=	Now(),
		groupdescription	=	'root',
		lft					=	1,
		rgt					=	2} />

	<cffunction
		name="init">	
	
		<cfreturn self />
		
	</cffunction>
	
	
	
</cfcomponent>