<cfoutput>

	<div class="wrapper concessions">
		
		<h3>Formularz koncesyjny</h3>
		
			<div class="wrapper formbox concession-attributes">
				<h4>Sklep</h4>
				
				<ol>
					<li class="formelement">
						#textFieldTag(name="concession_store", label="Nr sklepu", labelPlacement="before", class="input", placeholder="wpisz nr sklepu")#
					</li>
				</ol>
			</div>
			
			<div class="wrapper formbox concession-attributes" id="concession-details">
				<h4>Polecenie zapłaty</h4>
				
				<div class="errorr" style="display:none;"></div>
				
				#startFormTag(action="createAction", id="create-concession-from")#
					
					#hiddenFieldTag(name="concession_projekt", value="")#
					#hiddenFieldTag(name="concession_storeid", value="")#
					#hiddenFieldTag(name="concession_file", value="")#
					
					<ol>
						<!---<li class="formelement">
							#textFieldTag(name="concession_typeid", label="Typ koncesji", labelPlacement="before", class="input")#
						</li>--->
						<li class="formelement">
							#textFieldTag(name="concession_nrb", label="Nr konta bankowego", labelPlacement="before", class="input nrb")#
						</li>
						
						<li class="formelement">
							#textFieldTag(name="concession_adress", label="Adres urzędu", labelPlacement="before", class="input")#
						</li>
						
						<li class="formelement">
							#textFieldTag(name="concession_brutto", label="Kwota brutto", labelPlacement="before", class="input currency")#
						</li>
						
						<li class="formelement">
							#textFieldTag(name="concession_description", label="Opis/tytułm", labelPlacement="before", class="input")#
						</li>
					</ol>
				
				#endFormTag()#
				
				<ol >
					<li class="formelement">
						<label>Dodaj skan dokumentu<br />(<span style="color:red">opcjonalnie!</span>)</label>
						
						<cfform 
							action="#URLFor(controller='concessions',action='uploadFile')#" 
							id="fileuploadform" 
							method="post">
							
							<fieldset class="invoiceForm">
								<div class="_button" style="float:left;">Wybierz plik
									<cfinput 
										name="filedata" 
										type="file"
										class="documentinstancecontent input_file"
										size="1" />
								
								</div>
								
								<div id="fileprogressbar" class="progressbar"></div>
							</fieldset>
						
						</cfform>
						<span style="color:red;font-style:italic;">Proszę nie załączać pustych plików nie będących poleceniem zapłaty!</span>
					</li>
				</ol>

			</div>
			
			<div class="wrapper formbox">
				
				#submitTag(value="Wyślij",class="smallButton redSmallButton confirmButton")#
				
			</div>
		
	</div>
	
