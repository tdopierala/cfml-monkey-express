<cfoutput>
	
	<div class="wrapper concessions">
		
		<cfif flashKeyExists("message")>
	    	<span class="error">#flash("message")#</span>
		</cfif>
		
		<h3>Koncesje: #store.projekt# - #store.miasto#</h3>
		
		<div class="intranet-backlink">
			#linkTo(text="&laquo; Powrót do listy koncesji", controller="Concessions", action="index")#
		</div>
		
		<div class="wrapper formbox concession-attributes">
			
			<h5>Szczegóły sklepu</h5>
			
			<ol>
				<li>
					<label>Projekt</label> <span id="store-projekt">#store.projekt#</span>
				</li>
				<li>
					<label>PPS</label> <span>#store.nazwaajenta# (#store.ajent#)</span>
				</li>
				<li>
					<label>Lokalizacja</label> <span>#Trim(store.miasto)#, #Trim(store.ulica)#</span>
				</li>
			</ol>
		</div>
		
		<div class="wrapper formbox concession-attributes">
			
			<h5>Polecenie zapłaty do UM</h5>
			
			<ol>
				<li>
					<label>Data wpłynięcia</label> <span>#DateFormat(concession.createdate, "dd-mm-yyyy")#</span>
				</li>
				
				<cfloop query="attributes">
					
					<cfset class='' />
					
					<cfswitch expression="#attributeid#">
							
							<cfcase value="1">
								<li>
									<label>Nr rachunku</label> <span>#attributevalue#</span>
								</li>
							</cfcase>
							
							<cfcase value="2">
								<cfset _attributevalue = Replace(Trim(Replace(attributevalue, "zł", "")), ",", ".") />
								<li>
									<label>Kwota brutto</label> <span>#Replace(NumberFormat(_attributevalue, "__,___.__"), ",", " ", "ALL") & " zł"#</span>
								</li>
							</cfcase>
							
							<cfcase value="3">
								<li>
									<label>Opis/Tytułem</label> <span>#attributevalue#</span>
								</li>
							</cfcase>
							
							<cfcase value="4">
								<li>
									<label>Załącznik</label> 
									<cfif attributevalue neq ''>
										<span class="file">#attributevalue#</span>
									<cfelse>
										<span class="italic">brak</span>
									</cfif>
								</li>
							</cfcase>
							
							<cfcase value="7">
								<li>
									<label>Adres urzędu</label> <span>#attributevalue#</span>
								</li>
							</cfcase>
							
							<cfdefaultcase>
								<cfcontinue />
							</cfdefaultcase>
							
						</cfswitch>
					
				</cfloop>
				
			</ol>
		</div>
		
		<!---<cfswitch expression="#concession.statusid#">
			
			<cfcase value="1">--->
			
		<cfif concession.statusid gte 1>
		
				<div class="wrapper formbox concession-attributes">
				
					<h5>Potwierdzenie zapłaty</h5>
						
					<cfif concession.statusid eq 1>
						
						<cfif etap2 is true>
						
							<ol>
								<li class="formelement fileelement">
									<label>Dodaj skan dokumentu</label>
									
									<cfform 
										action="#URLFor(controller='concessions',action='uploadFile')#" 
										id="fileuploadform" 
										method="post">
											
										<fieldset class="invoiceForm">
											<div class="_button">Wybierz plik
												
												<cfinput type="hidden" name="attributeid" value="5" />
												
												<cfinput 
													name="filedata" 
													type="file"
													class="documentinstancecontent input_file"
													size="1" />
												
											</div>
												
											<div id="fileprogressbar" class="progressbar"></div>
										</fieldset>
										
									</cfform>
									
								</li>
							</ol>
							
							<!---<div>
									#submitTag(value="Wyślij",class="smallButton redSmallButton confirmButton")#
							</div>--->
							
						<cfelse>
							
							<ol>
								<li>
									<label>Plik z potwierdzeniem</label>
																	
									<span class="italic">oczekuje na zamieszczenie...</span>							
								</li>
							</ol>
						</cfif>
						
					<cfelse> 
						<ol>
							<li>
								<label>Plik z potwierdzeniem</label>
									
								<cfloop query="attributes">
						
									<cfswitch expression="#attributeid#">											
										<cfcase value="5">
											<span class="file">#attributevalue#</span>
										</cfcase>											
									</cfswitch>
									
								</cfloop>
							</li>
						</ol>
						<div class="info">
							<cfloop query="steps">
								<cfif stepid eq 2>
									<span>Dodany #DateFormat(stepdate, "dd-mm-yyyy")# #TimeFormat(stepdate, "HH:mm")# przez #givenname# #sn#</span>
								</cfif>
							</cfloop>
						</div>
					</cfif>
				
				</div>
				
		</cfif>
			<!---</cfcase>
			
		</cfswitch>--->
		
		<cfif concession.statusid gte 2>
			
			
			<cfif license.RecordCount gt 0 >
				
				<cfloop query="license">
					
					#includePartial("license")#
						
				</cfloop>
					
			</cfif>
			
			<cfif license.RecordCount lt 3 and etap3 is true>
			
				<div class="wrapper formbox concession-attributes">
				
					<h5>Formularz zezwoleń</h5>
							
					#startFormTag(action="update",id="updateConcession")#
								
						#hiddenFieldTag(name="concessionid", value=params.key)#
						#hiddenFieldTag(name="storeid", value=concession.storeid)#
						#hiddenFieldTag(name="concession_file", value=concession.storeid)#
								
						<ol>
							<li class="formelement">
								#textFieldTag(name="license_nr", label="Nr zezwolenia", labelPlacement="before", class="input")#
							</li>
							<li class="formelement">
								#selectTag(name="license_type", options=concessionType, includeBlank="-- wybierz --", label="Typ koncesji", labelPlacement="before", class="")#
							</li>
							<li class="formelement">
								#textFieldTag(name="license_issue", label="Data wydania", labelPlacement="before", class="input date_picker")#
							</li>
							<li class="formelement">
								#textFieldTag(name="license_issuedby", label="Wydane przez", labelPlacement="before", class="input")#
							</li>
							<li class="formelement">
								#textFieldTag(name="license_from", label="Data obowiązywania (od)", labelPlacement="before", class="input date_picker")#
							</li>
							<li class="formelement">
								#textFieldTag(name="license_to", label="Data obowiązywania (do)", labelPlacement="before", class="input date_picker")#
							</li>
						</ol>
					
					#endFormTag()#
							
						<ol>
							<li class="formelement fileelement">
								<label>Dodaj skan dokumentu</label>
									
								<cfform 
									action="#URLFor(controller='concessions',action='uploadFile')#" 
									id="fileuploadform" 
									method="post">
										
									<fieldset class="invoiceForm">
										<div class="_button">Wybierz plik
												
											<cfinput type="hidden" name="attributeid" value="6" />
												
											<cfinput 
												name="filedata" 
												type="file"
												class="documentinstancecontent input_file"
												size="1" />
												
										</div>
												
										<div id="fileprogressbar" class="progressbar"></div>
									</fieldset>
										
								</cfform>
									
							</li>
						</ol>
							
						<div>
							#submitTag(value="Zapisz",class="smallButton redSmallButton updateButton")#
						</div>
						
				</div>
			</cfif>
		</cfif>
		
	</div>
	
