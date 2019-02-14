<cfoutput>
	
	<div class="wrapper courses">
	
		<h3>Edycja profilu kandydata</h3>
			
		<div class="wrapper proposalform">
			<h5>Formularz</h5>
				
			#startFormTag(controller="Courses",action="update",multipart="true",id="create_student_form")#
				
				<!---<cfif StructKeyExists(params, "key")>						
					#hiddenFieldTag(
						name="proposalid",
						value=params.key)#
				</cfif>--->
				#hiddenFieldTag(name="student[id]",value=params.key)#
				
				<ol class="proposalfields">
					<li>
						#selectTag(name="student[statusid]", options=statuses, selected=student.statusid, includeBlank="-- wybierz --", label="Status kandydata", labelPlacement="before", class="required")#
					</li>
					
					<li>
						#textFieldTag(name="student[name]", value=student.name, label="Imię i nazwisko", labelPlacement="before", class="input required")#
					</li>
					<li>
						#selectTag(name="student[type]", options=options213, selected=student.type, includeBlank="-- wybierz --", label="Rodzaj kandydata", labelPlacement="before", class="required")#
					</li>
					<li>
						#textFieldTag(name="student[studentid]", value=student.studentid, label="Numer id kandydata", labelPlacement="before", class="input")#
					</li>
					<li>
						#textFieldTag(name="student[email]", value=student.email, label="E-mail", labelPlacement="before", class="input required")#
					</li>
					<li>
						#textFieldTag(name="student[phone]", value=student.phone, label="Nr telefonu", labelPlacement="before", class="input required")#
					</li>
					<li>
						#textFieldTag(name="student[pesel]", value=student.pesel, label="Pesel", labelPlacement="before", class="input required")#
					</li>
					<!---<li>
						#textFieldTag(name="student[docid]", value=student.docid, label="Seria i nr dowodu", labelPlacement="before", class="input")#
					</li>--->					
					<li>
						#textFieldTag(name="student[nip]", value=student.nip, label="NIP", labelPlacement="before", class="input")#
					</li>
					<li>
						#textFieldTag(name="student[regon]", value=student.regon, label="Regon", labelPlacement="before", class="input")#
					</li>
					<li>
						#textFieldTag(name="student[place]", value=student.place, label="Miejscowość docelowa", labelPlacement="before", class="input")#
					</li>
				</ol>
				
				#hiddenFieldTag(name="student[cv]", value=student.cv)#
				
				#hiddenFieldTag(name="student[docidscan]", value=student.docidscan)#
				
			#endFormTag()#
			
			<ol>
				<li>
					<!---#fileFieldTag(name="student[cv]", label="Plik z CV", labelPlacement="before", class="filefield")#--->
					
					<cfform action="#URLFor(action='upload')#" class="uploadform" id="cv" method="post">
						<label>Plik z CV (*.pdf, *.doc)</label>
						<cfif student.cv neq ''>
							<div class="fileselected" style="margin: 5px 0;">
								<a href="files/courses/#student.cv#">#student.cv#</a>
							</div>
						</cfif>
						<div class="fileselector" style="margin-left:200px;">
							<cfinput name="filedata" type="file" class="instancecontent input_file" label="Plik z CV (*.pdf, *.doc)" size="1" />
							<div class="progressbar"></div>
						</div>
					</cfform>
				</li>
				<li>
					<!---#fileFieldTag(name="student[docidscan]", label="Skan dowodu", labelPlacement="before", class="filefield")#--->
						
					<cfform action="#URLFor(action='upload')#" class="uploadform" id="docidscan" method="post">
						
						
						<label>Skan dowodu (*.jpg, *.png)</label>
						<cfif student.docidscan neq ''>
							<div class="fileselected" style="margin: 5px 0;">
								<a href="files/courses/#student.docidscan#">#student.docidscan#</a>
							</div>
						</cfif>
						<div class="fileselector" style="margin-left:200px;">
							<cfinput name="filedata" type="file" class="instancecontent input_file"	label="Skan dowodu (*.jpg, *.png)" size="1" />
							<div class="progressbar"></div>
						</div>
					</cfform>
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
				
				$form.find(".fileselected").remove();
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
				
				console.log(jqXHR);
				console.log(text);
				console.log(error);
				
				alert('Błąd w przesyłaniu pliku na serwer. Proszę spróbować później.');
			}
		};
		
		$(".uploadform").ajaxForm(options);
		
		$(".instancecontent").on("change", function(){
			time=0;
			$(this).next(".progressbar").progressbar({ value: 0 });
			//var ext = $(this).val().split(".");
			//if( ext[ ext.length - 1 ] != 'xls' ) alert('Nieprawidłowy format pliku! Wybierz plik *.xls');
			//else
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