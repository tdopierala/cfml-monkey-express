<cfoutput>
	
	<div class="wrapper courses">
			
		<div class="wrapper proposalform">
			<h5>Formularz kandydata</h5>
				
			#startFormTag(action="update-candidate",id="update_student_form")#
				#hiddenFieldTag(name="key", value="#params.key#")#
				
				<ol class="proposalfields">
					<li>
						#textFieldTag(name="name", label="Imię i nazwisko", labelPlacement="before", value="#student.name#", disabled="disabled", class="input")#
					</li>
					<li>
						#textFieldTag(name="phone", label="Nr telefonu", labelPlacement="before", value="#student.phone#", disabled="disabled", class="input required")#
					</li>
					<li>
						#textFieldTag(name="email", label="E-mail", labelPlacement="before", value="#student.email#", disabled="disabled", class="input required")#
					</li>
					<li>
						#textFieldTag(name="place", label="Miejscowość docelowa", value="#student.place#", disabled="disabled", labelPlacement="before", class="input")#
					</li>					
					<li>
						#textFieldTag(name="recruitmentsrc", label="Źródło rekrutacji", value="#student.recruitmentsrc#", disabled="disabled", labelPlacement="before", class="input")#
					</li>
					<li>
						#textFieldTag(name="pesel", label="Pesel", labelPlacement="before", value="#student.pesel#", class="input required")#
					</li>										
					<li>
						#textFieldTag(name="nip", label="NIP", labelPlacement="before", value="#student.nip#", class="input")#
					</li>
				</ol>
				
				#hiddenFieldTag(name="cv")#
				#hiddenFieldTag(name="attachment2")#
				#hiddenFieldTag(name="attachment3")#
				
			#endFormTag()#
			
			<ol>
				<!---<li>	
					<cfform action="#URLFor(action='upload')#" class="uploadform" id="cv" method="post">
						<label>Plik z CV (*.pdf, *.doc)</label>
						<div class="fileselector" style="margin-left:200px;">
							<cfinput name="filedata" type="file" class="instancecontent input_file"	label="Plik z CV (*.pdf, *.doc)" size="1" />
							<div class="progressbar"></div>
						</div>
					</cfform>
				</li>--->
				<li>
					<label>Plik CV</label>
					<cfif student.cv neq ''>
						<span class="span-file">&nbsp;<a href="files/courses/#student.cv#"><img src="images/#GetIconForFile(filename=student.cv)#" alt="#student.cv#" height="16" class="fileicon" />&nbsp;#Right(student.cv, Len(student.cv)-20)#</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="##" title="usuń plik" class="removefile" data-filename="#student.cv#"><img src="images/remove2.png" height="11" alt="usuń" /></a></span>
						<cfset form_hide = "hiddenform" />
					<cfelse>
						<cfset form_hide = "visibleform" />
					</cfif>
					
					<cfform action="#URLFor(action='upload')#" class="uploadform #form_hide#" id="cv" method="post">
						<div class="fileselector checklist-fileselector" style="margin-left:200px;">
							<div class="web-button-blue attachment-button">
								Wybierz plik
								<cfinput name="filedata" type="file" class="instancecontent input_file attachment-selector " label="Plik z CV" size="1" />
							</div>
							<div class="progressbar smallprogressbar"></div>
							<div style="clear:both"></div>
						</div>
					</cfform>
				</li>
				
				<li>
					<label>Umowa o poufności</label>
					<cfif student.attachment2 neq ''>
						<span class="span-file">&nbsp;<a href="files/courses/#student.attachment2#"><img src="images/#GetIconForFile(filename=student.attachment2)#" alt="#student.attachment2#" height="16" class="fileicon" />&nbsp;#Right(student.cv, Len(student.attachment2)-20)#</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="##" title="usuń plik" class="removefile" data-filename="#student.attachment2#"><img src="images/remove2.png" height="11" alt="usuń" /></a></span>
						<cfset form_hide = "hiddenform" />
					<cfelse>
						<cfset form_hide = "visibleform" />
					</cfif>
					
					<cfform action="#URLFor(action='upload')#" class="uploadform #form_hide#" id="attachment2" method="post">
						<div class="fileselector checklist-fileselector" style="margin-left:200px;">
							<div class="web-button-blue attachment-button">
								Wybierz plik
								<cfinput name="filedata" type="file" class="instancecontent input_file attachment-selector " label="Umowa o poufności" size="1" />
							</div>
							<div class="progressbar smallprogressbar"></div>
							<div style="clear:both"></div>
						</div>
					</cfform>
				</li>
				
				<li>
					<label>Umowa o szkoleniu</label>
					<cfif student.attachment3 neq ''>
						<span class="span-file">&nbsp;<a href="files/courses/#student.attachment3#"><img src="images/#GetIconForFile(filename=student.attachment3)#" alt="#student.attachment3#" height="16" class="fileicon" />&nbsp;#Right(student.cv, Len(student.attachment3)-20)#</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="##" title="usuń plik" class="removefile" data-filename="#student.attachment3#"><img src="images/remove2.png" height="11" alt="usuń" /></a></span>
						<cfset form_hide = "hiddenform" />
					<cfelse>
						<cfset form_hide = "visibleform" />
					</cfif>
					
					<cfform action="#URLFor(action='upload')#" class="uploadform #form_hide#" id="attachment3" method="post">
						<div class="fileselector checklist-fileselector" style="margin-left:200px;">
							<div class="web-button-blue attachment-button">
								Wybierz plik
								<cfinput name="filedata" type="file" class="instancecontent input_file attachment-selector " label="Umowa o szkoleniu" size="1" />
							</div>
							<div class="progressbar smallprogressbar"></div>
							<div style="clear:both"></div>
						</div>
					</cfform>
				</li>
			</ol>
				
		</div>
		
	</div> 
