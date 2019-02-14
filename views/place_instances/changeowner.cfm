<cfprocessingdirective pageencoding="utf-8" />

<cfoutput>
<div class="wrapper">
	<div class="admin_wrapper">
		<h2 class="admin_changeowner">Zmiana autora nieruchomości</h2>
		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th colspan="2">Dane lokalu</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>&nbsp;</td>
					<td>Ulica</td>
					<td>#myinstance.street#</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Nr domu</td>
					<td>#myinstance.streetnumber#</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Miasto</td>
					<td>#myinstance.city#</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Kod pocztowy</td>
					<td>#myinstance.postalcode#</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Dodane przez</td>
					<td>#myinstance.givenname# #myinstance.sn#<br/><span class="i">#myinstance.position#</span></td>
				</tr>
			</tbody>
		</table>
		
		<div class="admin_submenu_options">
			
			<cfform action="" name="place_change_owner_form" >
					
				<cfinput type="hidden" name="instanceid" value="#myinstance.instanceid#" />
				<cfinput type="hidden" name="key" value="#myinstance.instanceid#" />
					
				<table class="admin_table">
					<thead>
						<tr>
							<th class="first">&nbsp;</th>
							<th>Pole</th>
							<th>Wartość</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>&nbsp;</td>
							<td>Użytkownik</td>
							<td>
								<cfinput name="searchUsers" type="text" class="input" placeholder="Wyszukaj" />
								<select name="userid" class="select_box user_select_box required"></select>
							</td>
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="3" class="r">
									
								<cfinput name="place_change_owner_form" type="submit" class="admin_button green_admin_button" value="Zmień" />
										
							</td>
						</tr>
					</tfoot>
				</table>
				
			</cfform>
			
		</div>
	</div>
</div>
</cfoutput>
<script>
$(function(){
	var timeout = null;
	
	$('#searchUsers').live('keypress', function(e) {
		if (timeout) {
			clearTimeout(timeout);
			timeout = null;
		}
		timeout = setTimeout(getUserToWorkflowStep, 500)
	})
});
function getUserToWorkflowStep(){
	var searchValue = $('#searchUsers').attr('value');
	$.ajax({
		type		:		'post',
		dataType	:		'json',
		data		:		{text:searchValue},
		url			:		'index.cfm?controller=tree_groupusers&action=get-group-users&groupid=10',
		success		:		function(data){
			var myOPTIONS = "";
			$.each(data.ROWS, function(i, item){
				myOPTIONS += "<option value=\""+item.USERID+"\">"+item.GIVENNAME+" "+item.SN+"</option>";
			});
			$('.user_select_box > option').remove();
			$('.user_select_box').append(myOPTIONS);
		}
	});
}
</script>