<cfoutput>

	<div class="wrapper">
	
		<h3>Moje kanały RSS</h3>
		
		<table class="tables" id="userFeedTable">
			<thead>
				<tr>
					<th>Nazwa kanału</th>
					<th class="c">Dostęp</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="user_feed">
					<tr>
						<td>#feedname# (#allcount#)</td>
						<td class="c">
							#checkBoxTag(
								name="access",
								value=1,
								class="userFeedAccess {feeddefinitionid:#feeddefinitionid#,userid:#userid#,id:#id#}",
								checked=YesNoFormat(access))#
						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	
	</div>
	<script type="text/javascript">
		$(function() {
		
			$(".userFeedAccess").live('click', function() {
				var id = $(this).metadata().id;
				$.ajax({
					type: 'get',
					dataType: 'html',
					data: {key:id},
					url: "#URLFor(controller='Users',action='actionAddFeed',params='cfdebug')#",
					success: function(data) { 
			
					}
				});
			});	
		
		});
	</script>
</cfoutput>