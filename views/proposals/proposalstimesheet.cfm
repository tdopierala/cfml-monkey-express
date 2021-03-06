<cfoutput>
	<div class="wrapper">
		<h3>Wnioski dla kandydata na PPS</h3>
		
		<div class="wrapper ajaxproposaltable">
			
			<div class="wrapper proposalpreview proposaltimesheetselector">
				<h5>Filtrowanie zgłoszeń wg daty szkolenia</h5>
				
				#textFieldTag(
					name="proposaltimesheetdatefrom",
					value=DateFormat(params.from, 'yyyy-mm-dd'),
					label="Od:",
					labelPlacement="before",
					class="input date_picker")#
					
				#textFieldTag(
					name="proposaltimesheetdateto",
					value=DateFormat(params.to, 'yyyy-mm-dd'),
					label="Do:",
					labelPlacement="before",
					class="input date_picker")#
					
			</div>
			
			<table class="newtables proposaltimesheettable">
				
				<thead>
					<tr class="head">
						<th class="bottomBorder">Numer wniosku</th>
						<th class="bottomBorder">Data złożenia wniosku</th>
						<th class="bottomBorder">Imie i nazwisko kandydata</th>
						<th class="bottomBorder">Data szkolenia</th>
					</tr>
				</thead>
				
				<tbody>
					#includePartial("proposalstimesheet")#
				</tbody>
				
			</table>
			
			<div class="warpper proposallinks">
				#linkTo(
					text="Generuj plik pdf",
					controller="Proposals",
					action="proposalsTimesheet",
					title="Generuj plik pdf",
					class="proposallink timesheettopdf",
					target="_blank")#
					
				#linkTo(
					text="Generuj plik Excel",
					controller="Proposals",
					action="proposalsTimesheet",
					title="Generuj plik Excel",
					class="proposallink timesheettoxls",
					target="_blank")#
			</div>
			
		</div>
		
	</div>
</cfoutput>
<!---<cfif IsDefined(userproposals)>
	<cfdump var="#userproposals#" />
</cfif>
<cfif IsDefined(proposalsattr)>
	<cfdump var="#proposalsattr#" />
</cfif>--->
<script>
	$(function(){
		
		$(".timesheettopdf").on("click", function(){
			var url = <cfoutput>"#URLFor(controller='proposals',action='proposals-timesheet',params='view=pdf')#"</cfoutput> + '&from=' + $("#proposaltimesheetdatefrom").val() + '&to=' + $("#proposaltimesheetdateto").val();
			$(this).attr("href",url);
		});
		
		$(".timesheettoxls").on("click", function(){
			var url = <cfoutput>"#URLFor(controller='proposals',action='proposals-timesheet',params='view=xls')#"</cfoutput> + '&from=' + $("#proposaltimesheetdatefrom").val() + '&to=' + $("#proposaltimesheetdateto").val();
			//alert(url);
			$(this).attr("href",url);
			//return false;
		});
		
		$(".proposaltimesheetselector").find(".input").on("change", function(){
			$("#flashMessages").show();
			
			$.ajax({
				type		:	'get',
				dataType	:	'html',
				url		:	<cfoutput>"#URLFor(controller='proposals',action='proposals-timesheet')#"</cfoutput> + '&from=' + $("#proposaltimesheetdatefrom").val() + '&to=' + $("#proposaltimesheetdateto").val(),
				success	:	function(data) {
					
					$(".proposaltimesheettable").children("tbody").slideUp().html(data);
					$(".proposaltimesheettable").children("tbody").slideDown();
					
					$("#flashMessages").hide();
				}
			});
			
		});
	});
</script>