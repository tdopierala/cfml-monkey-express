<cfoutput>	
	<div class="ajaxcontent">
	</div>
</cfoutput>

<script type="text/javascript" src="<cfoutput>http://#cgi.server_name#/#get('loc').intranet.directory#/javascripts/workflows/preview.js</cfoutput>"></script>

<script type="text/javascript">
$(function() {
	if ($.trim($('.ajaxcontent').text()) == '') {
		$('#flashMessages').show();
		$.ajax({
			type		:	'post',
			dataType	:	'html',
			data		:	{},
			url			:	"<cfoutput>#URLFor(controller='Workflows',action='descriptionPreview',key=params.key,params='cfdebug')#</cfoutput>",
			success		:	function(data) {
				$('.ajaxcontent').html(data);
				$('#flashMessages').hide();
			},
			error		:	function(xhr, ajaxOptions, thrownError) {
				alert(xhr.status + ': ' + xhr.statusText);
			}
		});
	}
});
</script>