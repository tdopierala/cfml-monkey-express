<cfoutput>
<h4>Wnioski do akceptacji <span class="userproposalscount">(#chairmanproposals.RecordCount#)</span> <span class="showhideproposals">pokaż/ukryj</span></h4>

<div class="userproposalstable">

	<table class="newtables" id="userProposalsTable">
		<thead>
			<tr class="top">
				<td class="bottomBorder" colspan="5"></td>
			</tr>
		</thead>
		<tbody>
			<cfloop query="chairmanproposals">
				<tr>
					<td class="bottomBorder c">#usergivenname#</td>
					<td class="bottomBorder">#proposaldate#</td>
					<td class="bottomBorder c" colspan="2">
					
						#linkTo(
							text="<span>Akceptuje</span>",
							controller="Proposals",
							action="accept",
							key=proposalid,
							class="acceptproposal ajaxproposallink",
							title="Akceptuje wniosek")#
							
						#linkTo(
							text="<span>Odrzucam</span>",
							controller="Proposals",
							action="discard",
							key=proposalid,
							class="discardproposal ajaxproposallink",
							title="Odrzucam wniosek")#
							
					</td>
					<td class="bottomBorder c">
					
						#linkTo(
							text=imageTag("file-pdf.png"),
							controller="Proposals",
							action="proposalToPdf",
							key=proposalid,
							target="_blank",
							params="&format=pdf",
							title="Eksportuj do PDF")#

					
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
	
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
				tr.remove();
				$('#flashMessages').hide();
			},
			error		:		function(xhr, ajaxOptions, throwError) {}
		});
	});
	
});

</script>