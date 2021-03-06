<cfoutput>
	<div class="wrapper">
	
		<h3>Akceptacja dokumentów</h3>
	
		<div class="wrapper">
		
			<cfoutput>#includePartial(partial="/users/subnav",cache=0)#</cfoutput>
					
		</div>
		
		<div class="wrapper">
		
			<cfoutput>#includePartial(partial="/workflows/chairmanworkflowactions")#</cfoutput>
		
			<cfif chairmanworkflow.RecordCount eq 0>
			
				<div class="chairmanworkflowinfo">
				Nie masz więcej dokumentów.
				</div>
				
			</cfif>
			<!--- Tutaj znajduje się tabelka dla Prezesa --->
			<table class="newtables" id="chairmanworkflow">
				<thead>
					<tr class="top">
						<th class="bottomBorder">&nbsp;</th>
						<th class="bottomBorder">&nbsp;</th>
						<th class="bottomBorder">&nbsp;</th>
						<th class="bottomBorder">&nbsp;</th>
						<th class="bottomBorder">&nbsp;</th>
						<th class="bottomBorder">&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="chairmanworkflow">
						<tr>
							<td class="bottomBorder">#checkBoxTag(name="workflowid",value=workflowid,class="workflowrow",label=false)#</td>
							<td class="bottomBorder">
								#linkTo(
									text=documentname,
									controller="Workflows",
									action="step",
									key=workflowid,
									title=documentname,
									class="")#
							</td>
							<td class="bottomBorder">#contractorname#</td>
							<td class="bottomBorder">#workflowstepnote#</td>
							<td class="bottomBorder">#brutto#</td>
							<td class="bottomBorder">
								#linkTo(
									text="<span>Zamknij obieg tego dokumentu</span>",
									controller="Workflows",
									action="closeInvoiceRow",
									key=workflowid,
									class="closeInvoiceRow",
									title="Zamknij obieg tego dokumentu")#
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		
			<cfoutput>#includePartial(partial="/workflows/chairmanworkflowactions")#</cfoutput>
		
		</div>
			
	</div>
</cfoutput>

<script type="text/javascript">
$(function() {
	$('.closeInvoiceRow').live('click', function(e) {
		e.preventDefault();
		$('#flashMessages').show();
		var row = $(this);
		
		$.ajax({
			type		:		'post',
    		dataType	:		'html',
    		url			:		$(this).attr('href'),
    		success		:		function(data) {
				row.parent().parent().remove();
    			$('#flashMessages').hide();
    		}
		});
	});
	
	$('.closeInvoiceRows').live('click', function(e) {
		e.preventDefault();
		$('#flashMessages').show();
		
		var url = $(this).attr('href');
		
		$('.workflowrow:checked').each(function(index) {
			var row = $(this);
			$.ajax({
				type		:		'post',
				dataType	:		'html',
				data		:		{key:$(this).attr('value')},
				url			:		url,
				success		:		function(data) {
					row.parent().parent().remove();
				},
				error		:		function(xhr, ajaxOptions, throwError) {
					alert("Ups… Wystąpił błąd systemu. Przepraszamy.");
				}
			});
		
		});
		
	});
});
</script>