<cfoutput>#includePartial(partial="proposaltypes")#</cfoutput>

<cfoutput>
	<form name="drukuj_wnioski" action="index.cfm?controller=proposals&action=print-proposals" method="post">
<table class="newtables">
	<thead>

		<tr>
			<th colspan="3"class="bottomBorder">
				<label>
					<input type="checkbox" name="select_all" /> Zaznacz wszystkie
				</label>
			</th>
			<th class="bottomBorder"></th>
			<th class="bottomBorder"></th>
			<th class="bottomBorder"></th>
			<th class="bottomBorder"></th>
			<th class="bottomBorder"></th>
			<th class="bottomBorder"></th>
		</tr>

	</thead>

	<tbody>

		<cfloop query="userproposals">
			<tr>
				<td><input type="checkbox" name="proposalid" value="#proposalid#" /></td>
				<td>
					<cfif proposalnum neq ''>
						#proposalnum#
					</cfif>
				</td>
				<td class="proposaltypename">
					<cfif Len(nazwa_wniosku)>
						<a href="index.cfm?controller=proposals&action=view&key=#proposalid#" title="Podgląd wniosku" class="proposalview">#nazwa_wniosku#</a>
					<cfelse>
						<a href="index.cfm?controller=proposals&action=view&key=#proposalid#" title="Podgląd wniosku" class="proposalview">#proposaltypename#</a>
					</cfif>
				</td>
				<td class="proposalstatus">#proposalstatusname#</td>
				<td class="">#usergivenname#</td>
				<td class="">
					
					<cfswitch expression="#proposaltypeid#">
						
						<cfcase value="2" >
							
							<cfif proposalstep1status gt 1 and proposalstatusid gt 1>
						
								<cfswitch expression="#status#">
									<cfcase value="1">
										#linkTo(
											text=imageTag("icon_table.png"),
											controller="Proposals",
											action="getProposalCheckForm",
											key=proposalid,
											params="&view=edit",
											title="Rozliczenie wyjazdu służbowego (w trakcie rozliczania)")#
									</cfcase>
									<cfcase value="2">
										#linkTo(
											text=imageTag("icon_table-accept.png"),
											controller="Proposals",
											action="getProposalCheckForm",
											key=proposalid,
											params="&view=view",
											title="Rozliczenie wyjazdu służbowego (rozliczony)")#
									</cfcase>
									<cfdefaultcase>
										#linkTo(
											text=imageTag("icon_table-blank.png"),
											controller="Proposals",
											action="getProposalCheckForm",
											key=proposalid,
											params="&view=edit",
											title="Rozliczenie wyjazdu służbowego (oczekuje na rozliczenie)")#
									</cfdefaultcase>
								</cfswitch>
								
							</cfif>
							
						</cfcase>
						
						<cfcase value="3" >
							
							<cfif (proposalstep2status eq 2 or proposalstep2status eq 5) and params.key neq 4>
									
								#linkTo(
									text="<span>Odrzucam</span>",
									controller="Proposals",
									action="discard",
									key=proposalid,
									class="discardproposal ajaxproposallink",
									title="Odrzucam wniosek")#
								
								<cfif proposalstep2status eq 2>
									
									#linkTo(
										text="<span>Akceptuje</span>",
										controller="Proposals",
										action="accept",
										key=proposalid,
										params="status=5",
										class="acceptproposal ajaxproposallink",
										title="Akceptuje wniosek")#
										
								<cfelseif proposalstep2status eq 5 >
									
									#linkTo(
										text="<span>Akceptuje</span>",
										controller="Proposals",
										action="accept",
										key=proposalid,
										params="status=6",
										class="acceptproposal ajaxproposallink",
										title="Akceptuje wniosek")#
								</cfif>
							</cfif>
							
						</cfcase>
						
						<cfcase value="4">
							
							<cfif proposalstep1status eq 2 and proposalstatusid eq 1>
								
								#linkTo(
									text="<span>Odrzucam</span>",
									controller="Proposals",
									action="discardNoUser",
									key=proposalid,
									class="discardproposal ajaxproposallink",
									title="Odrzucam wniosek")#
								
								#linkTo(
									text="<span>Akceptuje</span>",
									controller="Proposals",
									action="acceptNoUser",
									key=proposalid,
									class="acceptproposal ajaxproposallink",
									title="Akceptuje wniosek")#
								
							</cfif>
							
						</cfcase>
						
					</cfswitch>
						
				</td>
				<td class="">
					
					<cfif proposaltypeid eq 4 and proposalstatusid eq 2>
						
						#linkTo(
							text=imageTag("new_file.png"),
							controller="Courses",
							action="new",
							key=proposalid,
							title="Zapisz kandydata")#
					</cfif>
					
				</td>
				<td class="">
					
					<cfif proposaltypeid eq 4>
						#linkTo(
							text=imageTag("proposals.png"),
							controller="Proposals",
							action="view",
							key=proposalid,
							title="Podgląd wniosku",
							class="proposalview")#
					<cfelse>
						#linkTo(
							text=imageTag("file-pdf.png"),
							controller="Proposals",
							action="proposalToPdf",
							key=proposalid,
							target="_blank",
							params="&format=pdf",
							title="Eksportuj do PDF")#
					</cfif>

				</td>
				<td class="">
					
					<cfif params.key neq 4>
						#linkTo(
							text="<span>Usuń wniosek z listy</span>",
							controller="Proposals",
							action="hideProposal",
							key=proposalid,
							class="trash",
							title="Usuń wniosek z listy")#
					</cfif>

				</td>
			</tr>
			<tr class="proposaldays">
				<td class="bottomBorder">&nbsp;</td>
				<td class="bottomBorder" colspan="8">
					W dniach: <span>#proposaldate#</span>
				</td>
			</tr>
		</cfloop>

	</tbody>
	<tfoot>
		<tr>
			<td colspan="9" class="r">
				<a href="##" class="admin_button red_admin_button usun_zaznaczone_wnioski">Usuń zaznaczone wnioski z listy</a>
				<a href="index.cfm?controller=proposals&action=company-user-proposals&type=#params.type#&page=0&key=#params.key#" class="admin_button blue_admin_button pokaz_wszystkie_wnioski">Pokaż wszystkie</a>
				<button type="submit" name="drukuj_wnioski_button" class="admin_button green_admin_button">Drukuj zaznaczone</button>
			</td>
		</tr>
	</tfoot>
