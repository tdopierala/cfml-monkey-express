<cfoutput>

	<div class="wrapper" id="top">
	
		<h4>Uzupełnienie danych</h4>
		
		<div class="forms placesupplement">
		
			#startFormTag(
				method="post",
				controller="Places",
				action="actionUpdateAttributes",
				id="supplementform")#
			
			<cfset disabled = 'false' />
			<cfif workflow.step3status neq 1>
				<cfset disabled = 'true' />
			</cfif>
			
				<cfloop collection="#r#" item="i">
					
					<cfset q = r[i] />
					<cfif q.recordCount>
					
					<!---
					14.09.2012
					Sprawdzam, czy użytkownik nalezy do określonej grupy uprawnień. Jeżeli tak, to atrybuty są edytowalne.
					Jeżeli nie to atrybuty są nieedytowalne.
					--->
					<cfif workflow.step3status eq 1 and not checkUserGroup(userid=session.userid,usergroupname="#i#")>
						
						<cfset disabled = 'true' />
						
					</cfif>
					
						<h5>#i#</h5>
						<ol class="horizontal">
							<cfloop query="q">
							
								<cfparam name="required" default="" />
								
								<cfif attributerequired eq 1>
								
									<cfset required = "required" />
								
								<cfelse>
								
									<cfset required = "" />
								
								</cfif>
							
								<li>
									
									<cfif attributetypeid eq 1>
								
										#textFieldTag(
											name="placeattributevalue[#placeattributevalueid#]",
											value=placeattributevaluetext,
											label=attributename,
											class="input #required#",
											labelPlacement="before",
											disabled=disabled)#
									
									<cfelseif attributetypeid eq 2>
									
										#textAreaTag(
											name="placeattributevalue[#placeattributevalueid#]",
											content=placeattributevaluetext,
											label=attributename,
											class="textarea #required#",
											labelPlacement="before",
											disabled=disabled)#
									
									<cfelseif attributetypeid eq 5>
									
										#selectTag(
											name="placeattributevalue[#placeattributevalueid#]",
											label=attributename,
											labelPlacement="before",
											options=options[attributeid],
											selected=placeattributevaluetext,
											disabled=disabled,
											class="#required#")#
									
									</cfif>
		
								</li>
							</cfloop>
						</ol>
					</cfif>
					
				</cfloop>
				
				<ol class="horizontal">
					<li>
					
						<cfif workflow.step3status neq 1>
						
							#submitTag(value="Zapisz formularz",class="button darkGrayButton",disabled=disabled)#
							
						<cfelse>
							
							#submitTag(value="Zapisz formularz",class="button redButton",disabled="false")#
						
						</cfif>
					
					</li>
				</ol>
			
			#endFormTag()#
		
		</div>
		
		#includePartial(partial="changestatus")#
	
	</div>

</cfoutput>

<script>

$(function() {
	$('#supplementform').submit(function(e) {
		e.preventDefault();
		$('#flashMessages').show();
		
		$.ajax({
			data		:		$(this).serialize(),
			type		:		"post",
			dataType	:		"html",
			url			:		$(this).attr('action'),
			success		:		function(data) {
				$('.ajaxcontent').html(data);
				$('#flashMessages').hide();
			}
		});
	});
	
	$('.required').each(function (index) {
		$(this).parent().append("<span class=\"requiredfield\">*</span>");
	});
});

</script>