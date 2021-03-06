<cfoutput>

<div class="forms partnerform">
	
	<a name="changestatus"></a>
			
	<h5>Status etapu</h5>
	<ul>
		<li>Aktualny etap: #placeworkflow.placestepname#</li>
		<li>Status: #placeworkflow.placestatusname#</li>
		<li>Data utworzenia: #DateFormat(placeworkflow.placeworkflowstart, "dd-mm-yyyy")# godz. #TimeFormat(placeworkflow.placeworkflowstart, 'HH:mm')#</li>
	</ul>
	
	<cfset disabled = 'true' />
	<cfif (placeworkflow.recordCount eq 1 AND Len(placeworkflow.newplacestatusid) AND placeworkflow.newplacestatusid neq 2 AND placeworkflow.newplacestatusid neq 3) OR (placeworkflow.recordCount eq 1 AND !Len(placeworkflow.newplacestatusid))>
		<cfset disabled = 'false' />
	</cfif>
			
	<h5>Zmień status etapu</h5>
	#startFormTag(
		controller="Places",
		action="changeStatus",
		key=place.id)#
		
		#hiddenFieldTag(
			name="placeid",
			value=place.id)#
		
		#hiddenFieldTag(
			name="stepid",
			value=placeworkflow.placestepid,
			disabled=disabled)#
		
		#hiddenFieldTag(
			name="oldstatus",
			value=placeworkflow.placestatusid,
			disabled=disabled)#
	
		<ol class="horizontal">
			<li>
				#selectTag(
					name="statusid",
					label="Status",
					labelPlacement="before",
					options=placestatuses,
					disabled=disabled)#
			</li>
			<li>
				#selectTag(
					name="placestepstatusreasonid",
					label="Powód",
					labelPlacement="before",
					options=placestepstatusreasons,
					disabled=disabled)#
			</li>
			<li>
				#textAreaTag(
					name="placeworkflownote",
					label="Uwagi to etapu",
					class="textarea",
					labelPlacement="before",
					disabled=disabled)#
			</li>
			<li>
				<cfif (placeworkflow.recordCount eq 1 AND Len(placeworkflow.newplacestatusid) AND placeworkflow.newplacestatusid neq 2 AND placeworkflow.newplacestatusid neq 3) OR (placeworkflow.recordCount eq 1 AND !Len(placeworkflow.newplacestatusid))>
				
					#submitTag(value="Zmień status",class="button redButton changestatusbutton",disabled=disabled)#
					
				<cfelse>
				
					#submitTag(value="Zmień status",class="button darkGrayButton",disabled=disabled)#
				
				</cfif>
			
			</li>
		</ol>
	
	#endFormTag()#
</div>

</cfoutput>

<script>
$(function() {
	
	$('.changestatusbutton').live('click', function(e) {
     	
     	$('#flashMessages').show();
     	$('.required').removeClass('redborder');
     
    	$('.required').each(function (index) {
    		if(!$(this).attr('value') != '') {
    			e.preventDefault();
    			$(this).addClass('redborder');
    			$('#flashMessages').hide();
     			scrollTo(0,0);
    		}
    	});
     });
});
</script>