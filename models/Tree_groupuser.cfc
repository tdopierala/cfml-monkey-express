<cfscript>

/*
 * Komponent obsługujący uprawnienia użytkownika w strukturze drzewiastej.
 */

	component
		extends="Model"
		output="false" {

		function init() {
			table("tree_groupusers");
		}

		function grant(
			required numeric userid,
			required numeric lft,
			required numeric rgt) {

			transaction {

				try {

					var queryService = new query();
					queryService.setDatasource(get('loc').datasource.intranet);
					queryService.addParam(name="lft",value=arguments.lft,cfsqltype="cf_sql_integer");
					queryService.addParam(name="rgt",value=arguments.rgt,cfsqltype="cf_sql_integer");

					/* wersja z tabelą tymczasową */
					/*
					queryResult = queryServie.execute(sql="
						create temporary table tmp_tree_groups engine=memory as
						(select
							id
						from tree_groups
						where lft >= :lft and rgt <= :rgt)").getResult();
					*/

					var queryResult = queryService.execute(sql="
						select
							id
						from tree_groups
						where lft >= :lft and rgt <= :rgt").getResult();

					// Przechodzę przez wszystkie grupy
					// Sprawdzam, czy użytkownik jest do niej przypisany.
					for(
						intRow = 1;
						intRow LTE queryResult.RecordCount;
						intRow = (introw + 1)
						) {

						queryService.clearParams();
						queryService.addParam(name="id",value=queryResult["id"][intRow],cfsqltype="cf_sql_integer");
						queryService.addParam(name="userid",value=arguments.userid,cfsqltype="cf_sql_integer");
						var queryUserGroup = queryService.execute(sql="
							select
								id
							from tree_groupusers
							where groupid = :id and userid = :userid").getResult();


						// Jeżeli użytkownik nie jest przypisany do grupy to przypisuje go
						if (queryUserGroup.RecordCount == 0) {
							queryService.addParam(name="userid",value=arguments.userid,cfsqltype="cf_sql_integer");
							queryService.addParam(name="groupid",value=queryResult["id"][intRow],cfsqltype="cf_sql_integer");

							queryService.execute(sql="insert into tree_groupusers (userid, groupid) values (:userid, :groupid)");
						}

					} // end for

				} // end try
				catch (Exception e) {
					transactionRollback();
					writeDump(e);
				}


			} // end transaction

		} // end function grant

		function revoke(
			required numeric userid,
			required numeric lft,
			required numeric rgt) {

			transaction {

				queryService = new query();
				queryService.setDatasource(get('loc').datasource.intranet);
					queryService.addParam(name="lft",value=arguments.lft,cfsqltype="cf_sql_integer");
					queryService.addParam(name="rgt",value=arguments.rgt,cfsqltype="cf_sql_integer");

				queryResult = queryService.execute(sql="
					select
						id
					from tree_groups
					where lft >= :lft and rgt <= :rgt").getResult();

				for (
					intRow = 1;
					intRow LTE queryResult.RecordCount;
					intRow = (intRow + 1)
					) {

					queryService.clearParams();
					queryService.addParam(name="userid",value=arguments.userid,cfsqltype="cf_sql_integer");
					queryService.addParam(name="groupid",value=queryResult["id"][intRow],cfsqltype="cf_sql_integer");
					queryService.execute(sql="delete from tree_groupusers where userid = :userid and groupid = :groupid");

				} // end for

			} // end transaction

		}
		
		function getUsers (
			required string text) {
			
			var queryService = new query();
			queryService.setDatasource(get("loc").datasource.intranet);
			queryService.addParam(name="search",value="%#arguments.text#%",cfsqltype="cf_sql_varchar");
			
			var queryResult = queryService.execute(sql="select id, mail, login, givenname, sn from users where active = 1 and (login like (:search) or givenname like (:search) or sn like (:search))").getResult();
			return super.queryToStruct(Query=queryResult);
		}

		function getUserGroups(
			required numeric userid) {

			queryService = new query();
			queryService.setDatasource(get('loc').datasource.intranet);
			queryService.addParam(name="userid",value=arguments.userid,cfsqltype="cf_sql_integer");

			queryResult = queryService.execute(sql="
				select groupid from tree_groupusers where userid = :userid").getResult();

			return super.queryToStruct(Query=queryResult);

		}
		
		function getGroupIdByName(
			required string groupname) {

			queryService = new query();
			queryService.setDatasource(get('loc').datasource.intranet);
			queryService.addParam(name="grname",value=arguments.groupname,cfsqltype="cf_sql_varchar");
			
			queryResult = queryService.execute(sql="select id from tree_groups where groupname = :grname").getResult();
			return super.queryToStruct(Query=queryResult);
				
		}
		
		query function getGroupUsers(
			required numeric groupid) {
		
			var queryService = new query(
				datasource=get('loc').datasource.intranet
			);
			queryService.addParam(name="groupid",value=arguments.groupid,cfsqltype="cf_sql_integer");
			
			var queryResult = queryService.execute(sql="
				select distinct userid from tree_groupusers where groupid = :groupid").getResult();
			
			return queryResult;
				
		}
		
		query function getGroupUsersFull(
			required numeric groupid,
					 search string) {
		
			var queryService = new query(
				datasource=get('loc').datasource.intranet
			);
			queryService.addParam(name="groupid",value=arguments.groupid,cfsqltype="cf_sql_integer");
			
			if (isDefined("arguments.search")) {
				
				arguments.search = "%" & arguments.search & "%";
				
				queryService.addParam(name="search",value=arguments.search,cfsqltype="cf_sql_varchar");
				var queryResult = queryService.execute(sql="
					select distinct tg.userid, u.mail, u.givenname, u.sn 
					from tree_groupusers tg
					inner join users u on u.id = tg.userid 
					where groupid = (:groupid)
					and (
						givenname like (:search) or
						sn like (:search)
					)
					and (active = 1)").getResult();
				
			} else {
				
				var queryResult = queryService.execute(sql="
					select distinct tg.userid, u.mail, u.givenname, u.sn 
					from tree_groupusers tg
					inner join users u on u.id = tg.userid 
					where groupid = (:groupid)
					and (active = 1)").getResult();
				
			}
			
			return queryResult;
				
		}
		
		query function getGroupByNameUsers(
			required string groupName) {
			
			var queryService = new query(
				datasource=get('loc').datasource.intranet
			);
			queryService.addParam(name="groupName",value="#arguments.groupName#",cfsqltype="cf_sql_varchar");
			
			var groupIdResult = queryService.execute(sql="
				select id from tree_groups where groupname = :groupName").getResult();
			
			var queryServiceUSers = new query(
				datasource=get('loc').datasource.intranet
			);
			queryServiceUSers.addParam(name="groupid",value=groupIdResult.id,cfsqltype="cf_sql_integer");
			
			var queryResult = queryServiceUSers.execute(sql="
				select distinct userid from tree_groupusers where groupid = :groupid").getResult();
			
			return queryResult;
			
		}

		query function getUserTreePrivileges(
			required numeric userid) {

			var queryService = new query();
			queryService.setDatasource(get('loc').datasource.intranet);
			queryService.addParam(name="userid",value=arguments.userid,cfsqltype="cf_sql_integer");

			var queryResult = queryService.execute(sql="
				select
					gu.groupid as groupid
					,gu.userid as userid
					,g.groupname
				from tree_groupusers gu
				inner join tree_groups g on gu.groupid = g.id
				where gu.userid = :userid").getResult();

			return queryResult;

		}

		query function getUserTreeMenu(
			required numeric userid) {

			var queryService = new query();
			queryService.setDatasource(get('loc').datasource.intranet);
			queryService.addParam(name="userid",value=arguments.userid,cfsqltype="cf_sql_integer");

			var queryResult = queryService.execute(sql="
				select
					g2.id as groupid
					,g2.groupname
					,count(distinct gm.id) as c
					,count(distinct g1.id) as level
				from (tree_groups g1, tree_groups g2)
				inner join tree_groupusers gu on g1.id = gu.groupid
				inner join tree_groupmenus gm on g1.id = gm.groupid
				where gu.userid = :userid and g2.lft between g1.lft and g1.rgt and gm.groupid = g2.id
				group by g2.id
				order by g1.lft asc").getResult();

			return queryResult;

		}
		
		query function getUsersByGroupName(
			required string groupName) {
				
			// writeDump(arguments.groupName);
			// abort;
		
			var queryService = new query();
			queryService.setDatasource(get('loc').datasource.intranet);
			queryService.addParam(name="gn",value="#arguments.groupName#",cfsqltype="cf_sql_varchar");
			
			var queryResult = queryService.execute(sql="
				select
					u.id as id
					,u.givenname as givenname
					,u.sn as sn
					,gu.userid as userid
					,gu.groupid as groupid
					,CONCAT(IFNULL(u.givenname,''), ' ', IFNULL(u.sn, '')) as usr
					,u.mail as mail
					,u.companyemail as companyemail
				from tree_groupusers gu
				inner join users u on gu.userid = u.id
				inner join tree_groups g on gu.groupid = g.id
				where g.groupname = '#arguments.groupName#'
				order by u.givenname ASC").getResult();
				
			return queryResult;		
		}

	}
</cfscript>