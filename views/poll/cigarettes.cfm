<cfoutput>
	
	<div class="wrapper polls">
		<h3>Ankieta - papierosy</h3>
		
		<div class="wrapper">
			
				<cfif count gt 0>
					<div class="poll-info">
						Twój wybór został już zapisany. Dziękujemy! 
					</div>
				</cfif>
				
				<form method="post" action="#URLFor(action='cigarettesAction')#">
					
					<table class="pollTable" data-poll="#count#">
						<thead>
							<tr>
								<th class="btop bleft">Index</th>
								<th class="btop">Nazwa</th>
								<th class="btop"></th>
							</tr>
						</thead>
						<tbody>
							<cfloop query="cigarettes">
								<tr>
									<td class="bleft">#SYMKAR#</td>
									<td>#OPIKAR1#</td>
									<td class="checkbox center">
										
										<cfif ArrayFind(cigtab, SYMKAR) gt 0>
											<input type="checkbox" class="symkar" name="symkar" value="#SYMKAR#" checked="checked" />
										<cfelse>
											<input type="checkbox" class="symkar" name="symkar" value="#SYMKAR#" />
										</cfif>
									</td>
								</tr>
							</cfloop>
							
						</tbody>
					</table>
					<div class="pollSubmit">
						#submitTag(value="Zapisz", class="formButton button redButton")#
					</div>
					
				</form>

		</div>
	</div>
	
</cfoutput>

<script>
	$(function(){
	
		if($(".pollTable").data("poll") > 0){
			$(".symkar").each(function(){
				$(this).attr("disabled", true);
			});
		}
		
		$(".pollTable tbody tr").on("mouseenter", function(){
			$(this).children("td").css("background-color", "#F5F5F5");
		});
		
		$(".pollTable tbody tr").on("mouseleave", function(){
			$(this).children("td").css("background-color", "#ffffff");
		});
		
		$(".pollTable tbody tr").on("click", function(){
			
			var $this = $(this).children(".checkbox").children(".symkar");
			
			selectCheckbox($this);
		});
		
		$(".symkar").on("click", function(){
			
			selectCheckbox($(this));
			//return false;
		});
		
		function selectCheckbox(obj){
			
			if($(".pollTable").data("poll") == 0){
				
				if(obj.prop("checked")){
					obj.prop("checked", false);
				} else {
					if(!obj.is(":disabled"))
						obj.prop("checked", true);
				}
			}
			
			var count = $(".symkar:checked").length;
			
			if(count>=20) {
				$(".symkar:not(:checked)").each(function(){
					$(this).attr("disabled", true);
				});
			} else {
				$(".symkar:disabled").each(function(){
					$(this).attr("disabled", false);
				});
			}
		}
	});
</script>