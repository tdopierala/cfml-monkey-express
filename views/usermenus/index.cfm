<cfoutput>

	<div class="wrapper">
	
		<h3>Menu użytkownika</h3>
		
		<div class="wrapper">
		
			<table class="newtables">
			
				<thead>
					<tr class="top" colspan="6">#username.givenname# #username.sn#</tr>
				</thead>
				
				<tbody>
					<cfloop query="usermenu">
					
						<cfif menuelementtype eq 'top'>
						
							<tr>
								<td class="bottomBorder">
									
									#checkBoxTag(
										name="usermenu",
										value=1,
										class="userMenuAccess {userid:#userid#,menuid:#menuid#}",
										checked=YesNoFormat(usermenuaccess))#
								
								</td>
								<td class="bottomBorder">#menuid#</td>
								<td class="bottomBorder">#menuname#</td>
								<td class="bottomBorder">#menucontroller#</td>
								<td class="bottomBorder">#menuaction#</td>
								<td class="bottomBorder">#menuelementtype#</td>
								<td class="bottomBorder">#parentid#</td>
							</tr>
							
							<cfset loc.tmpid = menuid />
							
							<cfloop query="usermenu">
								
								<cfif (menuelementtype eq 'el') AND (parentid eq loc.tmpid)>
								
									<tr>
										<td class="bottomBorder">
											
											#checkBoxTag(
												name="usermenu",
												value=1,
												class="userMenuAccess {userid:#userid#,menuid:#menuid#}",
												checked=YesNoFormat(usermenuaccess))#
										
										</td>
										<td class="bottomBorder">#menuid#</td>
										<td class="bottomBorder el">#menuname#</td>
										<td class="bottomBorder">#menucontroller#</td>
										<td class="bottomBorder">#menuaction#</td>
										<td class="bottomBorder">#menuelementtype#</td>
										<td class="bottomBorder">#parentid#</td>
									</tr>
								
								</cfif>
								
							</cfloop>
						
						</cfif>
					</cfloop>
				</tbody>
			
			</table>
		
		</div>
	
	</div>

</cfoutput>

<script type="text/javascript">

$(function() {
	$('.userMenuAccess').live('click', function() {
	
		var j_menuid = $(this).metadata().menuid;
		var j_userid = $(this).metadata().userid;
		
		$.ajax({
			type: 'get',
			dataType: 'html',
			data: {menuid:j_menuid,userid:j_userid},
			url: "<cfoutput>#URLFor(controller='UserMenus',action='grantRevokeMenu',params='cfdebug')#</cfoutput>",
			success: function(data) { 
				
			}
		});
	
	});
});

</script>