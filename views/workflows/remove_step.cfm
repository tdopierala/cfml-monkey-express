<cfoutput>	
	<div class="ajaxcontent">
	</div>
</cfoutput>

<script type="text/javascript" src="<cfoutput>http://#cgi.server_name#/#get('loc').intranet.directory#/javascripts/workflows/step.js</cfoutput>"></script>

<script type="text/javascript">
$(function() {	
	if ($.trim($('.ajaxcontent').text()) == '') {
	
		$('#flashMessages').show();
	
		$.ajax({
			type		:	'post',
			dataType	:	'html',
			data		:	{},
			url			:	"<cfoutput>#URLFor(controller='Workflows',action='userStep',key=params.key,params='cfdebug')#</cfoutput>",
			success		:	function(data) {
				$('.ajaxcontent').html(data);
				$('#flashMessages').hide();
			},
			error		:	function(xhr, ajaxOptions, thrownError) {
				alert(xhr.status + ': ' + xhr.statusText);
			}
		});
	}
		
	<!---
	Pobieranie kolenjego wiersza do tabelki mpk/projekt/netto.
	Element jest pobierany AJAXowo.
	TODO
	Dodawanie nowego wiersza po wciśnięciu TAB będąc na ostatnim polu formularza.
	--->
	$('.newRow').live('click', function (e) {
		e.preventDefault();
		ajaxAddRow();
		
		validateinvoicetable();
	});
	
	function ajaxAddRow() {
		$.ajax({
			type		:	'get',
			dataType	:	'html',
			url			:	<cfoutput>"#URLFor(controller='Workflows',action='getTableRow',params='cfdebug')#"</cfoutput>,
			success		:	function(data) {
				$('#workflowStepDescTable tbody tr.last').before(data);
			}
		});
	}
	
});
</script>