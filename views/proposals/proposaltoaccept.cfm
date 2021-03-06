<cfoutput>
	<div class="wrapper">
		<h3>Wnioski do akceptacji</h3>
	
		<div class="wrapper">
		
			<cfoutput>#includePartial(partial="/users/subnav",cache=0)#</cfoutput>
			
			<div id="userproposalstoaccept" class="wrapper">
			
				<cfif proposals.RecordCount eq 0>
					<div class="userproposalinfo">
						Nie masz wniosków do zaakceptowania.
					</div>
				</cfif>
			
				<table class="newtables">
					<thead>
						<tr class="top">
							<th></th>
							<th></th>
							<th></th>
							<th></th>
							<th></th>
							<th></th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="proposals">
							<tr>
								<td class=""></td>
								<td class="">
								
									#linkTo(
										text=proposaltypename,
										controller="Proposals",
										action="view",
										key=proposalid,
										title="Zobacz wniosek")#
								
								</td>
								<td class="">
								
									#linkTo(
										text="#usergivenname#",
										controller="Proposals",
										action="view",
										key=proposalid,
										title="Zobacz wniosek")#
								
								</td>
								<td class=""></td>
								<td class=""></td>
								<td class="">
								
									#linkTo(
										text=imageTag("file-pdf.png"),
										controller="Proposals",
										action="proposalToPdf",
										key=proposalid,
										target="_blank",
										params="&format=pdf",
										title="Eksportuj do PDF")#
								
								</td>
								<td class="">
									
									#linkTo(
										text="<span>Odrzucam</span>",
										controller="Proposals",
										action="discard",
										key=proposalid,
										class="discardproposal ajaxproposallink",
										title="Odrzucam wniosek")#
									
									#linkTo(
										text="<span>Akceptuje</span>",
										controller="Proposals",
										action="accept",
										key=proposalid,
										class="acceptproposal ajaxproposallink",
										title="Akceptuje wniosek")#

									
								</td>
							</tr>
							<tr class="proposaldays">
								<td class="bottomBorder" colspan="7">
									Urlop w dniach: <span>#proposaldate#</span>
								</td>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</div>
			
		</div>
	
	</div>
</cfoutput>

<script type="text/javascript">

$(function() {
	$('.ajaxproposallink').live('click', function(e) {
		e.preventDefault();
		var tr = $(this).parent().parent();
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
	
});

</script>