</cfoutput>
<script>
	$(function(){
		
		function filelink($this){
			
			var filename = $this.text();
		
			//var file_tmp = filename.split("_");
			var file_tmp = filename.substr(20);
			var file = file_tmp.split(".");
			var i = file.length;
			
			switch(file[i-1].toLowerCase()){
				case 'pdf': src = 'file-pdf.png'; break;
				case 'jpg': src = 'file-img.png'; break;
				case 'png': src = 'file-img.png'; break;
				default:	src = 'blank.png';
			}
			
			$this
				.empty()
				.append(
					$("<img>")
						.attr("src", "images/"+src)
						.attr("alt", file[1]))
				.append(
					$("<a>")
						.attr("href", "files/folders/" + filename)
						.attr("target", "_blank")
						.attr("title", "Pobierz plik")
						.text(file[0] + "." + file[1]));
		}
		
		$(".file").each(function( i ){
			
			filelink($(this));
		});
		
		var timebox, time=0;
	
		function progress(obj){
			time += 5;			
			if( time < 90 ){ obj.progressbar( "option", "value", time ); } 
			else { obj.progressbar( "option", "value", false ); clearInterval(timebox); }
		}
		
		$(".progressbar").progressbar({ value: 0 });
		
		$('#fileuploadform').ajaxForm({
			
			dataType	: 'json',
			type		: 'post',
			url			: <cfoutput>"#URLFor(controller='Concessions',action='uploadFile')#"</cfoutput>,
			data		: { projekt: $("#store-projekt").text() },
			
			beforeSubmit: function(arr, $form, options){
				$("#fileprogressbar").show();
				timebox = setInterval( function(){ 
					progress( $("#fileprogressbar") ); 
				} ,100);
			},
			
			success: function (response, statusText, xhr, $form){
				
				clearInterval(timebox);
				
				var attributeid = $("#attributeid").val();
				var _url = <cfoutput>"#URLFor(controller='Concessions',action='confirm')#"</cfoutput> + <cfoutput>"&concession=#params.key#"</cfoutput> + "&attribute=" + attributeid + "&value=" + response.SFILENAME;
				
				$.get(_url, function(){
					
					//document.location = <cfoutput>"#URLFor(controller='Concessions',action='view')#"</cfoutput> + <cfoutput>"&key=#params.key#"</cfoutput>
				});
				
				$("#fileprogressbar").progressbar( "option", "value", 100 );
				
				var ext = response.SFILENAME.split(".");
				ext = ext[1].toLowerCase();
				
				switch(ext){
					case 'pdf': src = 'file-pdf.png'; break;
					case 'jpg': src = 'file-img.png'; break;
					case 'png': src = 'file-img.png'; break;
				}
				
				$("#concession_file").val(response.SFILENAME);
				
				$(".fileelement").hide().before(
						$("<li>")
							.append(
								$("<label>").text("Załącznik"))
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
		});
		
		$(".documentinstancecontent").on("change", function(){

			time=0;
			
			$("#fileprogressbar").progressbar({ value: 0 });
			
			var ext = $(this).val().split(".");
			
			if( ext[ ext.length - 1 ].toLowerCase() == 'jpg' || ext[ ext.length - 1 ].toLowerCase() == 'png' || ext[ ext.length - 1 ].toLowerCase() == 'pdf')
				$("#fileuploadform").submit();
			else
				alert('Nieprawidłowy format pliku! Akceptowane formaty plik .jpg, .png, .pdf');
		
		});
		
		$(".updateButton").on("click", function(){
			
			var ajaxFormOptions = {
			
				dataType	: 'json',
				type		: 'post',
				url			: <cfoutput>"#URLFor(controller='Concessions',action='update')#"</cfoutput>,
				
				beforeSubmit: function(){
					
					var error = ''; 
					$("#updateConcession").find("input,select").each(function(){
						
						if($(this).val() == ''){
							error="Wszystkie pola są wymagane!";
							$(this).removeClass("input_ok").addClass("input_error");
						} else {
							$(this).removeClass("input_error").addClass("input_ok");
						}
					});
					
					if(error != '') {
						alert(error);
						return false;
					} else {
						return true;
					}
				},
				
				success: function (response, statusText, xhr, $form){
					
					$.get(<cfoutput>"#URLFor(controller='Concessions',action='license')#"</cfoutput> + "&key=" + response.id, function(data){
						
						$('#updateConcession').closest(".concession-attributes").before(data);
						
						var $file = $('#updateConcession').closest(".concession-attributes").prev().find(".file");
						
						filelink($file);
						
						if($(".concessions").find(".license").length >= 3){
							$('#updateConcession').parent().remove();
						} else {
							$('#updateConcession')[0].reset();
							$(".fileelement").show().prev().remove();
							
						}						
					});
				},
				
				error: function(xhr, status, error){
					
					console.log(xhr);
					console.log(status);
					console.log(error);
					alert("Wystąpił błąd! Nie udało się zapisać zmian. Spróbuj ponownie później.");					
				}
				
			};
			
			$('#updateConcession').ajaxForm(ajaxFormOptions);
			
			$('#updateConcession').submit();
		
		});
	});
</script>