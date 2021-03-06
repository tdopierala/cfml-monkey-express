<cfoutput>
	
	<div class="wrapper courses">
	
		<h3>Tworzenie nowego profilu kandydata</h3>
		
		<cfif flashKeyExists("success")>
	    	<span class="success">#flash("success")#</span>
		</cfif>
		
		<cfif flashKeyExists("error")>
	    	<span class="error">#flash("error")#</span>
		</cfif>
			
		<div class="wrapper proposalform">
			<h5>Formularz</h5>
				
			#startFormTag(controller="Courses",action="create",multipart="true",id="create_student_form")#
				
				#hiddenFieldTag(name="student[recruitmentstatusid]", value="0")#
				
				<!---<cfif StructKeyExists(params, "key")>						
					#hiddenFieldTag(name="proposalid", value=params.key)#
				</cfif>--->
				
				<ol class="proposalfields">
					
					<li>
						#textFieldTag(name="student[name]", label="Imię i nazwisko", labelPlacement="before", class="input required")#
					</li>
					<li>
						#selectTag(name="student[type]", options=options213, includeBlank="-- wybierz --", label="Rodzaj kandydata", labelPlacement="before", class="required")#
					</li>
					<li>
						#textFieldTag(name="student[studentid]", label="Numer id kandydata", labelPlacement="before", class="input")#
					</li>
					<li>
						#textFieldTag(name="student[email]", label="E-mail", labelPlacement="before", class="input required")#
					</li>
					<li>
						#textFieldTag(name="student[phone]", label="Nr telefonu", labelPlacement="before", class="input required")#
					</li>
					<li>
						#textFieldTag(name="student[pesel]", label="Pesel", labelPlacement="before", class="input required")#
					</li>
					<!---<li>
						#textFieldTag(name="student[docid]", label="Seria i nr dowodu", labelPlacement="before", class="input")#
					</li>--->					
					<li>
						#textFieldTag(name="student[nip]", label="NIP", labelPlacement="before", class="input")#
					</li>
					<li>
						#textFieldTag(name="student[regon]", label="Regon", labelPlacement="before", class="input")#
					</li>
					<li>
						#textFieldTag(name="student[place]", label="Miejscowość docelowa", labelPlacement="before", class="input")#
					</li>
				</ol>
				
				#hiddenFieldTag(name="student[cv]")#
				
				#hiddenFieldTag(name="student[docidscan]")#
				
			#endFormTag()#
			
			<ol>
				<li>
					<!---#fileFieldTag(name="student[cv]", label="Plik z CV", labelPlacement="before", class="filefield")#--->
					<!---<cfif session.user.id eq 345>--->
						<cfform action="#URLFor(action='upload')#" class="uploadform" id="cv" method="post">
							<label>Plik z CV (*.pdf, *.doc)</label>
							<div class="fileselector checklist-fileselector" style="margin-left:200px;">
								<div class="web-button-blue attachment-button">
									Wybierz plik
									<cfinput name="filedata" type="file" class="instancecontent input_file attachment-selector " label="Plik z CV" size="1" />
								</div>
								<div class="progressbar"></div>
								<div style="clear:both"></div>
							</div>
						</cfform>
					<!---<cfelse>
						<cfform action="#URLFor(action='upload')#" class="uploadform" id="cv" method="post">
							<label>Plik z CV (*.pdf, *.doc)</label>
							<div class="fileselector" style="margin-left:200px;">
								<cfinput name="filedata" type="file" class="instancecontent input_file"	label="Plik z CV (*.pdf, *.doc)" size="1" />
								<div class="progressbar"></div>
							</div>
						</cfform>
					</cfif>--->
				</li>
				<li>
					<!---#fileFieldTag(name="student[docidscan]", label="Skan dowodu", labelPlacement="before", class="filefield")#--->
					<!---<cfif session.user.id eq 345>--->
						<cfform action="#URLFor(action='upload')#" class="uploadform" id="docidscan" method="post">
							<label>Skan dowodu (*.jpg, *.png)</label>
							<div class="fileselector checklist-fileselector" style="margin-left:200px;">
								<div class="web-button-blue attachment-button">
									Wybierz plik
									<cfinput name="filedata" type="file" class="instancecontent input_file attachment-selector " label="Skan dowodu" size="1" />
								</div>
								<div class="progressbar"></div>
								<div style="clear:both"></div>
							</div>
						</cfform>
					<!---<cfelse>
						<cfform action="#URLFor(action='upload')#" class="uploadform" id="docidscan" method="post">
							<label>Skan dowodu (*.jpg, *.png)</label>
							<div class="fileselector" style="margin-left:200px;">
								<cfinput name="filedata" type="file" class="instancecontent input_file"	label="Skan dowodu (*.jpg, *.png)" size="1" />
								<div class="progressbar"></div>
							</div>
						</cfform>
			   		</cfif>--->
				</li>
			</ol>
				
			<ol>
				<li>
					#submitTag(value="Zapisz",class="smallButton redSmallButton submitbutton")#
				</li>
				
			</ol>
				
		</div>
		
	</div> 
