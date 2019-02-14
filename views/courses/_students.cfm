<cfoutput>
				
			<cfset counter = params.amount * (params.page - 1) />
			
				<cfloop query="students">
					<cfset counter++ />
					<tr>
						<td>#counter#</td>
						<!---<td>#id#</td>--->
						<td>
							<cfif recruitmentstatusid eq 6>
								<img src="images/application-import.png" alt="zaimportowany" title="Profil wprowadzony przez PdsR" />
							</cfif>
							<cfif fullprofile eq 1>
								<img src="images/check.png" alt="wypełniony" title="Profil wypełniony" />
							</cfif>
						</td>
						<td>#name#</td>
						<td>#studentid#</td>
						<td>#selectlabel#</td>
						<!---<td>#attributeoptions['name'][type]#</td>--->
						<td>#studentstatus#</td>
						<td><a href="mailto:#email#">#email#</a></td>
						<td>#phone#</td>
						<td>#DateFormat(createddate, "yyyy-mm-dd")#</td>
						<!---<td>
							
						</td>--->
						<td>
							#linkTo(
								text=imageTag(source="materials.png", alt="profil kandydata", width="16", height="16"),
								title="Profil kandydata",
								class="vw_student",
								controller="Courses",
								action="profile",
								key=id)#
							#linkTo(
								text=imageTag(source="icon-edit.png", alt="edycja kandydata", width="16", height="16"),
								title="Edycja danych kandydata",
								class="vw_student",
								controller="Courses",
								action="edit",
								key=id)#
							#linkTo(
								text=imageTag(source="delete_icon.png", alt="usuń kandydata", width="16", height="16"),
								title="Usuń kandydata",
								class="vw_student student_remove",
								controller="Courses",
								action="student-remove",
								key=id)#
						</td>
					</tr>
					
				</cfloop>
</cfoutput>
<script>
	$(function(){
		
		$(".paginator").html('');
		var page = <cfoutput>#params.page#</cfoutput>;
		var pages = <cfoutput>#pages#</cfoutput>;
		var count = <cfoutput>#count#</cfoutput>;
		var amount = <cfoutput>#params.amount#</cfoutput>;
		
		if(page>1){
			$(".paginator").append(
				$("<a>").addClass("paginlink").data("page",page).attr("href", "##").html("&laquo;"));
		}
		
		for(i=1; i<=pages; i++){
			
			if((page) == i) var selected = 'selected';
			else var selected = '';
			
			if( i >= (page-3) && i <= (page+5) ){
				$(".paginator").append(
					$("<a>").addClass("paginlink " + selected).data("page",i).attr("href", "#").text(i));
			}
		}
		
		if(page<pages && count > amount){
			$(".paginator").append(
				$("<a>").addClass("paginlink").data("page",page+2).attr("href", "#").html("&raquo;"));
		}
	});
</script>