<cfoutput>
	
	<div class="wrapper concessions">
		
		<h3>Wniosek o refundacje koncesji</h3>
		
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		<cfelseif flashKeyExists("error")>
			<span class="error">#flash("error")#</span>
		</cfif>
		
		#startFormTag(action="save-proposal", id="document-form")#
			
			#hiddenFieldTag(name="proposalid", value=concession.concessionproposalid)#

			<div class="wrapper proposalform">
				
				<ol class="proposalfields">
					<cfloop query="documentattributevalues">
						<li>
							<cfif required eq 1 >
								<cfset req = ' required' />
							<cfelse>
								<cfset req = ' notrequired' />
							</cfif>
									
							<cfswitch expression="#attributetypeid#" >
										
								<cfcase value="1" >
										
									#textFieldTag(
										name="attributevalue[#id#]",
										value=value,
										label=label,
										labelPlacement="before",
										class="input #req#")#
											
								</cfcase>
									
								<cfcase value="2" >
									
									#textAreaTag(
										name="attributevalue[#id#]",
										content=value,
										label=label,
										labelPlacement="before",
										class="textarea #req#")#
										
								</cfcase>
										
								<cfcase value="3" >
											
									#fileFieldTag(
										name="attributevalue[#id#]",
										label=label,
										labelPlacement="before",
										class="filefield #req#")#
										
								</cfcase>
										
								<cfcase value="4" >
				
									#textFieldTag(
										name="attributevalue[#id#]",
										value=value,
										label=label,
										labelPlacement="before",
										class="input date_picker #req#")#
											
								</cfcase>
										
								<cfcase value="5" >
									
									#textFieldTag(
										name="attributevalue[#id#]",
										value=value,
										label=label,
										labelPlacement="before",
										class="input #req#")#
									
									<!---#selectTag(
										name="proposalattributevalue[#id#]",
										options=VARIABLES['options' & attributeid],
										selected="#proposalattributevaluetext#",
										includeBlank=false,
										label=attributename,
										labelPlacement="before",
										class=required)#
									<!-- #proposalattributevaluetext# -->--->
								</cfcase>
										
							</cfswitch>
						</li>
					</cfloop>
				</ol>
			</div>
			
			<div class="wrapper proposalform">
				
				#submitTag(value="Potwierdź i wyślij",class="smallButton redSmallButton confirmButton sendProposal")#
				
				#submitTag(value="Zapisz zaminy",class="smallButton redSmallButton confirmButton saveProposal")#
				
			</div>
			
		#endFormTag()#
	</div>
		
</cfoutput>
<script>
	$(function(){
		
		$(".confirmButton").on("click", function(){
			
			_this = $(this);
			
			$("#flashMessages").show();
			
			$("#document-form").submit();
			
			return false;
		});
		
		$("#document-form").ajaxForm({
			dataType	: 'json',
			type		: 'post',
			success		: function (responseText, statusText, xhr, $form){
									
				$("#flashMessages").hide();
					
				if(_this.hasClass("sendProposal")){
						
					if($("#proposalid").val() != 'undefined') {
						console.log(<cfoutput>"#URLFor(controller='Concessions', action='accept-proposal')#"</cfoutput> + '&proposalid=' + $("#proposalid").val());
						document.location = <cfoutput>"#URLFor(controller='Concessions', action='accept-proposal')#"</cfoutput> + '&proposalid=' + $("#proposalid").val();
					}
					else
						alert('Błdny numer wniosku');
						
				}
			}
		});
		
	});
</script>