<cfoutput>
	<div class="concession-proposal">
		
		#startFormTag(action="save-document", id="document-form")#
			
			#hiddenFieldTag(name="document[id]", value=document.id)#
			#hiddenFieldTag(name="document[type]", value=document.type)#
			#hiddenFieldTag(name="document[proposalurl]", value=URLFor(controller="Concessions", action="edit-proposal", key=document.proposalid))#
			
			<p class="document-header">Załącznik nr 1 do Instrukcji nr 3/2012/DF</p>
			<br />
			<h4>WNIOSEK O REFUNDACJĘ OPŁAT</h4>
			<br />
			<p>Na podstawie Instrukcji nr 3/2012/DF w sprawie zasad refundacji kosztów opłat za korzystanie przez Partnera Prowadzącego Sklep z 
			zezwoleń na sprzedaż napojów alkoholowych w roku 
				#textFieldTag(
					name=attributes[38].id,
					value=attributes[38].value,
					class="text year")#
			, wnoszę o przyznanie refundacji.</p>
			
			<p><strong>Data rozpoczęcia sprzedaży napojów alkoholowych <!---w roku 2012 --->- </strong> 
											#textFieldTag(
												name=attributes[36].id,
												value=attributes[36].value,
												class="input date_picker")#</p>
			
			<p>
				Do wniosku:
				<ul>
					<li>
						<cfif attributes[16].value eq 1>
							<cfset checked = "true" />
							<cfset class = "default" />
						<cfelseif attributes[16].value eq 2>
							<cfset checked = "false" />
							<cfset class = "unnecessary" />
						<cfelse>
							<cfset checked = "false" />
							<cfset class = "default" />
						</cfif>
						
						#radioButtonTag(
							name=attributes[16].id,
							value="1", 
							checked=checked,
							label="dołączam oryginał ważnego zezwolenia na sprzedaż napojów alkoholowych (kopię zezwolenia poświadczoną notarialnie pozostawiam u siebie);",
							labelPlacement="after",
							class="radio attribute attribute16 #class#"
						)#
						<br />
						<strong>lub</strong><br /><br />
						
						<cfif attributes[16].value eq 2>
							<cfset checked = "true" />
							<cfset class = "default" />
						<cfelseif attributes[16].value eq 1>
							<cfset checked = "false" />
							<cfset class = "unnecessary" />
						<cfelse>
							<cfset checked = "false" />
							<cfset class = "default" />
						</cfif>
						
						#radioButtonTag(
							name=attributes[16].id, 
							value="2", 
							checked=checked,
							label="informuję, że oryginał ważnego zezwolenia na sprzedaż napojów alkoholowych w roku #attributes[38].value# Przekazałem wcześniej do Monkey Group (kopię zezwolenia poświadczoną notarialnie mam pozostawioną u siebie).*",
							labelPlacement="after",
							class="radio attribute attribute16 #class#"
						)#
						<br />
						oraz
					</li>
					<li>
						<cfif attributes[17].value eq 1>
							<cfset checked = "true" />
							<cfset class = "default" />
						<cfelseif attributes[17].value eq 2>
							<cfset checked = "false" />
							<cfset class = "unnecessary" />
						<cfelse>
							<cfset checked = "false" />
							<cfset class = "default" />
						</cfif>
						
						#radioButtonTag(
							name=attributes[17].id, 
							value="1", 
							checked=checked,
							label="dołączam pisemne oświadczenie o rezygnacji z działalności dotyczącej handlu napojami alkoholowymi w sklepie Monkey Express w chwili wygaśnięcia lub rozwiązania Umowy o Współdziałaniu i Współpracy ze Spółką Monkey Group;",
							labelPlacement="after",
							class="radio attribute attribute17 #class#"
						)#
						<br />
						<strong>lub</strong><br /><br />
						
						<cfif attributes[17].value eq 2>
							<cfset checked = "true" />
							<cfset class = "default" />
						<cfelseif attributes[17].value eq 1>
							<cfset checked = "false" />
							<cfset class = "unnecessary" />
						<cfelse>
							<cfset checked = "false" />
							<cfset class = "default" />
						</cfif>
						
						#radioButtonTag(
							name=attributes[17].id, 
							value="2", 
							checked=checked,
							label="informuję, że oświadczenie o rezygnacji z działalności dotyczącej handlu napojami alkoholowymi w sklepie Monkey Express w chwili wygaśnięcia Umowy o Współdziałaniu i Współpracy z Spółką Monkey Group przekazałem/am wcześniej do Monkey Group*",
							labelPlacement="after",
							class="radio attribute attribute17 #class#"
						)#
						<br />			
						oraz
					</li>
					<li>
						<cfif attributes[18].value eq 1>
							<cfset checked = "true" />
							<cfset class = "default" />
						<cfelseif attributes[18].value eq 2>
							<cfset checked = "false" />
							<cfset class = "unnecessary" />
						<cfelse>
							<cfset checked = "false" />
							<cfset class = "default" />
						</cfif>
						
						#radioButtonTag(
							name=attributes[18].id, 
							value="1", 
							checked=checked,
							label="dołączam kopię dokumentu wystawionego przez Urząd Gminy potwierdzającego naliczenie opłaty (wymiar opłaty) za korzystanie z zezwoleń na sprzedaż napojów alkoholowych;",
							labelPlacement="after",
							class="radio attribute attribute18 #class#"
						)#
						<br />
						<strong>lub</strong><br /><br />
						
						<cfif attributes[18].value eq 2>
							<cfset checked = "true" />
							<cfset class = "default" />
						<cfelseif attributes[18].value eq 1>
							<cfset checked = "false" />
							<cfset class = "unnecessary" />
						<cfelse>
							<cfset checked = "false" />
							<cfset class = "default" />
						</cfif>
						
						#radioButtonTag(
							name=attributes[18].id, 
							value="2", 
							checked=checked,
							label="w związku z brakiem dokumentu z Urzędu Gminy, dołączam wypełniony przeze mnie druk (załącznik nr 2 do w/w Instrukcji) wskazujący naliczanie opłat (wymiar opłat) za korzystanie z zezwoleń na sprzedaż napojów alkoholowych.*",
							labelPlacement="after",
							class="radio attribute attribute18 #class#"
						)#
						<br />
					</li>
				</ul>
				<span>* niewłaściwe skreślić</span>
			</p>
			
			<table class="concession-proposal-table">
				<thead>
					<tr>
						<th colspan="2">Wnioskodawca</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>Sklep numer</td>
						<td>#textFieldTag(
							name=attributes[10].id,
							value=attributes[10].value,
							class="text"
						)#</td>
					</tr>
					<tr>
						<td>Imie i nazwisko</td>
						<td>#textFieldTag(
							name=attributes[11].id,
							value=attributes[11].value,
							class="text"
						)#</td>
					</tr>
					<tr>
						<td>Nazwa przedsiebiorstwa PPS</td>
						<td>#textFieldTag(
							name=attributes[12].id,
							value=attributes[12].value,
							class="text"
						)#</td>
					</tr>
					<tr>
						<td>NIP przedsiebiorstwa PPS</td>
						<td>#textFieldTag(
							name=attributes[13].id,
							value=attributes[13].value,
							class="text attribute13"
						)#</td>
					</tr>
					<tr>
						<td>Adres przedsiebiorstwa PPS</td>
						<td>#textAreaTag(
							name=attributes[14].id,
							content=attributes[14].value,
							class="text"
						)#</td>
					</tr>
					<tr>
						<td>Adres do korespondencji<br /> (jeśli inny niż powyższy)</td>
						<td>#textAreaTag(
							name=attributes[15].id,
							content=attributes[15].value,
							class="text"
						)#</td>
					</tr>
				</tbody>
			</table>
		#endFormTag()#
	</div>
