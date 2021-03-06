<cfoutput>
	
	<div class="wrapper polls">
		<h3>Ankieta - papierosy, wyniki wg sklepu</h3>
		
		<ul class="intranet-tab-index">
			<li>
				<cfoutput>#linkTo(text="Wyniki wg indeksu", action="cigarettesresultcount", class="")#</cfoutput>
			</li>
			<li class="chosen">
				<cfoutput>#linkTo(text="Wyniki wg sklepu", action="cigarettesresult", class="")#</cfoutput>
			</li>
		</ul>
		
		<div class="wrapper">
			
				<!---<form method="post" action="#URLFor(action='cigarettesAction')#">--->
					
					<table class="pollTable">
						<thead>
							<tr>
								<th class="btop bleft"></th>
								<th class="btop">Imię i nazwisko</th>
								<!---<th class="btop"></th>--->
							</tr>
						</thead>
						<tbody>
							<cfloop query="stores">
								<tr>
									<td class="bleft center extend-table" data-userid="#userid#">
										#imageTag("extend-table.png")#
									</td>
									<td>#login#, #givenname# #sn#</td>
									<!---<td></td>--->
								</tr>
							</cfloop>
							
						</tbody>
					</table>
					
				<!---</form>--->

		</div>
	</div>
	
</cfoutput>
<!---<cfdump var="#cigarette#" />--->
<script>
	$(function(){
		
		$(".extend-table").on("click", function(){
			
			if($(this).hasClass("extended")){
				
				$(this).removeClass("extended");
				$(this).closest("tr").next("tr").remove();
				
				var src = $(this).children("img").attr("src");
				$(this).children("img").attr("src", src.replace("collapse-table.png", "extend-table.png"));
				
			} else {
				
				var $this = $(this).closest("tr");
				var _key = $(this).closest("td").data("userid");
				
				$("#flashMessages").show();
				
				$.ajax({
					url: <cfoutput>"#URLFor(action='cigarettes-details')#"</cfoutput>,
					data: { key: _key },
					dataType: 'html',
					success: function( data ){
						
						$this.after(
							$("<tr>")
								.append(
									$("<td>").addClass("bleft"))
								.append(
									$("<td>").html( data )));
						
						$this.find(".extend-table").addClass("extended");
						
						var src = $this.find(".extend-table").children("img").attr("src");
						$this.find(".extend-table").children("img").attr("src", src.replace("extend-table.png", "collapse-table.png"));
						
						$("#flashMessages").hide();
						
					},
					error: function(){
						alert("Błąd pobierania danych!");
						$("#flashMessages").hide();
					}
				});
				
			}
			
		});
	});
</script>