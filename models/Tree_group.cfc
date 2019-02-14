<cfscript>

/*
create view view_tree_groups (id, groupname, groupdescription, lvl, lft, rgt) as
	select
		g1.id
		,g1.groupname
		,g1.groupdescription
		,count(g2.lft)
		,g1.lft
		,g1.rgt
	from tree_groups as g1, tree_groups as g2
	where g1.lft between g2.lft and g2.rgt
	group by g1.id, g1.lft, g1.rgt;

drop view view_tree_group_subtrees;
create view view_tree_group_subtrees (parentid, childid, parentgroupname, childgroupname) as
	select
		g1.id
		,g2.id
		,g1.groupname
		,g2.groupname
	from
		tree_groups as g1, tree_groups as g2
	where
		g2.lft > g1.lft and g2.lft < g1.rgt;
*/

	component
		extends="Model"
		output="false" {

		function init() {
			table("tree_groups");
		}

		function insert(
			required String groupname,
			required String groupdescription,
			String controller = "",
			String action = "") {

			param name="maxRgt" default="1";

			transaction {

				try {

					queryService = new query();
					queryService.setDatasource(get('loc').datasource.intranet);
					queryService = queryService.execute(sql="SELECT max(rgt) as c from tree_groups");

					if (Len(queryService.getResult().c)) {
						maxRgt = queryService.getResult().c;
					}

					queryService = new query();
					queryService.setDatasource(get('loc').datasource.intranet);
					queryService.addParam(name="max_rgt",value=maxRgt);
					queryService.execute(sql="update tree_groups set rgt = rgt + 2 where rgt >= :max_rgt");

					queryService = new query();
					queryService.setDatasource(get('loc').datasource.intranet);

					queryService.addParam(name="groupname",value=arguments.groupname);
					queryService.addParam(name="groupdescription",value=arguments.groupdescription);
					queryService.addParam(name="controller",value=arguments.controller);
					queryService.addParam(name="action",value=arguments.action);
					queryService.addParam(name="max_rgt",value=maxRgt);
					queryService.addParam(name="max_rgt_plus",value=maxRgt+1);

					queryService.execute(sql="insert into tree_groups
						(groupname, groupdescription, controller, action, lft, rgt) values
						((:groupname), (:groupdescription), (:controller), (:action), (:max_rgt), (:max_rgt_plus) )");

				}
				catch (Expression e) {

					transactionRollback();
					WriteOutput(e);
					abort;

				}

			}

		} // End insert

		function move(
			required numeric my_root,
			required numeric new_parent) {

			transaction {
				try {

					queryService = new query();
					queryService.setDatasource(get('loc').datasource.intranet);

					queryService.addParam(name="my_root",value=arguments.my_root);
					queryService.addParam(name="new_parent",value=arguments.new_parent);
					queryService.execute(sql="SET @origin_lft = 0, @origin_rgt = 0, @new_parent_rgt = 0");

					queryService.execute(sql="select lft, rgt into @origin_lft, @origin_rgt from tree_groups where id = :my_root");

					queryResult = queryService.execute(sql="select rgt from tree_groups where id = :new_parent").getResult();

					queryService.addParam(name="new_parent_rgt",value=queryResult.RGT,cfsqltype="cf_sql_integer");
					queryService.execute(sql="set @new_parent_rgt = :new_parent_rgt");
					queryService.execute(sql="
			UPDATE tree_groups SET lft = lft +
			CASE
				WHEN @new_parent_rgt < @origin_lft
				THEN CASE
					WHEN lft BETWEEN @origin_lft AND @origin_rgt
					THEN @new_parent_rgt - @origin_lft
					WHEN lft BETWEEN @new_parent_rgt AND @origin_lft - 1
					THEN @origin_rgt - @origin_lft + 1
    				ELSE 0 END

    			WHEN @new_parent_rgt > @origin_rgt
    			THEN CASE
    				WHEN lft BETWEEN @origin_lft AND @origin_rgt
    				THEN @new_parent_rgt - @origin_rgt - 1
    				WHEN lft BETWEEN @origin_rgt + 1 AND @new_parent_rgt - 1
    				THEN @origin_lft - @origin_rgt - 1
    				ELSE 0 END
    			ELSE 0 END,
    		rgt = rgt +
    		CASE
    			WHEN @new_parent_rgt < @origin_lft
    			THEN CASE
    				WHEN rgt BETWEEN @origin_lft AND @origin_rgt
    				THEN @new_parent_rgt - @origin_lft
    				WHEN rgt BETWEEN @new_parent_rgt AND @origin_lft - 1
	    			THEN @origin_rgt - @origin_lft + 1
    				ELSE 0 END
    			WHEN @new_parent_rgt > @origin_rgt
    			THEN CASE
					WHEN rgt BETWEEN @origin_lft AND @origin_rgt
					THEN @new_parent_rgt - @origin_rgt - 1
					WHEN rgt BETWEEN @origin_rgt + 1 AND @new_parent_rgt - 1
					THEN @origin_lft - @origin_rgt - 1
					ELSE 0 END
				ELSE 0 END");

				}
				catch (Exception e) {

					transactionRollback();
					WriteOutput(e);
					abort;

				} // end try-catch

			} // end transaction

		} // end move

		/*
		 * Metoda usuwająca grupę ze struktury.
		 * Po usunięciu grupy muszę usunąć wszystkie powiązane z nią elementy.
		 * Powiązanymi elementami są menu oraz widgety.
		 */
		function delete(
			required numeric my_node) {

			transaction {

				try {

					queryService = new query();
					queryService.setDatasource(get('loc').datasource.intranet);
			queryService.addParam(name="my_node",value=arguments.my_node,cfsqltype="cf_sql_integer");
					queryService.execute(sql="SET @drop_id = 0, @drop_lft = 0, @drop_rgt = 0");
					queryService.execute(sql="SELECT id, lft, rgt INTO @drop_id, @drop_lft, @drop_rgt from tree_groups WHERE id = :my_node");
					queryService.execute(sql="DELETE FROM tree_groups WHERE lft BETWEEN @drop_lft and @drop_rgt");
					queryService.execute(sql="UPDATE tree_groups
						SET lft = CASE
							WHEN lft > @drop_lft
							THEN lft - (@drop_rgt - @drop_lft + 1)
							ELSE lft END,
						rgt = CASE
							WHEN rgt > @drop_lft
							THEN rgt - (@drop_rgt - @drop_lft + 1)
							ELSE rgt END
						WHERE lft > @drop_lft OR rgt > @drop_lft;");

					queryService.execute(sql="delete from tree_groupmenus where groupid = :my_node");
					queryService.execute(sql="delete from widget_tree_groups where groupid = :my_node");

				}
				catch (Exception e) {

					transactionRollback();
					writeDump(e);
					abort;

				} // end try-catch

			} // end transaction


		} // end delete

		function getTree() {

			queryService = new query();
			queryService.setDatasource(get('loc').datasource.intranet);

			queryResult = queryService.execute(sql="
			select
				O2.id as id
				,O2.groupname
				,O2.groupdescription as groupdescription
				,O2.lft
				,O2.rgt
				,COUNT(O1.id) AS level
				,IFNULL((select id
					from tree_groups t2
       				where t2.lft < O2.lft AND t2.rgt > O2.rgt
       				order by t2.rgt-O2.rgt ASC
       				limit 1), 0) as parentid
			from tree_groups as O1, tree_groups as O2
			where O2.lft between O1.lft and O1.rgt group by O2.id order by O2.lft;").getResult();

			return queryResult;

		} // end getTree

		function getRoot() {

			queryService = new query();
			queryService.setDatasource(get('loc').datasource.intranet);
			queryResult = queryService.execute(sql="
				select
					id
					,groupname
					,groupdescription
					,lft
					,rgt
				from tree_groups
				where lft = (rgt - 1)").getResult();

			return queryResult;

		} // end getRoot

		function getNode(
			required numeric lft,
			required numeric rgt) {

			queryService = new query();
			queryService.setDatasource(get('loc').datasource.intranet);
			queryService.addParam(name="lft",value=arguments.lft,cfsqltype="cf_sql_integer");
			queryService.addParam(name="rgt",value=arguments.rgt,cfsqltype="cf_sql_integer");

			queryResult = queryService.execute(sql="
				select
					g1.id as id
					,g1.groupname as groupname
					,g1.groupdescription as groupdescription
					,g1.lft as lft
					,g1.rgt as rgt
				from tree_groups as g1
				where g1.lft > :lft and g1.rgt < :rgt
				order by g1.lft asc").getResult();

			return queryResult;

		} // end getNode
		
		function getLevel(
			required numeric levelFrom,
			required numeric levelTo) {
			
			queryService = new query();
			queryService.setDatasource(get('loc').datasource.intranet);
			queryService.addParam(name="level_from",value="#arguments.levelFrom#",cfsqltype="cf_sql_integer");
			queryService.addParam(name="level_to",value="#arguments.levelTo#",cfsqltype="cf_sql_integer");
	
			queryResult = queryService.execute(sql="
			drop table if exists tmp_tree_group_instructions;
			create temporary table tmp_tree_group_instructions as
			select
				O2.id as id
				,O2.groupname
				,O2.groupdescription as groupdescription
				,O2.lft
				,O2.rgt
				,COUNT(O1.id) AS level
				,IFNULL((select id
					from tree_groups t2
       				where t2.lft < O2.lft AND t2.rgt > O2.rgt
       				order by t2.rgt-O2.rgt ASC
       				limit 1), 0) as parentid
			from tree_groups as O1, tree_groups as O2
			where O2.lft between O1.lft and O1.rgt group by O2.id order by O2.lft;
			
			select * from tmp_tree_group_instructions
			where level between (:level_from) and (:level_to)
			order by lft asc;
			").getResult();

			return queryResult;
			
		} // end getLevel

	}

</cfscript>