<cfoutput>
<div class="wrapper">

	<h3>Przekaż dokument/y</h3>

	<div class="wrapper">

		<cfoutput>#includePartial(partial="/workflows/workflowmovesubnav")#</cfoutput>

	</div>

	<div class="wrapper">

		#startFormTag(action="actionMoveWorkflowStep",id="stepForm")#

			<table class="tables" id="moveWorkflowStepTable">
				<thead>
					<tr>
						<th class="c">Nr. Intranetowy faktury</th>
						<th class="c">Data dodania do Intranetu</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="workflowids">
						<tr>
							<td class="c leftBorder bottomBorder">#documentname#</td>
							<td class="c rightBorder leftBorder bottomBorder">
								#DateFormat(workflowcreated, "dd/mm/yyyy")#
								#hiddenFieldTag(
									name="workflowids[#workflowid#]",
									value=workflowid
								)#
							</td>
						</tr>

				</cfloop>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="2" style="text-align: right; padding-top: 20px;">
							#textFieldTag(
								name="document[searchuser]",
								class="searchusers inputSmall",
								label="Przekaż do  ",
								labelPlacement="around")#

							<select name="workflow[workflowstepuserid]" id="workflowstepuserid" class=""></select>

							#submitTag(value="Przekaż",class="smallButton redSmallButton fltr")#
						</td>
					</tr>
				</tfoot>
			</table>

		#endFormTag()#

	</div>

</div>
</cfoutput>

<script type="text/javascript">
$(function() {
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
			dataType	:		'json',
			data		:		{searchvalue:searchValue},
			url			:		<cfoutput>"#URLFor(controller='Users',action='getUserToWorkflowStep',params='cfdebug')#"</cfoutput>,
			success		:		function(data) {
				var myOPTIONS = "";
				$.each(data.ROWS, function(i, item){
					myOPTIONS += "<option value=\""+item.ID+"\">"+item.GIVENNAME+" "+item.SN+"</option>";
				});

				$('#workflowuserid > option').remove();
				$('#workflowuserid').append(myOPTIONS);
			}
		});

	}
});
</script>