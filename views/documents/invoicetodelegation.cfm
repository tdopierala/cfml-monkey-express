<cfoutput>

	<div class="wrapper">
	
		<h3>Faktury do delegacji</h3>
		
		<div class="wrapper">
		
			<table class="newtables" id="userWorkflowTable">
				<thead>
					<tr class="top">
						<th class="bottomBorder">NUMER FAKTURY</th>
						<th class="bottomBorder">DATA DODANIA</th>
						<th class="bottomBorder">OPIS MERYTORYCZNY</th>
						<th class="bottomBorder">BRUTTO</th>
						<th class="bottomBorder">KONTRAHENT</th>
						<th class="bottomBorder"></th>
						<th class="bottomBorder"></th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="invoices">
						<tr class="#documentid#">
							<td class="bottomBorder">
							
								#linkTo(
									text=documentname,
									controller="Workflows",
									action="previewByHr",
									key=workflowid)#
							
							</td>
							<td class="bottomBorder c">#DateFormat(workflowcreated, "dd/mm/yyyy")#</td>
							<td class="bottomBorder">#workflowstepnote#</td>
							<td class="bottomBorder c">#brutto#</td>
							<td class="bottomBorder c">#contractorname#</td>
							<td class="bottomBorder c">
							
								#linkTo(
									controller="Documents",
									action="getDocument",
									key=documentid,
									text="<img src='images/file-pdf.png' title='Kliknij aby pobrać dokument PDF' />",
									target="_blank",
									class="fltr",
									title="Kliknij any pobrać dokument PDF")#

							</td>
							<td class="bottomBorder c">
								
								#linkTo(
									text="<span>ukryj</span>",
									controller="documents",
									action="hrHideInvoice",
									key=documentid,
									class="trash hrhideinvoice",
									title="Usuń fakturę z listy",
									params="&format=json")#
								
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		
		</div>
	
	</div>

</cfoutput>

<script>
$(function() {
	$('.hrhideinvoice').live('click', function(e) {
		e.preventDefault();
		$('#flashMessages').show();
		
		$.ajax({
			type		:		'post',
			dataType	:		'json',
			url			:		$(this).attr('href'),
			success		:		function(data) {

				if (data.id) {
					$('.'+data.id).remove();
				}
				$('#flashMessages').hide();
			}
		});
	});
});
</script>