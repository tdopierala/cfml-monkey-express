<cfoutput>
	<div class="concession-biling">
		
		#startFormTag(action="save-document", id="document-form")#
			
			#hiddenFieldTag(name="document[id]", value=document.id)#
			#hiddenFieldTag(name="document[type]", value=document.type)#
			#hiddenFieldTag(name="document[proposalurl]", value=URLFor(controller="Concessions", action="edit-proposal", key=document.proposalid))#
			
			<p class="document-header">Załącznik nr 2 do Instrukcji nr 3/2012/DF</p>
			<br />
			<p class="document-header">Poznań, dnia #DateFormat(document.created,"dd-mm-yyyy")# r.</p>
			<br />
			<h4>Naliczenie opłat (wymiar opłat) w roku #textFieldTag(name=attributes[39].id, value=attributes[39].value, class="text year")# za korzystanie z zezwoleń na sprzedaż napojów alkoholowych.</h4>
		
		
			<table class="concession-biling-table">
				<caption align="top">Wartość sprzedaży napojów alkoholowych w <span class="prev_year">...</span> r.</caption>
				<thead>
					<tr>
						<th>Określenie zezwolenia</th>
						<th>Wartość sprzedaży *</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="label">Zezwolenie A<br /> (dla piwa)</td>
						<td class="value">#textFieldTag(name=attributes[19].id, value=attributes[19].value, class="text prepayment")#</td>
					</tr>
					<tr>
						<td class="label">Zezwolenie B<br /> (dla wina)</td>
						<td class="value">#textFieldTag(name=attributes[20].id, value=attributes[20].value, class="text prepayment")#</td>
					</tr>
					<tr>
						<td class="label">Zezwolenie C<br /> (dla wódki)</td>
						<td class="value">#textFieldTag(name=attributes[21].id, value=attributes[21].value, class="text prepayment")#</td>
					</tr>
				</tbody>
			</table>
		
			<p>*) W przypadku, kiedy sklep nie prowadził sprzedaży alkoholu w <span class="prev_year">...</span> r. należy wpisać liczbę „0” (słownie: zero).</p>
		
			<table class="concession-biling-table">
				<caption align="top">Wartość naliczonych opłat dla poszczególnych zezwoleń na sprzedaż napojów alkoholowych.</caption>
				<thead>
					<tr>
						<th rowspan="2">Określenie zezwolenia</th>
						<th colspan="2">Opłata dotyczy okresu</th>
						<th rowspan="2">Wartość opłaty</th>
					</tr>
					<tr>
						<th>od</th>
						<th>do</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="label">Zezwolenie A<br /> (dla piwa)</td>
						<td>#textFieldTag(name=attributes[22].id, value=attributes[22].value, class="text date_picker")#</td>
						<td>#textFieldTag(name=attributes[23].id, value=attributes[23].value, class="text date_picker")#</td>
						<td class="value">#textFieldTag(name=attributes[28].id, value=attributes[28].value, class="text payment")#</td>
					</tr>
					<tr>
						<td class="label">Zezwolenie B<br /> (dla wina)</td>
						<td>#textFieldTag(name=attributes[24].id, value=attributes[24].value, class="text date_picker")#</td>
						<td>#textFieldTag(name=attributes[25].id, value=attributes[25].value, class="text date_picker")#</td>
						<td class="value">#textFieldTag(name=attributes[29].id, value=attributes[29].value, class="text payment")#</td>
					</tr>
					<tr>
						<td class="label">Zezwolenie C<br /> (dla wódki)</td>
						<td>#textFieldTag(name=attributes[26].id, value=attributes[26].value, class="text date_picker")#</td>
						<td>#textFieldTag(name=attributes[27].id, value=attributes[27].value, class="text date_picker")#</td>
						<td class="value">#textFieldTag(name=attributes[30].id, value=attributes[30].value, class="text payment")#</td>
					</tr>
					<tr>
						<th colspan="3">Razem</th>
						<td class="payment_sum">#textFieldTag(name=attributes[40].id, value=attributes[40].value, class="text summary")#</td>
					</tr>
				</tbody>
			</table>
			
			<div class="wrapper">
				Opłaty wnoszone są:<br />
				#selectTag(name=attributes[41].id, options=attributeoptions, selected=attributes[41].value, includeBlank=true)#
			</div>
			<div class="wrapper">
				Niniejszym oświadczam, że wypełniony druk naliczenia opłat (wymiar opłat) w roku <span class="present_year">...</span> za korzystanie z zezwoleń 
			na sprzedaż napojów alkoholowych przedkładam w związku z nieotrzymaniem właściwego dokumentu z Urzędu Gminy oraz, że 
			dane w nim zawarte są prawdziwe.
			</div>
			
		#endFormTag()#
	</div>
</cfoutput>
<script>
	
	$(function(){
		
		$('#document-form').ajaxForm({
			dataType	: 'json',
			type		: 'post',
			success: function (responseText, statusText, xhr, $form){
								
				$.get(<cfoutput>"#URLFor(controller='Concessions', action='view-document', key=document.id, params='mod=true')#"</cfoutput>,
					function() {
						
						$("#flashMessages").hide();
						document.location = $("#document-proposalurl").val();
						
					}
				);
			}
		});
		
		$(".payment").on("focusout", function(){
			
			var sumary = 0;
			$(".payment").each(function(){
				
				var $this = $(this);
				var val = $this.val();
				
				if(val != ''){
					var n = val.length;
					if(val.slice(-3) == " zł")
						val = val.substr(0,n-3);
					
					sumary += parseInt(val);
					
					$this.val(val + " zł");
				}	
			});
			
			$(".summary").val(sumary + " zł");
		});
		
		$(".payment").on("focusin", function(){
			
			var val = $(this).val();
			
			if(val.slice(-3) == " zł")
				$(this).val(val.substr(0,val.length-3));
		});
		
		$(".year").on("focusout", function(){
			var _this = $(this).val();
			
			if(_this != '' && _this != 0){
				$(".present_year").text(_this);
				$(".prev_year").text(parseInt(_this) - 1);
			}
		});
		
		if($(".year").val() != '' && $(".year").val() != 0){
			$(".present_year").text($(".year").val());
			$(".prev_year").text(parseInt($(".year").val()) - 1);
		}
		
		$(".prepayment").on("focusin", function(){
			
			var val = $(this).val();
			
			if(val.slice(-3) == " zł")
				$(this).val(val.substr(0,val.length-3));
		});
		
		$(".prepayment").on("focusout", function(){
			
			var val = $(this).val();
				
			if(val != '' && val.slice(-3) != " zł")
				$(this).val(val + " zł");
		});
		
	});
</script>