<style>
	.sms-table tr.details td { line-height: 200%; padding: 0 5px; }
	.sms-table tr.list:hover { background: #ebebeb; cursor: pointer; }
	.sms-table tr.details td {  }
	.sms-table tr .inner_details { display: none; padding: 10px; border: 1px solid #cccccc; }
	.sms-table span.head { width: 100px; display: inline-block; font-weight: bold; }
	.sms-table span.body { width: 200px; display: inline-block; }
	.selected { font-weight: bold; }
</style>
<script>
	$(function(){
		
		$("tr.list").on("click", function(){
			//console.log($(this).next("tr").find("td").find("div").css("display"));
			
			if(  $(this).next("tr").find("td").find("div").css("display") == 'none' ){
				
				$("td").removeClass("selected");
				$("tr.details").find("td").find("div").slideUp('fast');
				
				$(this).next("tr").find("td").find("div").slideDown('fast');
				$(this).find("td").addClass("selected");
				
			} else {
				
				$(this).find("td").removeClass("selected");
				$(this).next("tr").find("td").find("div").slideUp('fast');
				
			}
			
		});
		
	});
</script>
<cfoutput>
	
	<div class="wrapper">
		<h3>Sms do PPS</h3>
		
		<div class="wrapper">
			
			<table class="tables sms-table">
				<thead>
					<tr>
						<th>nadawca</th>
						<th>nr sklepu</th>
						<th>data odebrania</th>
						<th>status</th>
						<th>raport</th>
						<th>punkty</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="sms">
						<tr class="list">
							<td>#sms_from#</td>
							<td>#store#</td>
							<td>#sms_date#</td>
							<td>
								<cfif status eq 0>
									<span>Odebrany</span>
								<cfelse>
									<span>Wysłany</span>
								</cfif>
							</td>
							<td>#sms_reportstatus#</td>
							<td>#sms_points#</td>
						</tr>
						<tr class="details">
							<td colspan="6">
								<div class="inner_details">
									<p>
										<span class="head">Nadawca:</span> <span class="body">#sms_from#</span>
										<span class="head">ID wiadomości:</span> <span class="body">#sms_id#</span><br />
										
										<span class="head">Sklep:</span> <span class="body">#store#</span>
										<span class="head">Status:</span> <span class="body">#status# (0 - odebrany, 1,2 - wysłany)</span><br />
										
										<span class="head">Wiadomość:</span> <span class="body">#sms_text#</span>
										<span class="head">Raport:</span> <span class="body">#sms_reportstatus# (#sms_err#)</span><br />
										
										<span class="head">Data:</span> <span class="body">#sms_date#</span>
										<span class="head">Data raportu:</span> <span class="body">#report_date#</span><br />
										
										<span class="head"></span> <span class="body"></span>
										<span class="head">Punkty:</span> <span class="body">#sms_points#</span><br />
									</p>
								</div>
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
		</div>
		
	</div>
	
</cfoutput>
<!--- <cfdump var="#sms#"> --->