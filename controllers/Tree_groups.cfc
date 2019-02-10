<cfscript>

	component
		extends="Controller"
		output="false" {

		function init() {

			super.init();

		}

		function index() {

			my_tree = model("tree_group").getTree();

		}

		function newGroup() { }

		function move() {

			move_node = model("tree_group").move(
				my_root = params.my_root,
				new_parent = params.new_parent);

			my_tree = model("tree_group").getTree();
			renderWith(data="my_tree",layout=false,template="tree");

		}

		function actionNewGroup() {

			new_group = model("tree_group").insert(
				groupname = params.groupname,
				groupdescription = params.groupdescription);

			redirectTo(back=true);

		}

		function delete() {

			delete_node = model("tree_group").delete(
				my_node = params.key);

			redirectTo(back=true);

		}

		function grant() {

			my_grant = model("tree_groupuser").grant(
				userid = params.userid,
				lft = params.lft,
				rgt = params.rgt);



			my_privileges = model("tree_groupuser").getUserGroups(
				userid = params.userid
			);

			renderWith(data="my_privileges",layout=false);

		}

		function revoke() {

			my_revoke = model("tree_groupuser").revoke(
				userid = params.userid,
				lft = params.lft,
				rgt = params.rgt);

			my_privileges = model("tree_groupuser").getUserGroups(
				userid = params.userid);

			renderWith(data="my_privileges",layout=false,template="grant");

		}

	}

</cfscript>