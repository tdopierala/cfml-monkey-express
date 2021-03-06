<cfscript>

	component
		extends="Model"
		output="false" {

		function init() {
			table("tree_groupmenus");
		}

		function getGroupMenu(
			required numeric groupid,
			boolean struct = false) {

			queryService = new query();
			queryService.setDatasource(get('loc').datasource.intranet);
			queryService.addParam(name="groupid",value=arguments.groupid,cfsqltype="cf_sql_integer");
			queryResult = queryService.execute(sql="
				select
					id
					,controller
					,action
					,displayname
				from tree_groupmenus
				where groupid = :groupid").getResult();

			if (arguments.struct is true)
				return super.QueryToStruct(Query=queryResult);

			return queryResult;

		} // end getGroupMenu

	}

</cfscript>