</cfoutput>
<script>
	function validateNIP(nip){
		//Check length
		if (nip == null)
			return false;
		
		nip = nip.replace(/\-/g, '');      
		if (nip.length != 10)
			return false;
 
		//Check digits
		for (i=0; i<10; i++)
			if (isNaN(nip[i]))
				return false;
 
		//Check checkdigit
		sum = 6 * nip[0] + 5 * nip[1] + 7 * nip[2] + 2 * nip[3] + 3 * nip[4] + 4 * nip[5] + 5 * nip[6] + 6 * nip[7] + 7 * nip[8]; 
		sum %= 11;
		
		if (nip[9] != sum)
			return false;
 
		return true;
	}
	
	$(function(){
		
		$(".attribute").parent().find("input.unnecessary").next("label").addClass("unnecessary");
		
				
		$(".attribute").on("click", function(){
			
			var _this = $(this).attr("id");
			
			if($(this).hasClass("attribute16")){
				
				$(".attribute16").each(function(){
				
					if($(this).attr("id") == _this)
						$(this).next().removeClass("unnecessary");
					else
						$(this).next().addClass("unnecessary");
				}); 
			}
			
			if($(this).hasClass("attribute17")){
				
				$(".attribute17").each(function(){
				
					if($(this).attr("id") == _this)
						$(this).next().removeClass("unnecessary");
					else
						$(this).next().addClass("unnecessary");
				}); 
			}
			
			if($(this).hasClass("attribute18")){
				
				$(".attribute18").each(function(){
				
					if($(this).attr("id") == _this)
						$(this).next().removeClass("unnecessary");
					else
						$(this).next().addClass("unnecessary");
				}); 
			}
		});
		
		if (validateNIP($(".attribute13").val()))
			$(".attribute13").css({"color": "#000000"});
		else
			$(".attribute13").css({"color": "#FF0000"});
		
		
		$(".attribute13").on("keyup", function(){
			if (validateNIP($(this).val()))
				$(this).css({"color": "#000000"});
			else
				$(this).css({"color": "#FF0000"});
		});
		
		$('#document-form').ajaxForm({
			dataType	: 'json',
			type		: 'post',
			beforeSubmit: function(arr, $form, options){
				/*
				var nip = $(".attribute13").val();
				
				if(validateNIP(nip))
					return true;
				else
					return false;
				*/
			},
			success: function (responseText, statusText, xhr, $form){
				
				$.get(<cfoutput>"#URLFor(controller='Concessions', action='view-document', key=document.id, params='mod=true')#"</cfoutput>,
					function() {
						
						$("#flashMessages").hide();
						document.location = $("#document-proposalurl").val();
						
					}
				);
			}
		});
	});
</script>