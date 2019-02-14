<cfoutput>
<ul class="tree_group_structure">
	<cfloop query="questions">
		<li class="level-#level# {id:#id#, lft:#lft#, rgt:#rgt#, parentid:#parentid#}">
			<input
				type="checkbox"
				value="1"
				name="questionid#id#"
				class="group_access {id:#id#, lft:#lft#, rgt:#rgt#, parentid:#parentid#}" />

			<label for="groupid#id#">#question#</label>
			
			#linkTo(
				text="<span>x</span>",
				controller="Insurance_questions",
				action="delete",
				key=id,
				params="categoryid=#categoryid#",
				class="delete_tree_group_node {id:#id#}")#

		</li>
	</cfloop>
</ul>
</cfoutput>

<script type="text/javascript">
$(function() {
	var len = $('script').filter(function () {
		return /^.*intranet\/javascripts\/ajaximport\/insurance\.admin\.structure.*/.test( $(this).attr('src') );
	}).length;
	
	if (len === 0) {
		$.getScript("javascripts/ajaximport/insurance.admin.structure.js");
	}
});
</script>