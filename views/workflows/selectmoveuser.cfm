<cfoutput>
	<div class="wrapper">

		<h3>Użytkownik do którego zostanie przekazany dokument</h3>

		<div class="wrapper">

			<cfoutput>#includePartial(partial="/workflows/subnav")#</cfoutput>

		</div>

		<div class="wrapper">

			#startFormTag(action="actionSelectMoveUser",id="selectMoveUserForm")#
			#hiddenFieldTag(
				class="workflowid",
				name="workflow[workflowid]",
				value="#workflowstep.workflowid#")#
			#hiddenFieldTag(
				class="workflowid",
				name="workflow[workflowstepid]",
				value="#workflowstep.id#")#
			#hiddenFieldTag(
				class="workflowtoken",
				name="workflow[workflowtoken]",
				value="#workflowstep.token#")#

				<ol>
					<li>
						#textAreaTag(
							name="workflow[workflowsteptransfernote]",
							class="textareaBig",
							label="Twoje uwagi dla następnego użytkonika",
							labelPlacement="before")#
					</li>
					<li>
						#textFieldTag(
							name="document[searchuser]",
							class="searchusers inputSmall",
							label="Przekaż do",
							labelPlacement="before")#

						<select name="workflow[workflowstepuserid]" id="workflowstepuserid">
						</select>
					</li>
					<li>
						#submitTag(value="Wyślij",class="button redButton fltr selectNextUser ajaxmodalloader")#
					</li>
				</ol>

			#endFormTag()#

		</div>

	</div>
</cfoutput>

<script type="text/javascript">
$(function() {
	/*
	 * Wyszukiwanie użytkowników do których ma zostać przekazany dokument.
	 * Użytkownicy pobierani są Ajaxowo.
	 */
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

    /*
     * Zabezpieczenie przed wysłaniem formularza bez wybrania osoby, do której ma iść dokument.
     */
    $('.selectNextUser').live('click', function(e) {
    	if (!$('#workflowstepuserid option:selected').length) {
    		e.preventDefault();

    		var errorMessage = "<span class=\"validationerror\">Musisz wybrać użytkownika, do którego zostanie przekazany dokument.</span>";
    		$('#flashMessages').hide();

			$('#workflowstepuserid').parent().append(errorMessage);
    	}
    });
});
</script>