			<cfoutput>
				<cfif locations.RecordCount gt 0>
					<cfset counter=0 />
					<cfloop query="locations">
						<cfset counter++ />
						<tr>
							<td>#counter#</td>
							<td>#projekt#</td>
							<!---<td>#postcode#</td>--->
							<td>#city#, #adress#</td>
							<td><a href="#URLFor(action='profile',key=studentid)#" data-key="#studentid#" title="#name#" class="profile_tooltip">#name#</a></td>
							<td>
								<cfif planneddate neq ''>
									#DateFormat(planneddate, "dd.mm.yyyy")#
								</cfif>
							</td>
							<!---<td>#email#</td>--->
							<!---<td>#phone#</td>--->
							<td>
								<cfif ArrayIsDefined(courses, id)>
									<cfset course = courses[id] /> 
									<cfloop query="course">
										<cfset ctype = coursetype['name'][course.typeid] />
										<span class="course-btn course_tooltip" title="Szkolenie #Right(ctype, Len(ctype)-10)#" data-cid="#course.id#" data-sid="#locations.studentid#">#Right(ctype, Len(ctype)-10)#</span>
									</cfloop>
								</cfif>
							</td>
							<td>#Replace(NumberFormat(bep, "__,___.__"), ",", " ", "ALL")#</td>
							<td style="font-size:11px;">
								<cfif contract neq ''>
									#contractstatus['name'][contract]#
								</cfif>
							</td>
							<td style="text-align:center;">
								<cfif asseco gt 0>
									#imageTag("check.png")#
								</cfif>
							</td>
							<td>
								<!---#ds#--->
								#DateFormat(dsdate, "dd.mm.yyyy")#
							</td>
							<td>
								<a href="#URLFor(action='location-edit',key=id)#" data-source="location-edit" class="dialog">#imageTag("material.png")#</a>&nbsp;
								<a href="#URLFor(action='location-confirm',key=id)#" data-source="location-confirm" class="dialog">#imageTag("invoice.png")#</a>&nbsp;
								<a href="#URLFor(action='location-remove',key=id)#" data-source="location-remove" class="prompt">#imageTag("delete_icon.png")#</a>
							</td>
						</tr>
					</cfloop>
				<cfelse>
					<tr>
						<td colspan="11" style="text-align:center;">
							<h5>Brak wyników dla wskazanych kryteriów</h5>
						</td>
					</tr>
				</cfif>
			</cfoutput>
<script>
	$(function(){
		
		$(".locations-table").find(".profile_tooltip").tooltip({
			position: { my: "left+50 top+5" },
			open: function( event, ui ) {
				
				var $this = $(ui.tooltip);
				
				$.ajax({
					type: 'GET',
					url: '<cfoutput>#URLFor(action="profile")#</cfoutput>',
					data: { key	: $(this).data("key") },
					dataType: "html",
					
					success: function(data, status, xhr){
						$this.html(data);
					},
					
					error: function(){
						alert("Pobranie danych nie powiodło się. Spróbuj ponownie później.");
					}
				});
			}
		});
		
		$(".locations-table").find(".course_tooltip").tooltip({
			position: { my: "left+50 top+5" },
			open: function( event, ui ) {
				
				var $this = $(ui.tooltip);
				
				$.ajax({
					type: 'GET',
					url: '<cfoutput>#URLFor(action="gradebook-preview")#</cfoutput>',
					data: { sid	: $(this).data("sid"), cid : $(this).data("cid") },
					dataType: "html",
					success: function(data, status, xhr){
						$this.append(data);
					},
					error: function(){
						alert("Pobranie danych nie powiodło się. Spróbuj ponownie później.");
					}
				});
			}
		});
		
	});
</script>