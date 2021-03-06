<cfscript>

	component
		extends="no_login_check"
		output="false" {

		function init() {

			super.init();

		}

		function index() {

			my_menus = model("tree_groupmenu").getGroupMenu(
				groupid = params.key);

			my_group = model("tree_group").findByKey(params.key);

		} // end index

		function actionNewMenu() {

			new_menu = model("tree_groupmenu").new();
			new_menu.groupid = params.groupid;
			new_menu.displayname = params.displayname;
			new_menu.controller = params.menu_controller;
			new_menu.action = params.menu_action;
			new_menu.save(callbacks=false);

			my_menus = model("tree_groupmenu").getGroupMenu(
				groupid = params.groupid);

			renderWith(data="my_menus",layout=false,template="tree");

		} // end actionNewMenu

		function delete() {

			delete_menu = model("tree_groupmenu").findByKey(params.key);
			delete_menu.delete();

		} // end delete

		function getGroupMenu() {

			json = model("tree_groupmenu").getGroupMenu(
				groupid = params.groupid,
				struct = true);

			renderWith(data="json",layout=false,template="json");

		}

	}

</cfscript>