</cfoutput>
<script>
	$(function(){
		
		$(".progressbar").progressbar({value:0});
		
		var options = {
			dataType	: 'json',
			type		: 'post',
			url			: "<cfoutput>#URLFor(action='upload')#</cfoutput>",
			beforeSubmit: function(arr, $form, options){				
				var progressbar = $form.find(".progressbar");
				progressbar.show();
				timebox = setInterval(function(){
					progress(progressbar);
				},100);
			},
			success: function (responseText, statusText, xhr, $form){
				clearInterval(timebox);
				$form.find(".progressbar").progressbar("option","value",100);
				$form.find(".fileselector").fadeOut().after(
					$("<span>").html($("<a>")
						.prop("href","files/courses/"+responseText.sfilename)
						.append($("<img>").addClass("iconimage").prop("src","images/"+getIcon(responseText.sfilename)).prop("alt","plik"))
						.append("&nbsp;" + responseText.cfilename)));
						
				switch($form.prop("id")){
					case 'cv': $("#cv").val(responseText.sfilename); break;
					case 'docidscan': $("#docidscan").val(responseText.sfilename); break;
					case 'attachment1': $("#attachment1").val(responseText.sfilename); break;
					case 'attachment2': $("#attachment2").val(responseText.sfilename); break;
					case 'attachment3': $("#attachment3").val(responseText.sfilename); break;
				}
			},
			error: function(jqXHR, text, error){
				clearInterval(timebox);
				$(".progressbar").progressbar("option","value",0);
				alert('Błąd w przesyłaniu pliku na serwer. Proszę spróbować później.');
			}
		};
		
		$(".uploadform").ajaxForm(options);
		
		$(".instancecontent").on("change", function(){
			time=0;
			$(this).next(".progressbar").progressbar({value:0});
			$(this).closest(".uploadform").submit();
		});
		
		$(".span-file").mouseover(function(){
			$(this).find(".removefile").css("visibility","visible");
		}).mouseout(function(){
			$(this).find(".removefile").css("visibility","hidden");
		});
		
		$(".removefile").on("click", function(event){
			event.preventDefault();
			
			var $file = $(this).closest(".span-file");
			
			var value = $(this).data("filename");
			$.get("<cfoutput>#URLFor(action='remove-file')#</cfoutput>" + "&filename=" + value, function(data) {
				console.log(data);
				$file.next().show();
				$file.remove();
			});
		});
		
	});
	function progress(obj){time+=5;if(time<90){obj.progressbar("option","value",time);}else{obj.progressbar("option","value",false);clearInterval(timebox);}}
	function filelink($this){var filename=$this.text(),file_tmp=filename,file=file_tmp.split(".");switch(file[1]){case'pdf':src='file-pdf.png';break;case'jpg':src='file-img.png';break;case'doc':src='file-word.png';break;case'png':src='file-img.png';break;default:src='blank.png';}$this.empty().append($("<img>").attr("src","images/"+src).attr("alt",file[1])).append($("<a>").attr("href","files/proposals/"+filename).attr("target","_blank").attr("title","Pobierz plik").text(file[0]+"."+file[1]));}
	function getIcon(filename){var arr=filename.split("."),ext=arr[arr.length-1];switch(ext){case'xls':case'xlsx':var ico="excel-icon.png";break;case'doc':case'docx':var ico="file-word.png";break;case'jpg':case'jpeg':var ico="file-img.png";break;case'pdf':var ico="file-pdf.png";break;default:var ico="blank.png";}return ico;}
</script>