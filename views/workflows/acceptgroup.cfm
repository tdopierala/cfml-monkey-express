<cfoutput>
	
	<div class="wrapper">
		
		<h3>Zaakceptuj dokumenty</h3>
		
		<div class="wrapper">
	
		<cfoutput>#includePartial(partial="/workflows/workflowmovesubnav")#</cfoutput>
	
		</div>
		
		<div class="wrapper">
			
			<cfform
				action="#URLFor(controller='Workflows',action='actionAcceptGroup')#">
				
				<table class="tables" id="moveWorkflowStepTable">
					<thead>
						<tr>
							<th>NR. FAKTURY</th>
							<th>KONTRAHENT</th>
							<th>DATA WPŁYWU</th>
							<th>NETTO</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="my_workflows">
							<tr>
								<td class="leftBorder bottomBorder">
									#numer_faktury#
									
									#hiddenFieldTag(
										name="workflowids[#workflowid#]",
										value=workflowid)#
								</td>
								<td class="leftBorder bottomBorder">#nazwa1#</td>
								<td class="leftBorder bottomBorder">#data_wplywu#</td>
								<td class="leftBorder bottomBorder rightBorder">#netto#</td>
							</tr>
						</cfloop>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="4" style="text-align: right; padding-top: 20px;">
								#textFieldTag(
									name="document[searchuser]",
									class="searchusers inputSmall",
									label="Przekaż do  ",
									labelPlacement="around")#
							
								<select name="workflow[workflowstepuserid]" id="workflowstepuserid" class=""></select>

								#submitTag(value="Akceptuje",class="smallButton redSmallButton fltr submit_accept_workflow")#
							</td>
						</tr>
					</tfoot>
				</table>
				
			</cfform>
			
		</div>
		
	</div>
	
</cfoutput>

<script type="text/javascript">
$(function() {
	
	$('.submit_accept_workflow').live('click', function (e) {
		$('#flashMessages').show();
	});
	
	var timeout = null;
	
	$('.searchusers').live('keypress', function () {
		
		if (timeout) {
	        clearTimeout(timeout);
	        timeout = null;
		}
	
		timeout = setTimeout(getUserToWorkflowStep, 500)
		
	});
	
	function getUserToWorkflowStep() {
		
	    var searchValue = $('.searchusers').attr('value');
		
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		{searchvalue:searchValue},
			url			:		<cfoutput>"#URLFor(controller='Users',action='getUserToWorkflowStep',params='cfdebug')#"</cfoutput>,
			success		:		function(data) {
				$('#workflowstepuserid').html(data);
			}
		});
	
	}
});
</script>