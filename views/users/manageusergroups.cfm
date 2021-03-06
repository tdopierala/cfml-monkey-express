<cfoutput>

	<div class="wrapper">
	
		<h3>Zarządzanie uprawnieniami</h3>
		
		<div class="wrapper">
			
			<table class="tables" id="userGroupsTable">
			
				<thead>
					<tr>
						<th>Lp.</th>
						<th>Nazwa grupy</th>
						<th>Opis grupy</th>
						<th class="c">Dostęp</th>
					</tr>
				</thead>
				
				<tbody>
					<cfset index = 1>
					<cfloop query="user_groups">
						<tr>
							<td>#index#</td>
							<td>#groupname#</td>
							<td>#groupdescription#</td>
							<td class="c">
								#checkBoxTag(
									name="access",
									value=1,
									class="userGroupAccess {groupid:#groupid#,userid:#userid#,id:#id#}",
									checked=YesNoFormat(access))#
							</td>
						</tr>
					<cfset index++>
					</cfloop>
				</tbody>

				<tfoot>
				</tfoot>

			</table>

		</div>
	
	</div>

	<script type="text/javascript">
		$(function() {
		
			$(".userGroupAccess").live('click', function() {
				var id = $(this).metadata().id;
				$.ajax({
					type: 'get',
					dataType: 'html',
					data: {key:id},
					url: "#URLFor(controller='Users',action='updateUserGroup',params='cfdebug')#",
					success: function(data) { 
			
					}
				});
			});	
		
		});
	</script>
</cfoutput>