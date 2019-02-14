<cfoutput>
	<div class="wrapper courses">
		
		<h3>Etapy rekrutacji</h3>
		
		<div class="intranet-backlink">
			<cfoutput><a href="#URLFor(action='recruitment')#">&laquo; Lista kandydatów</a></cfoutput>
		</div>
		
		<div class="wrapper formbox">
			<ol class="recruitmentDetails">
				<li>
					<label>Imię i nazwisko</label>
					<span>&nbsp;#student.name#</span>
				</li>
				<li>
					<label>Adres e-mail</label>
					<span>&nbsp;<a href="mailto:#student.email#">#student.email#</a></span>
				</li>
				<li>
					<label>Nr telefonu</label>
					<span>&nbsp;#student.name#</span>
				</li>
				<li>
					<label>Lokalizacja docelowa</label>
					<span>&nbsp;#student.place#</span>
				</li>
				<li>
					<label>Data utworzenia</label>
					<span>&nbsp;#DateFormat(student.createddate, "yyyy-mm-dd")#</span>
				</li>
				<li>
					<label>Źródło rekrutacji</label>
					<span>&nbsp;#student.recruitmentsrc#</span>
				</li>
				<li>
					<label>Pesel</label>
					<cfif student.pesel eq ''>
						<span class="nodata">&nbsp;brak danych</span>
					<cfelse>
						<span>&nbsp;#student.pesel#</span>
					</cfif>
				</li>
				<li>
					<label>Nip</label>
					<cfif student.nip eq ''>
						<span class="nodata">&nbsp;brak danych</span>
					<cfelse>
						<span>&nbsp;#student.nip#</span>
					</cfif>
				</li>
				<li>
					<label>Plik CV</label>
					<cfif Len(student.cv) gt 0>
						<span>&nbsp;<a href="files/courses/#student.cv#"><img src="images/#GetIconForFile(filename=student.cv)#" alt="#student.cv#" height="16" />&nbsp;#Right(student.cv, Len(student.cv)-20)#</a></span>
					<cfelse>
						<span>&nbsp;brak</span>
					</cfif>
				</li>
				<li>
					<label>Skan dowodu osobistego</label>
					<cfif Len(student.docidscan) gt 0>
						<span>&nbsp;<a href="files/courses/#student.docidscan#"><img src="images/#GetIconForFile(filename=student.docidscan)#" alt="#student.docidscan#" height="16" />&nbsp;#Right(student.docidscan, Len(student.docidscan)-20)#</a></span>
					<cfelse>
						<span>&nbsp;brak</span>
					</cfif>
				</li>
				<li>
					<label>Zaświadczenie o niekaralności</label>
					<cfif Len(student.attachment1) gt 0>
						<span>&nbsp;<a href="files/courses/#student.attachment1#"><img src="images/#GetIconForFile(filename=student.attachment1)#" alt="#student.attachment1#" height="16" />&nbsp;#Right(student.attachment1, Len(student.attachment1)-20)#</a></a></span>
					<cfelse>
						<span>&nbsp;brak</span>
					</cfif>
				</li>
				<li>
					<label>Umowa o poufności</label>
					<cfif Len(student.attachment2) gt 0>
						<span>&nbsp;<a href="files/courses/#student.attachment2#"><img src="images/#GetIconForFile(filename=student.attachment2)#" alt="#student.attachment2#" height="16" />&nbsp;#Right(student.attachment2, Len(student.attachment2)-20)#</a></a></span>
					<cfelse>
						<span>&nbsp;brak</span>
					</cfif>
				</li>
				<li>
					<label>Umowa o szkoleniu</label>
					<cfif Len(student.attachment3) gt 0>
						<span>&nbsp;<a href="files/courses/#student.attachment3#"><img src="images/#GetIconForFile(filename=student.attachment3)#" alt="#student.attachment3#" height="16" />&nbsp;#Right(student.attachment3, Len(student.attachment3)-20)#</a></a></span>
					<cfelse>
						<span>&nbsp;brak</span>
					</cfif>
				</li>
			</ol>
		</div>
		
		<div class="intranet-backlink">
			<a href="#URLFor(action='update-candidate', key=params.key)#" class="update-candidate">Uzupełnij dane</a>
		</div>
		
		<div class="wrapper formbox">
			<cfloop query="recruitmentsteps">
				<div class="recruitmentStep">
					<cfswitch expression="#stepid#">
						<cfcase value="1">
							<div class="recruitmentStepName">Ankieta rekrutacyjna</div>
						</cfcase>
						<cfcase value="2">
							<div class="recruitmentStepName">Spotkanie z kandydatem</div>
						</cfcase>
						<cfcase value="3">
							<div class="recruitmentStepName">Potwierdzenie chęci współpracy</div>
						</cfcase>
						<cfcase value="4">
							<div class="recruitmentStepName">Skierowanie na weryfikację KOS</div>
						</cfcase>
						<cfcase value="5">
							<div class="recruitmentStepName">Weryfikacja KOS</div>
						</cfcase>
					</cfswitch>
					<div class="recruitmentStepBr">
						Data utworzenia: <span class="bold">#DateFormat(createddate, "yyyy-mm-dd")#</span>
					</div>
					<div class="recruitmentStepBr">Status: 
						<cfswitch expression="#stepstatusid#">
							<cfcase value="1">
								<span class="bold">W trakcie</span>
							</cfcase>
							<cfcase value="2">
								<span class="bold confirm">Potwierdzony</span>
							</cfcase>
							<cfcase value="3">
								<span class="bold discard">Odrzucony</span>
							</cfcase>
						</cfswitch>
					</div>
					<div class="recruitmentStepBr">Osoba odpowiedzialna: <span class="bold">#givenname# #sn#</span></div>
					
					<div class="recruitmentStepBr comment_box">
						<cfset message = stepmsg />
						<cfset begin = FindNoCase("http", message) />
						<cfif begin gt 0>
							<cfif FindNoCase(" ", message, begin) gt 0>
								<cfset end = FindNoCase(" ", message, begin) />
							<cfelse>
								<cfset end = Len(message) />
							</cfif>
							
							<cfset link = Mid(message, begin, (end - begin)+1) />
							
							<cfset message = ReplaceNoCase(message, link, '<a href="#link#" target="_blank">#Left(link,150)#...</a>')/>
						</cfif>
						
						#message#
					</div>
					<!---#stepid# #stepstatusid# #stepmsg# #createddate#--->
					<cfif stepid eq 5 and stepstatusid eq 1 and (_root is true or userid eq session.user.id)>
						<div class="intranet-backlink">
							<a href="##" id="recruitment_steps_accept">Zaakceptuj/Odrzuć</a>
						</div>
					</cfif>
				</div>
			</cfloop>
		</div>
		
		<div id="recruitment_steps_accept_dialog" style="display:none;">
			<div class="wrapper proposalform">
				<h4>Weryfikacja KOS</h4>
				<ol>
					<li>
						<span>Uzasadnienie:</span><br />
						#textAreaTag(name="message", class="textarea")#
						#hiddenFieldTag(name="studentid",value="#params.key#")#
					</li>
					<!---<li>
						#submitTag(value="Zatwierdź",class="smallButton greenSmallButton submitButton _accept")#
						#submitTag(value="Odrzuć",class="smallButton redSmallButton submitButton _discard")#
					</li>--->
				</ol>
			</div>
		</div>

		<!---<cfdump var="#student#" />--->
		<!---<cfif session.user.id eq 345>
			<cfdump var="#recruitmentsteps#" />
		</cfif>--->
		
	</div>
	
	<div id="dialogBox" title="Edycja danych kandydata" style="display:none;"></div>
