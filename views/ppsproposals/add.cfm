<cfoutput>
	
	<div class="wrapper proposalpps">
	
		<h3>Nowy wniosek</h3>
			
		<div class="wrapper proposalform">
			<h5>Formularz</h5>
				
			#startFormTag(action="add",multipart="true",id="create_proposalpps_form")#
				<!---#hiddenFieldTag(name="student[recruitmentstatusid]", value="0")#--->
				
				<ol class="proposalfields">
					
					<li>
						#textFieldTag(name="proposal[projekt]", label="Projekt", labelPlacement="before", class="input required")#
					</li>
					<li>
						#textFieldTag(name="proposal[adress]", label="Adres sklepu", labelPlacement="before", class="input required", disabled="true")#
					</li>
					<li>
						#textFieldTag(name="proposal[kos]", label="Imię i nazwisko KOS", labelPlacement="before", class="input required", disabled="true")#
					</li>
					<li>
						#selectTag(name="proposal[reasonid]", options=reasons, includeBlank="-- wybierz --", label="Powód wymiany PPS", labelPlacement="before", class="selecttag required")#
					</li>
					<li>
						#textAreaTag(name="proposal[reason]", label="Inny powód wymiany PPS (opcjonalnie)", labelPlacement="before", class="textarea")#
					</li>
					<li>
						#selectTag(name="proposal[methodid]", options=methods, includeBlank="-- wybierz --", label="Sposób rozwiązania umowy", labelPlacement="before", class="selecttag required")#
					</li>
					<li>
						#textFieldTag(name="proposal[changedate]", label="Planowany termin wymiany PPS", labelPlacement="before", class="input date_picker required")#
					</li>
					<li>
						#selectTag(name="proposal[directorid]", options=directors, includeBlank="-- wybierz --", label="Dyrektor regionalny", labelPlacement="before", class="selecttag required")#
					</li>
				</ol>
				
			#endFormTag()#
			
				<ol>
					<li>
						#submitTag(value="Zapisz",class="smallButton redSmallButton submitbutton")#
					</li>
				</ol>
				
		</div>
	</div> 
</cfoutput>
<script>
	$(function(){
		
		$(".submitbutton").on("click", function( event ){
			var error = '';
			//$('.required').tooltip( "disable" );
			
			$('.required').each(function(i, element) {
				
				if( ($(this).hasClass("input") && $(this).val().trim() == '') || ($(this).hasClass("selecttag") && $(this).val() == '') ){
					
					//$(this).after($("<span>").addClass("errorTooltip").html("&raquo; Pole wymagane"));
					error = "<div>Pola oznaczone gwiazdką są wymagane.</div>";
				}
				
				//var toAppend = "<span class=\"requiredfield\"> *</span>";
				//$(this).parent().find('label').append(toAppend);
			});
			
			if($("#proposal-adress").val() == '' || $("#proposal-adress").val() == ''){
				error += "<div>Wpisz i wybierz prawidłowy numer projektu aby wysłać wniosek.</div>";
			}
			
			if($("#proposal-reasonid").val() == 10 && $("#proposal-reason").val().trim() == '') {
				error += "<div>Podaj inny powód wymiany PPS</div>"; 
			}
			
			//event.preventDefault();
			if(error!='') {
				console.log(error);
				$(".error").remove();
				$("#create_proposalpps_form").before(
					$("<div>").hide().addClass("error").html(error).fadeIn("slow"));
				
			} else {
				$(".error").remove();
				$("#create_proposalpps_form").submit();
			}
		});
		
		var t_timeout;
		var _options = {
			source	: 
				function( request, response ) {
					clearTimeout(t_timeout);
					$("#flashMessages").show();
					
					t_timeout = setTimeout(function() {
						$.ajax({
							url			: <cfoutput>"#URLFor(action='find-stores')#"</cfoutput>,
							type		: "get",
							dataType	: "json",
							data		: { 
								q: request.term
							},
							success		: function( data ) {
								console.log(data);
								$("#flashMessages").hide();
								response( $.map( data.DATA, function( item ) {
									return {
										label: item[2] + ", " + item[4],
										value: item[2],
										projekt: item[2],
										adress: item[4],
										kos: item[44]
									}
								}));
							},
							error: function(){
								$("#flashMessages").hide();
								alert("Błąd wyszukiwania. Spróbuj ponownie później.");
							}
						});
					}, 500);
				}
			,minLength: 3
			,select: function( event,ui ) {
				console.log(ui.item);
				$("#proposal-adress").val(ui.item.adress);
				$("#proposal-kos").val(ui.item.kos);
			}
		};
		
		$("#proposal-projekt").autocomplete(_options);
		
		$('.required').each(function(i, element) {
			var toAppend = "<span class=\"requiredfield\"> *</span>";
			$(this).parent().find('label').append(toAppend);
		});
	});
</script>