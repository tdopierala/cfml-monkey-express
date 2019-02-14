<cfoutput>

	<div class="wrapper">
		
		<div class="admin_wrapper">
			
			<h2 class="admin_changestatus">Zmiana statusu: #myinstance.street# #myinstance.streetnumber#, #myinstance.postalcode# #myinstance.city#</h2>
			
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
				
				<cfform
					action="#URLFor(controller='Place_instances',action="actionRefuseStep")#" 
					name="refuse_place_step">
					
					<cfinput
						type="hidden"
						name="instanceid"
						value="#myworkflow.instanceid#" />
					
					<cfinput
						type="hidden"
						name="stepid"
						value="#myworkflow.stepid#" />
					
					<cfinput
						type="hidden" 
						name="key"
						value="#myworkflow.id#" />
					
					<table class="admin_table">
						<thead>
							<tr>
								<th class="first">&nbsp;</th>
								<th colspan="2">Informacje do etapu</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="first">&nbsp;</td>
								<td>Powód odrzucenia</td>
								<td>
									<cfselect
										name="instancereasonid"
										query="myreasons"
										value="id"
										display="reasonname"
										class="select_box required"
										queryPosition="below" >
									
										<option value="0"></option>
										
									</cfselect>
									
								</td>
							</tr>
							<tr>
								<td class="first">&nbsp;</td>
								<td>Twoja notatka</td>
								<td>
									
									<cftextarea 
										name="workflownote"
										class="textarea ckeditor" />
									
								</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="3" class="r">
									
									<cfinput
										name="refuse_place_step_submit"
										type="submit"
										class="admin_button red_admin_button"
										value="Odrzuć" />
										
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
	$('.required').each(function (index) {
		$(this).parent().append("<span class=\"requiredfield\">*</span>");
	});
	
	var myFORM = $("#refuse_place_step");
	myFORM.submit(
		function(event){

			var errors = false;
			$('.required').removeClass('redborder');
			$('.required').each(function (index) {
    			if( (!$(this).attr('value') != '') ||
					($(this).hasClass("select_box") && $(this).val() == 0) ) {
					errors = true;
    				$(this).addClass('redborder');
    			}
    		});
			
			if (errors) return false;

		});
});
</script>