</cfoutput>
<script>
	$(function(){
		
		$(".update-candidate").on("click", function(){
			
			$("#flashMessages").show();
			$.get($(this).prop("href"), function(data){
				$("#dialogBox").html(data).dialog("open");
				$("#flashMessages").hide();
			}); 
			
			return false;
		});
		
		$("#dialogBox").dialog({
			autoOpen: false,
			resizable: false,
			height: 600,
			width: 700,
			modal: true,
			buttons: {
				"Zapisz": function() {
					var $dialog = $(this);
					
						$dialog.find("#update_student_form").submit();
						$dialog.dialog("close");
					
						//stepstatusid = typeof $dialog.find("#stepstatus").val() != "undefined" ? $dialog.find("#stepstatus").val() : $dialog.find("input[name=stepstatus]:checked").val(),
						//params = {
						//	stepid: $dialog.find("#stepid").val(),
						//	studentid: $dialog.find("#studentid").val(),
						//	message: stepstatusid != 3 ? $dialog.find("#message").val() : $dialog.find("#discard").val(),
						//	statusid: stepstatusid
						//};
					//recruitmentStatusUpdate(params, $dialog);
				}
			}
		});
		
		$("#dialogBox").on("submit", "#update_student_form", function(e){
			e.preventDefault();
			
			var _form = { arr: $(this).serializeArray() };
			var form = {};
			
			for(var i=0; i<_form.arr.length; i++){
				form[_form.arr[i].name] = _form.arr[i].value; 
			}
			
			console.log(form);
			
			$("#flashMessages").show();
			$.ajax({
				type: "POST",
				url: <cfoutput>"#URLFor(action='update-candidate')#"</cfoutput>,
				data: form,
				success: function(){
					$("#flashMessages").hide();
					//window.location.href=<cfoutput>"#URLFor(action='recruitment-view',key=params.key)#"</cfoutput>;
					location.reload();
				},
				error: function(){
					$("#flashMessages").hide();
					alert("Wystąpił błąd przy zapisywaniu. Spróbuj ponownie później.");
				}
			});
		});
		
		$("#recruitment_steps_accept_dialog").dialog({
			autoOpen: false,
			resizable: false,
			height: 300,
			width: 500,
			modal: true,
			buttons: {
				"Zaakceptuj": function() {
					var $dialog = $(this);
					params = {
						stepid: 5,
						studentid: $dialog.find("#studentid").val(),
						message: $dialog.find("#message").val(),
						statusid: 2,
						kosid: 0
					};
					recruitmentStatusUpdate(params,$dialog)
				},
				"Odrzuć": function() {
					var $dialog = $(this);
					params = {
						stepid: 5,
						studentid: $dialog.find("#studentid").val(),
						message: $dialog.find("#message").val(),
						statusid: 2,
						kosid: 0
					};
					recruitmentStatusUpdate(params,$dialog)
				}
			}
		});
		
		$("#recruitment_steps_accept").on("click", function(event){
			event.preventDefault();
			$("#recruitment_steps_accept_dialog").dialog("open");
		});
		
		var recruitmentStatusUpdate = function(params, $dialog){
			$("#flashMessages").show();
			$.ajax({
				type: "POST",
				url: <cfoutput>"#URLFor(action='recruitment-status-update')#"</cfoutput>,
				data: {
					stepid	: params.stepid, 
					sid		: params.studentid, 
					msg		: params.message,
					statusid: params.statusid,
					kosid	: params.kosid
				},
				success: function(){
					$("#flashMessages").hide();
					$dialog.dialog("close");
					location.reload(); 
					//window.location.href=<cfoutput>"#URLFor(action='recruitment')#"</cfoutput>;
				},
				error: function(){
					$("#flashMessages").hide();
					alert("Wystąpił błąd przy zapisywaniu. Spróbuj ponownie później.");
					$dialog.dialog("close");
				}
			});
		}
	});
</script>