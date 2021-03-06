<div class="wrapper debtrate">
	
	<h3>Wskaźnik zadłużenia ajenta</h3>
		
		<div class="wrapper proposalform">
			<ol>
				<li>
					<label>Filtruj wg Sklepu:</label>
					<input type="text" name="sklep" id="sklep" value="" class="input_filter" />
				</li>
			</ol>
		</div>
		
	<div id="debtratio-table-box">
		
		<table class="tables debtrate-table">
			<thead>
				<th></th>
				<th>L.p.</th>
				<th><span>Nr sklepu</span></th>
				<th class="tright">Wartość faktur</th>
				<th class="tright">Wartość wpłat</th>
				<th class="tright">Różnica</th>
				<th class="tright">Starter</th>
				<th class="tright">Dopuszczalny</th>
				<th class="tright thsort"><span>Rzeczywisty</span></th>
			</thead>
			<tbody>
				
			</tbody>
		</table>
	
	</div>
	
</div>
<script>
	$(function(){
		
		$("#flashMessages").show();
		$.ajax({
			type: 'GET',
			url: '<cfoutput>#URLFor(controller="DebtRate", action="genereRatio")#</cfoutput>',
			dataType: "html",
			success: function(data, status, xhr){
					
				$("#debtratio-table-box").html(data);
				$("#flashMessages").hide();		

			},
			error: function(){
				alert("Pobranie danych nie powiodło się");
				$("#flashMessages").hide();
			}
		});
		
		var flag = true;
		$(".debtrate").on("click", ".ratio-expand", function(){
			
			$this = $(this);
			
			if ($this.hasClass("expanded")) {
				
				$this.removeClass("expanded").closest("tr").next().remove();
			}
			else {
			
				$("#flashMessages").show();
				
				if (flag) {
					
					flag=false;
					
					$.ajax({
						type: 'GET',
						url: '<cfoutput>#URLFor(controller="DebtRate", action="details2")#</cfoutput>' + '&logo=' + $this.closest("td").data("logo") + '&projekt=' + $this.closest("td").data("projekt"),
						dataType: "html",
						success: function(data, status, xhr){
						
							$this.closest("tr").after(
								$("<tr>")
									.addClass("trdetails")
									.append(
										$("<td>").addClass("details").attr("colspan", "11").html(data)));
							
							$this.addClass("expanded");
							$("#flashMessages").hide();
							flag=true;
						},
						error: function(){
							alert("Pobranie danych nie powiodło się");
							$("#flashMessages").hide();
							flag=true;
						}
					});
				}
				
			}
			
			return false;
			
		});
		
		$(".debtrate").on("click", ".navigate", function(){
			
			var url = $(this).attr("href");
			var container = $(this).data("container");
			
			$("#flashMessages").show();
			
			$.ajax({
				type	: 'GET',
				url		: url,
				dataType: "html",
				success	: function(data, status, xhr) {
						
					$(document).find("#"+container).html(data);
					$("#flashMessages").hide();
				}
			});
			
			return false;
		});
		
		var timebox;
		$("#sklep").on("keyup", function(){
			
			clearTimeout(timebox);
			
			$this = $(this);
			
			if($this.val().length >= 2 || $this.val().length == 0){
				
				timebox=setTimeout(function(){
					
					$.ajax({
						type	: 'GET',
						url		: '<cfoutput>#URLFor(controller="debt-rate", action="genere-ratio")#</cfoutput>' + "&page=1&orderby=sklep&order=asc" + "&projekt=" + $this.val(),
						dataType: "html",
						success	: function(data, status, xhr) {
								
							$(document).find("#debtratio-table-box").html(data);
							$("#flashMessages").hide();
						}
					});
					
				},500);
				
			}
			
		});
		
		var sortCheckboxFlag = true;
		$(document).on("click", ".sort-checkbox", function(){
			
			if (sortCheckboxFlag) {
				sortCheckboxFlag = false;
				
				var $this = $(this);
				
				var params = '';
				
				$this.closest(".details-table-sort").find(".sort-checkbox").attr("disabled", true);
				
				$this.closest(".details-table-sort").find(".sort-checkbox").each(function(idx){
				
					if ($(this).is(':checked')) {
						params += "&" + $(this).val();
					}
				});
				
				console.log(params);
				
				if (params == '') {
					
					sortCheckboxFlag = true;
					$this.closest(".details-table-sort").find(".sort-checkbox").attr("disabled", false);
					
				} else {
				
					$("#flashMessages").show();
					
					var $id = $(this).closest("tr").prev().children("td.tdbutton");
					
					$.ajax({
						type: 'GET',
						url: '<cfoutput>#URLFor(controller="DebtRate", action="details2")#</cfoutput>' + '&logo=' + $id.data("logo") + '&projekt=' + $id.data("projekt") + params,
						dataType: "html",
						success: function(data, status, xhr){
						
							$this.closest(".details").html(data);
							$("#flashMessages").hide();
							sortCheckboxFlag = true;
						},
						error: function(){
							alert("Pobranie danych nie powiodło się");
							$("#flashMessages").hide();
							sortCheckboxFlag = true;
						}
					});
				}
			}
		});
		
		var moreFlag = true;
		$(document).on("click", "#more_button", function(){
			
			$this = $(this);
			
			if (moreFlag) {
				moreFlag = false;
				$("#flashMessages").show();
				
				var $id = $(this).closest("tr.trdetails").prev().children("td.tdbutton");
				
				$.ajax({
					type: 'GET',
					url: '<cfoutput>#URLFor(controller="DebtRate", action="details2")#</cfoutput>' + '&logo=' + $id.data("logo") + '&projekt=' + $id.data("projekt") + "&full",
					dataType: "html",
					success: function(data, status, xhr){
					
						$this.closest("td.details").html(data);
						$("#flashMessages").hide();
						moreFlag = true;
					},
					error: function(){
						alert("Pobranie danych nie powiodło się");
						$("#flashMessages").hide();
						moreFlag = true;
					}
				});
			}
		});
	});
</script>
