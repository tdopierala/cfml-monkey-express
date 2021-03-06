<cfoutput>

	<div class="wrapper">
	
		<h3>Reguły dla #group.groupname#</h3>
		
		<div class="wrapper">
			<table class="tables" id="groupRuleTable">
				<thead>
					<tr>
						<th>Lp.</th>
						<th>Nazwa uprawnienia</th>
						<th class="c">Dostęp #checkBoxTag(name="selectAll",class="selectAll",checked=false)#</th>
					</tr>
				</thead>
				
				<tbody>
					<cfset index = 1>
					<cfloop query="group_rules">
						<tr>
							<td>#index++#</td>
							<td>#name# (#controller# | #action#)</td>
							<th class="c">
								#checkBoxTag(
									name="access",
									value=1,
									class="groupRuleAccess {groupid:#groupid#,ruleid:#ruleid#,id:#id#}",
									checked=YesNoFormat(access))#
							</th>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
	</div>

<script type="text/javascript">
$(function (){
	$(".groupRuleAccess").live('click', function() {
		var id = $(this).metadata().id;
		$.ajax({
			type: 'get',
			dataType: 'html',
			data: {key:id},
			url: "#URLFor(controller='Groups',action='updateGroupRule',params='cfdebug')#",
			success: function(data) { 

			}
		});
	});	
	
	$('.selectAll').live('click', function() {
		if ($(this).is(':checked')) {
			$('.groupRuleAccess').each(function () {
				$(this).attr('checked', true);
				
				var id = $(this).metadata().id;
				$.ajax({
					type: 'get',
					dataType: 'html',
					data: {key:id},
					url: "#URLFor(controller='Groups',action='updateGroupRule',params='cfdebug')#",
					success: function(data) { 
		
					}
				});
				
			});
		} else {
			$('.groupRuleAccess').each(function () {
				$(this).attr('checked', false);
				
				var id = $(this).metadata().id;
				$.ajax({
					type: 'get',
					dataType: 'html',
					data: {key:id},
					url: "#URLFor(controller='Groups',action='updateGroupRule',params='cfdebug')#",
					success: function(data) { 
		
					}
				});
		
			});
		}
	});
	
});
</script>
</cfoutput>
