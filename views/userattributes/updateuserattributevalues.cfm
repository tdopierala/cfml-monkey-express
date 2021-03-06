<cfoutput>

	<div class="wrapper">
	
		<h3>Edytuj profil</h3>
		
		<!--- <div class="wrapper">
		
			<cfoutput>#includePartial(partial="/users/subnav",cache=0)#</cfoutput>
					
		</div> --->
		
		<div class="wrapper">
		
			#startFormTag(action="actionUpdateUserAttributeValue",class="updateUserAttributesForm")#
			
				<ol>
					<cfloop query="userattributes">
						<li>
						
							<cfset elementclass = "" />
							<cfif attributerequired eq 1>
								<cfset elementclass = " required " />
							</cfif>
						
							<cfif attributetypeid eq 1>
							
								#textFieldTag(
									name="userattributevalue[#attributeid#]",
									value=userattributevaluetext,
									label=attributelabel,
									labelPlacement="before",
									class="input #elementclass#")#
							
							<cfelseif attributetypeid eq 2>
							
								#textAreaTag(
									name="userattributevalue[#attributeid#]",
									content=userattributevaluetext,
									label=attributelabel,
									labelplacement="before",
									class="textarea #elementclass# ckeditor")#
							
							<cfelseif attributetypeid eq 5> <!--- Jeśli elementem formularza jest pole wyboru --->
							
								<cfif attributeid eq 125>
								
									#selectTag(
										label=attributelabel, 
										name="userattributevalue[#attributeid#]", 
										options=departmentoptions,
										labelPlacement="before",
										includeBlank=true,
										class="select_box",
										selected="#userattributevaluetext#")#

								</cfif>
							
							</cfif>
							
							#hiddenFieldTag(
								name="userattributeldapname[#attributeid#]",
								value=attributename)#
						
						</li>
					</cfloop>
					
					<li>
						Pola oznaczone <span class="requiredfield">*</span> są wymagane.
					</li>
					<li>
						#submitTag(value="Zapisz",class="button redButton actionUpdateUserAttributeValues")#
					</li>
				</ol>
			
			#endFormTag()#
		
		</div>
	
	</div>

</cfoutput>

<script type="text/javascript">

$(function() {
	/*
	 * Umieszczenie gwiazdki przy wymaganym polu formularza
	 */
	$('.required').each(function(index) {
		$(this).parent().append("<span class=\"requiredfield\">*</span>");
	});
	
	$('.actionUpdateUserAttributeValues').live('click', function() {
	
	});
});

</script>