</table>
</form>
<div id="proposalPreviewDialog" title="Podgląd wniosku" class="proposalDialogBox"></div>
<div class="warpper proposalpaginationlinks">
	
	<cfif up_count gt params.quantity>
		
		<cfif params.page gt 1>
			#linkTo(text="&laquo;", title="poprzednia strona", controller="Proposals", action="companyUserProposals", key=params.key, params="type=#params.type#&page=#params.page-1#", class="proposallink paginationlink")#
		</cfif>

		<cfloop index="idx" from="1" to="#pages#">
			
			<cfif idx gt params.page - 4 and idx lt params.page + 4>
				<cfif idx eq params.page>
					#linkTo(text=idx, controller="Proposals", action="companyUserProposals", key=params.key, params="type=#params.type#&page=#idx#", class="proposallink paginationlink selected")#
				<cfelse>
					#linkTo(text=idx, controller="Proposals", action="companyUserProposals", key=params.key, params="type=#params.type#&page=#idx#", class="proposallink paginationlink")#
				</cfif>
			</cfif>
			
		</cfloop>
		
		<cfif params.page lt pages>
			#linkTo(text="&raquo;", title="nastepna strona", controller="Proposals", action="companyUserProposals", key=params.key, params="type=#params.type#&page=#params.page+1#", class="proposallink paginationlink")#
		</cfif>
		
	</cfif>
	
</div>
<cfif type eq 4>
	<div class="warpper proposallinks">
		#linkTo(
			text="Generuj liste obecności",
			controller="Proposals",
			action="proposalsTimesheet",
			title="Generuj liste obecności",
			class="proposallink")#
	</div>
</cfif>

<!---<cfif session.userid eq 345 >
	<cfdump var="#userproposals#" >
</cfif>--->

</cfoutput>
<script type="text/javascript">
$(function() {
	
	var SearchInput = $("#proposalusername");
	var strLength= SearchInput.val().length;
	SearchInput.focus();
	SearchInput[0].setSelectionRange(strLength, strLength);
	
	$('.ajaxproposallink').on('click', function() {
		//e.preventDefault();
		
		var tr = $(this).parent().parent();
		var links = $(this).parent().parent().find('.ajaxproposallink');
		
		$('#flashMessages').show();
		
		$.ajax({
			type		:		'get',
			dataType	:		'html',
			url			:		$(this).attr('href'),
			success		:		function(data) {
				tr.next().remove();
				tr.remove();
				$('#flashMessages').hide();
			},
			error		:		function(xhr, ajaxOptions, throwError) {}
		});
	});
	
	var timebox;
	$('#proposalusername').on('keyup', function() {
		
		clearTimeout(timebox);
		
		var $this = $(this);
		var givenname = $this.val();
		
		if(givenname.length > 2 || givenname.length == 0){
			
			timebox=setTimeout(function(){
				
				$('#flashMessages').show();
				
				$.ajax({
					type		:		'get',
					dataType	:		'html',
					url			:		<cfoutput>"#URLFor(controller='Proposals',action='companyUserProposals')#"</cfoutput> + "&key=" + <cfoutput>#params.key#</cfoutput> + "&type=" + <cfoutput>#params.type#</cfoutput> + "&user=" + givenname,
					success		:		function(data) {
						
						$('.proposalstat').closest(".ui-tabs-panel").html(data);
						$('#flashMessages').hide();
					},
					error		:		function(xhr, ajaxOptions, throwError) {}
				});
				
			},500);
		}
		
	});
	
	
	$('input[name=select_all]').attr('data-type', 'check');
	$('input[name=select_all]').on('click', function() {
		if ($('input[name=select_all]').attr('data-type') == 'check') {
			$('input[name=proposalid]').prop('checked', true);
			$('input[name=select_all]').attr('data-type', 'uncheck');
		} else {
			$('input[name=proposalid]').prop('checked', false);
			$('input[name=select_all]').attr('data-type', 'check');
		}
			
	});
	
});
</script>