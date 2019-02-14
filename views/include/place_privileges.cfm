<cfset myPrivilege = {
		placestepprivileges = cacheGet( "PLACEPRIVILEGES[#session.user.id#][placestepprivileges]" ),
		placeformprivileges = cacheGet( "PLACEPRIVILEGES[#session.user.id#][placeformprivileges]" ),
		placecollectionprivileges = cacheGet( "PLACEPRIVILEGES[#session.user.id#][placecollectionprivileges]" ),
		placephototypeprivileges = cacheGet( "PLACEPRIVILEGES[#session.user.id#][placephototypeprivileges]" ),
		placefiletypeprivileges = cacheGet( "PLACEPRIVILEGES[#session.user.id#][placefiletypeprivileges]" ),
		placereportprivileges = cacheGet( "PLACEPRIVILEGES[#session.user.id#][placereportprivileges]" )
	} />