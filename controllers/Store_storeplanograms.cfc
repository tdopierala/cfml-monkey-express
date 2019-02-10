<cfcomponent displayname="Store_storeplanograms" output="false" extends="Controller">

	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
	</cffunction>
	
	<cffunction name="index" output="false" access="public" hint="">
		<!--- Pobieram id sklepu, z którego się loguję --->
		<cfset myStore = model("store_store").getUserStore(session.user.id) />
		<!---<cfdump var="#myStore#" />
		<cfabort />--->
		<cfset myShelfs = model("store_store").getStoreShelfs(storeid = myStore.id) />
	</cffunction>
	
	<cffunction name="getFloorPlan" output="false" access="public" hint="Pobranie aktualnego planogramu przypisanego do sklepu">
		<cfset myFloorPlan = model("store_floorplan").getStoreFloorPlan(url.key) />
		<cflocation url="files/floorplans/#myFloorPlan.filesrc#" />
		
	</cffunction>

</cfcomponent>