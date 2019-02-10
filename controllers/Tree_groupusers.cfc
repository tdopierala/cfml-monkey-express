<cfscript>

	component
		extends="Controller"
		output="false"
		displayname="Tree_groupusers"  {
		pageencoding "utf-8";

		function init() {
			super.init();
			filters(through="before",type="before");
		}
		
		function before() {
			usesLayout("/layout");
		}

		function getUserGroups() {
			if (structKeyExists(params, "userid")) {

				my_privileges = model("tree_groupuser").getUserGroups(
					userid = params.userid);

			} else {

				my_privileges = structNew();
				my_privileges.ROWS = structNew();

			}

			renderWith(data="my_privileges",layout=false);
		}

		boolean function checkUserTreeGroup(
			required String groupname) {
				
			// writeDump(arguments.groupname);
			// abort;

			if (not structKeyExists(session, "tree_groups")) {
				return false;
			}
			
			for (
				intRow = 1;
				intRow LTE session.tree_groups.RecordCount;
				intRow = (intRow + 1)
				) {

				if (Compare(LCase(Trim(stripPolishChars(session.tree_groups["groupname"][intRow]))),
							LCase(Trim(stripPolishChars(arguments.groupname)))) EQ 0) {
					return true;
				}

			}
			
			return false;

		}
		
		void function getGroupUsers() {
			var groupid = 0;
			var text = "";
			
			if (isDefined("URL.GROUPID")) {
				groupid = url.groupid;
			}
			
			if (isDefined("FORM.TEXT")) {
				text = FORM.TEXT;
			}
			
			u = model("tree_groupuser").getGroupUsersFull(groupid=groupid,search=text);
			json = QueryToStruct(Query=u);
			
			usesLayout(false);
		}

	}

</cfscript>