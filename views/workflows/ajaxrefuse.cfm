<cfoutput>
<div class="" style="">
	<h3>Odrzuć dokument</h3>

	<div class="wrapper">

		#startFormTag(action="actionRefuse")#
		#hiddenFieldTag(name="workflow[workflowstepid]",value=workflowstep.id)#
		#hiddenFieldTag(name="workflow[workflowtoken]",value=workflowstep.token)#
			<ol class="floatedForm">
				<li>
					#textAreaTag(
						name="workflow[workflowtransfernote]",
						class="textarea",
						label="Twój komentarz",
						labelPlacement="before")#
				</li>
				<li>
					<div class="styledSelect">
						#textFieldTag(
							name="document[searchuser]",
							class="modalsearchusers inputSmall",
							label="Do użytkownika",
							labelPlacement="before")#
						<select name="workflow[workflowstepuser]" id="workflow[workflowstepuser]" class="workflowstepuserlist select">							</select>
					</div>
				</li>
				<li>#submitTag(value="OK",class="smallButton acceptSmallButton")#</li>
			</ol>

		#endFormTag()#

	</div>
</div>
</cfoutput>

<script type="text/javascript">
$(function() {
	// Wyszukiwanie użytkowników do przekazania dokumentu
	var timeout = null;

    $('.modalsearchusers').live('keypress', function () {

    	if (timeout) {
	        clearTimeout(timeout);
	        timeout = null;
    	}

    	timeout = setTimeout(getUserToWorkflowStep, 500)

    });

});
function getUserToWorkflowStep() {

    var searchValue = $('.modalsearchusers').attr('value');

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

				$('.workflowstepuserlist > option').remove();
				$('.workflowstepuserlist').append(myOPTIONS);
		}
	});

}
</script>