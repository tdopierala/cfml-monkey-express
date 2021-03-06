<cfoutput>
<h4>Moje wnioski <span class="userproposalscount">(#myproposals.RecordCount#)</span> <span class="showhideproposals">pokaż/ukryj</span></h4>

<div class="userproposalstable">
	<table class="newtables" id="userProposalsTable">
		<thead>
			<tr class="top">
				<td colspan="6" class="bottomBorder">&nbsp;</td>
			</tr>
		</thead>
		<tbody>
			<cfloop query="myproposals">
				<tr>
					<td class="bottomBorder">
					
						<cfif proposalstep1status eq 1>
						
							#linkTo(
								text=proposaltypename,
								controller="Proposals",
								action="edit",
								key=proposalid,
								title="Zobacz wniosek",
								class="ajaxlink")#
						
						<cfelse>
						
							#linkTo(
								text=proposaltypename,
								controller="Proposals",
								action="view",
								key=proposalid,
								title="Zobacz wniosek",
								class="ajaxlink")#
						
						</cfif>
						
					</td>
					
					<td class="bottomBorder c">
					
						<cfswitch expression="#proposalstep2status#">
							
							<cfcase value="1">
								#imageTag(source="progress-bar.png",alt="Wniosek w trakcie rozpatrywania",title="Wniosek w trakcie rozpatrywania")#
							</cfcase>
							
							<cfcase value="2">
								#imageTag(source="yes.png",alt="Wniosek został zaakceptowany",title="Wniosek został zaakceptowany")#
							</cfcase>
							
							<cfcase value="3">
								#imageTag(source="no.png",akt="Wniosek został odrzucony",title="Wniosek został odrzucony")#
							</cfcase>
						
						</cfswitch>
					
					</td>
					<td class="bottomBorder">
						#linkTo(
							text=imageTag("file-pdf.png"),
							controller="Proposals",
							action="proposalToPdf",
							key=proposalid,
							target="_blank",
							params="&format=pdf",
							title="Eksportuj do PDF")#
					</td>
					<td class="bottomBorder">
						<cfif proposaltypeid eq 2 and proposalstep2status eq 2>
							
							<cfswitch expression="#tripstatus#" >
								<cfcase value="1">
									#linkTo(
										text=imageTag("icon_table.png"),
										controller="Proposals",
										action="getProposalCheckForm",
										key=proposalid,
										params="&view=edit",
										title="Rozlicz wyjazd służbowy")#
								</cfcase>
								<cfcase value="2">
									#linkTo(
										text=imageTag("icon_table-accept.png"),
										controller="Proposals",
										action="getProposalCheckForm",
										key=proposalid,
										params="&view=view",
										title="Podgląd rozliczenia wyjazdu służbowego")#
								</cfcase>
								<cfdefaultcase>
									#linkTo(
										text=imageTag("icon_table-blank.png"),
										controller="Proposals",
										action="getProposalCheckForm",
										key=proposalid,
										params="&view=edit",
										title="Rozlicz wyjazd służbowy")#
								</cfdefaultcase>
							</cfswitch>
							
								
						</cfif>
					</td>
					<td class="bottomBorder">
					
						<cfif proposalstep2status neq 2 and proposalstep2status neq 3>
						
							#linkTo(
								text="<span>Usuń wniosek</span>",
								controller="Proposals",
								action="delete",
								key=proposalid,
								class="deleteproposal")#
								
						<cfelse>
							&nbsp;
						</cfif>
					
					</td>
					<td class="bottomBorder c">
					
						<cfif proposalstep2status neq 2 and proposalstep2status neq 3>
						
							#linkTo(
								text="<span>Edytuj wniosek</span>",
								controller="Proposals",
								action="edit",
								key=proposalid,
								class="icon_edit",
								title="Edytuj wniosek")#
								
						<cfelse>
							&nbsp;
						</cfif>
					
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
	
	<!---
<div class="userproposalinfo">
		Wyświetlane są wszystkie Twoje wnioski z ostatnich 30 dni.
	</div>
--->
</div>

</cfoutput>

<script type="text/javascript">
$(function() {
	$('.deleteproposal').live('click', function(e) {
		e.preventDefault();
		var jtr = $(this).parent().parent();
		$('#flashMessages').show();
		$.ajax({
			type		:		'get',
			dataType	:		'html',
			url		:		$(this).attr('href'),
			success		:		function(data) {
				jtr.remove();
				$('#flashMessages').hide();
			},
			error		:		function(xhr, ajaxOptions, throwError) {}
		});
	});
});
</script>