</cfoutput>
<script>
	$(function(){
		
		if( $("#concession_store").val() == '')
			$("#concession-details").find("input").prop('disabled', true);
		
		var t_timeout;
		var _options = {
			source	: 
				function( request, response ) {
					clearTimeout(t_timeout);
					$("#flashMessages").show();
					
					t_timeout = setTimeout(function() {
								
						$.ajax({
							url			: <cfoutput>"#URLFor(controller='Concessions',action='storesearch')#"</cfoutput> + "&q=" + request.term,
							type		: "get",
							dataType	: "json",
							success		: function( data ) {
								
								$("#flashMessages").hide();
								
								response( $.map( data.DATA, function( item ) {
									
									return {
										label: item[1] + ", " + item[4] + " (" + item[3] + ")",
										value: item[1],
										id: item[0]
									}
								}));
							},
							error: function(){
								
								alert("Błąd wyszukiwania. Spróbuj ponownie później.");
							}
						});
						
					}, 500);
				}
			,minLength: 2
			,select: function( event, ui ) {
				
				if (ui.item.value != '') {
					$("#concession_projekt").val(ui.item.value);
					$("#concession_storeid").val(ui.item.id);
					$("#concession-details").find("input").prop('disabled', false);
					$("#concession_store").prop('disabled', true);
					
					$("#concession_store").removeClass("input_error");
					$("#concession_store").parent().find(".msg").remove();
				}
			}
		};
		
		$("#concession_store").autocomplete(_options);
		
		$("#concession_store").on("focusout", function(){
			
			$this = $(this);
			
			console.log($this.val().length);
			
			if( $this.prop("disabled") == false && $this.val().length >= 3){
				
				$("#flashMessages").show();
				$.ajax({
					url			: <cfoutput>"#URLFor(controller='Concessions',action='storesearch')#"</cfoutput> + "&q=" + $this.val(),
					type		: "get",
					dataType	: "json",
					success: function(data){
					
						$("#flashMessages").hide();
						
						$("#concession_projekt").val( data.DATA[0][1] );
						$("#concession_storeid").val( data.DATA[0][0] );
						$("#concession_store").val( data.DATA[0][1] );
						
						$("#concession-details").find("input").prop('disabled', false);
						$("#concession_store").prop('disabled', true);
						
						$("#concession_store").removeClass("input_error");
						$("#concession_store").parent().find(".msg").remove();
						
					}
				});			
			}
		});
		
		$("#concession_store").on("dblclick", function(){
			
			alert('dblclick');
			$("#concession_projekt").val('');
			$("#concession_storeid").val('');
			$("#concession_store").val('');
						
			$("#concession-details").find("input").prop('disabled', true);
			$("#concession_store").prop('disabled', false);
						
			//$("#concession_store").removeClass("input_error");
			//$("#concession_store").parent().find(".msg").remove();
		});
		
		$(".input").on("focusout", function(){
			
			var $this = $(this);
			
			$this.css("margin-right", "10px");
			
			if( $this.val() == '' ){
				
				$this.removeClass("input_ok").addClass("input_error");
				$this.parent().find(".msg").remove();
				$this.after(
					$("<span>").addClass("msg msgerr").html("&laquo; Pole wymagane!")
				);
				
			} else {
				
				if( $this.hasClass("nrb") ){
				
					if( !checkNRB( $this.val() ) ){
					
						$this.removeClass("input_ok").addClass("input_error");
						$this.parent().find(".msg").remove();
						$this.after(
							$("<span>").addClass("msg msgerr").html("&laquo; Numer rachunku jest błędny.")
						);
						
					} else {
						
						$this.removeClass("input_error").addClass("input_ok");
						$this.parent().find(".msg").remove();
						$this.after(
							$("<img>").addClass("msg").attr("src","/intranet/images/yes.png").attr("alt","ok")
						);
					}
				
				} else if( $this.hasClass("currency") ){
					
					var value = $this.val();
					var reg = /^\d+((\.|,)\d{2})?$/;
					
					if(!reg.test(value)){
						$this.removeClass("input_ok").addClass("input_error");
						$this.parent().find(".msg").remove();
						$this.after(
							$("<span>").addClass("msg msgerr").html("&laquo; Kwota jest błędna.")
						);
					} else {
						
						$this.removeClass("input_error").addClass("input_ok");
						$this.parent().find(".msg").remove();
						$this.after(
							$("<img>").addClass("msg").attr("src","/intranet/images/yes.png").attr("alt","ok")
						);
					}
					
				} else {
					
					$this.removeClass("input_error").addClass("input_ok");
					$this.parent().find(".msg").remove();
					$this.after(
						$("<img>").addClass("msg").attr("src","/intranet/images/yes.png").attr("alt","ok")
					);
				}
			}
		});
		
		var timebox, time=0, projekt;
	
		function progress(obj){
			time += 5;			
			if( time < 90 ){ obj.progressbar( "option", "value", time ); } 
			else { obj.progressbar( "option", "value", false ); clearInterval(timebox); }
		}
		
		$(".progressbar").progressbar({ value: 0 });
		
		$(".documentinstancecontent").on("change", function(){
			
			projekt = $("#concession_store").val();
			
			var ajaxFormOptions = {
			
				dataType	: 'json',
				type		: 'post',
				url			: <cfoutput>"#URLFor(controller='Concessions',action='uploadFile')#"</cfoutput> + "&projekt=" + projekt,
				/*data		: { projekt: key },*/
				
				beforeSubmit: function(arr, $form, options){
					
					//loc = $("#concession_store").val();
					//console.log(loc);
					
					$("#fileprogressbar").show();
					timebox = setInterval( function(){ 
						progress( $("#fileprogressbar") ); 
					} ,100);
				},
				
				success: function (response, statusText, xhr, $form){
					
					clearInterval(timebox);
					$("#fileprogressbar").progressbar( "option", "value", 100 );
					
					$("#fileuploadform").find(".msg").remove();
					
					var $name = $("<li>: "+ response.CFILENAME +"</strong></li>");
					//var $date = $("<p>Utworzony: "+ response.CREATEDATE +" r.</p>");
					
					var ext = response.SFILENAME.split(".");
					ext = ext[1];
					
					switch(ext){
						case 'pdf': src = 'file-pdf.png'; break;
						case 'jpg': src = 'file-img.png'; break;
						case 'png': src = 'file-img.png'; break;
					}
					
					$("#concession_file").val(response.SFILENAME);
					
					$("#concession-details").find("ol:first")
						.append(
							$("<li>").addClass("formelement")
								.append(
									$("<label>").text("Załącznik (skan dokumentu)"))
								.append(
									$("<span>")
										.append(
											$("<img>")
												.attr("src", "images/"+src)
												.attr("alt", ext))
										.append(
											$("<a>")
												.attr("href", "files/folders/" + response.SFILENAME)
												.attr("title", "Pobierz plik")
												.attr("target", "_blank")
												.text(response.CFILENAME + "." + ext))));
							
					
					$("#fileprogressbar").slideUp();
					
				},
				
				error: function(xhr, status, error){
					
					console.log(xhr);
					console.log(status);
					console.log(error);
					alert("Wystąpił błąd! Nie udało się załadować pliku. Spróbuj ponownie później.");
					
				}
				
			};
			
			$('#fileuploadform').ajaxForm(ajaxFormOptions);
			
			time=0;
			
			$("#fileprogressbar").progressbar({ value: 0 });
			
			var ext = $(this).val().split(".");
			
			if( ext[ ext.length - 1 ].toLowerCase() == 'jpg' || ext[ ext.length - 1 ].toLowerCase() == 'png' || ext[ ext.length - 1 ].toLowerCase() == 'pdf')
				$("#fileuploadform").submit();
			else
				alert('Nieprawidłowy format pliku! Akceptowane formaty plik .jpg, .png, .pdf');
		
		});
		
		$(".confirmButton").on("click", function(){
						
			var $store = $("#concession_store");
			if( $store.val() == ''){
				
				$store.removeClass("input_ok").addClass("input_error");
				$store.parent().find(".msg").remove();
				
				$store.after(
					$("<span>").addClass("msg").html("<strong>&laquo;</strong> Wpisz i wybierz najpierw sklep."));
			}
			
			else
			
			$("#create-concession-from").find("input").each(function(idx){
				
				var $this = $(this);
				var $error = $(".errorr");
				
				$this.css("margin-right", "10px");
				$this.removeClass("input_ok").removeClass("input_error");
				
				if( $this.hasClass("nrb") && !checkNRB( $this.val() )){
						
					$this.addClass("input_error").after(
						$("<span>").addClass("msg msgerr").html("<strong>&laquo;</strong> Numer rachunku jest błędny."));
				}
				
				else
				
				if( $this.val() == '' ){
					
					$this.addClass("input_error").parent().find(".msgerr").remove();
				
					switch($this.attr("id")){
						
						/*case "concession_file": 
							
							$(".input_file").closest("._button").parent().find(".msg").remove();
							$(".input_file").closest("._button").after(
								$("<span>").addClass("msg msgerr").html("&laquo; Załącz plik z dokumentem."));							 
						break;*/
						
						case "concession_nrb": 
							
							$this.after(
								$("<span>").addClass("msg msgerr").html("<strong>&laquo;</strong> Uzupełnij prawidłowy numer rachunku bankowego."));
						break;
						case "concession_brutto": 
							
							$this.after(
								$("<span>").addClass("msg msgerr").html("<strong>&laquo;</strong> Kwota brutto jest polem wymaganym."));
						break;
						case "concession_description": 
							
							$this.after(
								$("<span>").addClass("msg msgerr").html("<strong>&laquo;</strong> Opis przelewu jest polem wymaganym."));
						break;
						case "concession_adress":
							
							$this.after(
								$("<span>").addClass("msg msgerr").html("<strong>&laquo;</strong> Wpisz adres urzędu."));
						break;
					}
					
				} else {
					
					$this.removeClass("input_error").addClass("input_ok");
				}

			});
			
			if( $(".concessions").find(".msgerr").length == 0) {
				$("#create-concession-from").submit();
				console.log("formularz wysłano");
			}
			else {
				console.log("formularz błędny");
				console.log($(".concessions").find(".msgerr").length);
				console.log($(".concessions").find(".msgerr"));
			}
		});
	});
</script>