</cfoutput>

<script>
	var timebox, time=0;	
	function progress(obj){
		time += 5;		
		if( time < 90 ){
			obj.progressbar( "option", "value", time ); } 
		else { 
			obj.progressbar( "option", "value", false ); 
			clearInterval(timebox); 
		}
	}
	
	function filelink($this){			
		var filename = $this.text();
		var file_tmp = filename;
		var file = file_tmp.split(".");			
		switch(file[1]){
			case 'pdf': src = 'file-pdf.png'; break;
			case 'jpg': src = 'file-img.png'; break;
			case 'doc': src = 'file-word.png'; break;
			case 'png': src = 'file-img.png'; break;
			default:	src = 'blank.png';
		}
		$this.empty()
			.append($("<img>").attr("src", "images/"+src).attr("alt", file[1]))
			.append($("<a>").attr("href", "files/proposals/" + filename).attr("target", "_blank").attr("title", "Pobierz plik").text(file[0] + "." + file[1]));
	}
	
	$(function(){
		
		$(".submitbutton").on("click",function(){			
			$("#create_student_form").submit();
		});
		
		$(".progressbar").progressbar({ value: 0 });
		
		var options = {
			dataType	: 'json',
			type		: 'post',
			url		: "<cfoutput>#URLFor(action='upload')#</cfoutput>",
			beforeSubmit: function(arr, $form, options){
				
				var progressbar = $form.find(".progressbar");
				progressbar.show();
				timebox = setInterval( function(){ 
					progress(progressbar); 
				} ,100);
			},
			success: function (responseText, statusText, xhr, $form){
				clearInterval(timebox);
				$form.find(".progressbar").progressbar( "option", "value", 100 );
				
				$form.find(".fileselector").fadeOut().after(
					$("<span>").html(
						$("<a>").prop("href","files/courses/"+responseText.sfilename).text(responseText.cfilename)));
						
				switch($form.prop("id")){
					case 'cv': $("#student-cv").val(responseText.sfilename); break;
					case 'docidscan': $("#student-docidscan").val(responseText.sfilename); break;
				}
				
			},
			error: function(jqXHR, text, error){
				clearInterval(timebox);
				$(".progressbar").progressbar( "option", "value", 0 );
				alert('Błąd w przesyłaniu pliku na serwer. Proszę spróbować później.');
			}
		};
		
		$(".uploadform").ajaxForm(options);
		
		$(".instancecontent").on("change", function(){
			time=0;
			$(this).next(".progressbar").progressbar({ value: 0 });
			$(this).closest(".uploadform").submit();
		});
		
		$(".file").each(function( i ){			
			filelink($(this));
		});
	
		$('.required').each(function(i, element) {
			var toAppend = "<span class=\"requiredfield\"> *</span>";
			$(this).parent().find('label').append(toAppend);
		});
	});
</script>