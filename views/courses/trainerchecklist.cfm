<div class="wrapper courses">
	
	<h3>Lista zadań podczas szkolenia</h3>
	<cfoutput>
		
		<cfif lesson.completed eq 1>
			<cfset completed = ' disabled="disabled" ' />
		<cfelse>
			<cfset completed = '' />
		</cfif>
			
			<div class="intranet-backlink">
				#linkTo(
					text="&laquo; powrót do: Lista kursantów",
					action="trainer-index")#
			</div>
			
			<div class="wrapper proposalform">
				<!---<h4>Atrybuty szkolenia</h4>--->
				
				<table class="tables lesson-checklist">
					<!---<thead>
						<tr>
							<th colspan="4"></th>
						</tr>
					</thead>--->
					<tbody>
						<cfset day=1 />
						<tr class="trhead">
							<td>&nbsp;</td>
							<td class="tacenter">Dzień&nbsp;#day#</td>
							<td class="tacenter">Dzień&nbsp;#(day+3)#</td>
							<td class="tacenter">Dzień&nbsp;#(day+6)#</td>
						</tr>
						
						<cfset trgroup=0 />
						<cfset points=0 />
						
						<cfloop query="checklist">
							<cfif trgroup neq topicgroupid>
								<cfif trgroup neq 0>
									<cfset day++ />
									</tbody><tbody>
										<tr class="trhead">
											<cfif topicgroupid neq 4>
												<td>&nbsp;</td>
												<td class="tacenter">Dzień&nbsp;#day#</td>
												<td class="tacenter">Dzień&nbsp;#(day+3)#</td>
												<td class="tacenter">Dzień&nbsp;#(day+6)#</td>
											<cfelse>
												<td colspan="4">&nbsp;</td>
											</cfif>
										</tr>
								</cfif>
								<cfset trgroup=topicgroupid />
							</cfif>
							
							<tr>
								<td>#topicname#</td>
								<td class="tacenter">
									<cfif ListFind(cltc,"1") gt 0>
										<cfset points++ />
										<input type="checkbox" name="topic_#id#_1" class="checkbox trainercheckbox" data-sid="#params.key#" data-topicid="#id#" data-checkboxid="1" checked="checked" #completed# />
									<cfelse>
										<input type="checkbox" name="topic_#id#_1" class="checkbox trainercheckbox" data-sid="#params.key#" data-topicid="#id#" data-checkboxid="1" #completed# />
									</cfif>
								</td>
								<td class="tacenter">
									<cfif ListFind(cltc,"2") gt 0>
										<cfset points++ />
										<input type="checkbox" name="topic_#id#_2" class="checkbox trainercheckbox" data-sid="#params.key#" data-topicid="#id#" data-checkboxid="2" checked="checked" #completed# />
									<cfelse>
										<input type="checkbox" name="topic_#id#_2" class="checkbox trainercheckbox" data-sid="#params.key#" data-topicid="#id#" data-checkboxid="2" #completed# />
									</cfif>
								</td>
								<td class="tacenter">
									<cfif ListFind(cltc,"3") gt 0>
										<cfset points++ />
										<input type="checkbox" name="topic_#id#_3" class="checkbox trainercheckbox" data-sid="#params.key#" data-topicid="#id#" data-checkboxid="3" checked="checked" #completed# />
									<cfelse>
										<input type="checkbox" name="topic_#id#_3" class="checkbox trainercheckbox" data-sid="#params.key#" data-topicid="#id#" data-checkboxid="3" #completed# />
									</cfif>
								</td>
							</tr>
						</cfloop>
					</tbody>
				</table>
				
			</div>
			
			<div class="wrapper proposalform">
				<h4>Załączniki</h4>
				
				<ol>
					<cfset typeid_1=0 />
					<cfset typeid_2=0 />
					<cfloop query="attachments">
						<cfswitch expression="#typeid#">
							<cfcase value="1">
								<cfset typeid_1=1 />
								<li>
									<!---<label>Karta oceny kandydata</label>--->
									<a href="files/courses/#filename#"><img src="images/#GetIconForFile(filename=filename)#" alt="#filename#" />&nbsp;Karta oceny kandydata</a>
								</li>
							</cfcase>
							<cfcase value="2">
								<cfset typeid_2=1 />
								<li>
									<!---<label>Zaświadczenie o ukończony szkoleniu</label>--->
									<a href="files/courses/#filename#"><img src="images/#GetIconForFile(filename=filename)#" alt="#filename#" />&nbsp;Zaświadczenie o ukończony szkoleniu</a>
								</li>
							</cfcase>
						</cfswitch>
					</cfloop>
					
					<cfif typeid_1 eq 0>
						<li>
							<cfform action="#URLFor(action='upload')#" class="uploadform" id="attachment1" method="post">
								<cfinput type="hidden" name="lessonid" value="#params.lid#">
								<cfinput type="hidden" name="typeid" value="1">
								<label>Karta oceny kandydata</label>
								<div class="fileselector checklist-fileselector" style="margin-left:200px;" data-trainerid="#trainerid#" data-studentid="#params.key#">
									<div class="web-button-blue attachment-button">
										Wybierz plik
										<cfinput name="filedata" type="file" class="instancecontent input_file attachment-selector " label="Karta oceny kandydata" size="1" />
									</div>
									<div class="progressbar"></div>
									<div style="clear:both"></div>
								</div>
							</cfform>
						</li>
					</cfif>
					<cfif typeid_2 eq 0>
						<li>
							<cfform action="#URLFor(action='upload')#" class="uploadform" id="attachment2" method="post">
								<cfinput type="hidden" name="lessonid" value="#params.lid#">
								<cfinput type="hidden" name="typeid" value="1">
								<label>Zaświadczenie o ukończony szkoleniu</label>
								<div class="fileselector checklist-fileselector" style="margin-left:200px;" data-trainerid="#trainerid#" data-studentid="#params.key#">
									<div class="web-button-blue attachment-button">
										Wybierz plik
										<cfinput name="filedata" type="file" class="instancecontent input_file attachment-selector " label="Zaświadczenie o ukończony szkoleniu" size="1" />
									</div>
									<div class="progressbar"></div>
									<div style="clear:both"></div>
								</div>
							</cfform>
						</li>
					</cfif>
				</ol>
				
			</div>
			
			<cfif lesson.completed eq 0>
				<div class="wrapper proposalform">
					#submitTag(value="Zakończ szkolenie", class="formButton button redButton courseSubmit")#
				</div>
			</cfif>
	</cfoutput>
</div>
<div id="dialog-confirm" title="Koniec szkolenia" style="display:none;">
	<p style="font-weight: bold;">Jesteś pewien, że chcesz zakończyć szkolenie?</p>
	<p>Dalsze wprowadzanie zmian będzie niemożliwe!</p>
</div>
<!---<cfdump var="#lesson#" />--->
<script>
	$(function(){
		
		var timebox, time=0;	
		function progress(obj){
			time += 5;		
			if( time < 90 ){ obj.progressbar( "option", "value", time ); } 
			else { obj.progressbar( "option", "value", false ); clearInterval(timebox); }
		}
		
		function saveAttachment(_lessonid, _studentid, _trainerid, _typeid, _filename){
			
			console.log(_lessonid +" "+ _studentid +" "+ _trainerid +" "+ _typeid +" "+ _filename);
			$("#flashMessages").hide();
			$.ajax({
				type: "GET",
				url: <cfoutput>"#URLFor(action='lesson-attachment-save')#"</cfoutput>,
				data: {
					lid: _lessonid,
					sid: _studentid,
					tid: _trainerid,
					typeid: _typeid,
					filename: _filename
				},
				success: function(){
					$("#flashMessages").hide();
				},
				error: function(){
					alert("Wystąpił błąd przy zapisywaniu pliku.");
					$("#flashMessages").hide();
				}
			});
		}
		
		$(".courseSubmit").on("click", function(){
			$("#dialog-confirm").dialog("open");
			
			return false;
		});
		
		$("#dialog-confirm").dialog({
			autoOpen: false,
			resizable: false,
			height: 150,
			modal: true,
			buttons: {
				"Tak": function() {
					$("#flashMessages").show();
					$(".trainercheckbox").prop('disabled', true);
					$.ajax({
						type: "GET",
						url: <cfoutput>"#URLFor(action='trainer-set-lesson-complete')#"</cfoutput>,
						data: {
							sid: <cfoutput>#params.key#</cfoutput>,
							lid: <cfoutput>#params.lid#</cfoutput>,
							completed: 1
						},
						success: function(){
							$("#flashMessages").hide();
							$("#dialog-confirm").dialog("close");
						},
						error: function(){
							$("#flashMessages").hide();
							alert("Wystąpił błąd przy zapisywaniu. Spróbuj ponownie później.");
							$(".trainercheckbox").prop('disabled', false);
							$("#dialog-confirm").dialog("close");
						}
					});
				},
				"Nie": function() {
					$("#dialog-confirm").dialog("close");
				}
			}
		});
		
		var ajax=true;
		$(".trainercheckbox").on("click", function(){
			var $this = $(this);
			
			if(ajax && $(this).is(":checked")){
				ajax=false;
				$("#flashMessages").show();
				$.ajax({
					type: "GET",
					url: <cfoutput>"#URLFor(action='trainer-update-list')#"</cfoutput>,
					data: {
						sid: $this.data("sid"),
						topicid: $this.data("topicid"),
						checkboxid: $this.data("checkboxid"),
						tid: <cfoutput>#trainerid#</cfoutput>
					},
					success: function(){
						$("#flashMessages").hide();
						ajax=true;
						$this.prop("checked", true);
					},
					error: function(){
						alert("Wystąpił błąd przy zapisywaniu. Spróbuj ponownie później.");
						$("#flashMessages").hide();
						ajax=true;
					}
				});
			}
			
			return false;
		});
		
		$(".progressbar").progressbar({ value: 0 });
		
		var options = {
			dataType	: 'json',
			type		: 'post',
			url			: "<cfoutput>#URLFor(action='upload')#</cfoutput>",
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
				
				console.log({
					a: $form.find("#lessonid").val(),
					b: $form.find(".fileselector").data("studentid"),
					c: $form.find(".fileselector").data("trainerid"),
					d: 1,
					e: responseText.sfilename});
						
				switch($form.prop("id")){
					case 'attachment1': 
						saveAttachment(
							$form.find("#lessonid").val(),
							$form.find(".fileselector").data("studentid"),
							$form.find(".fileselector").data("trainerid"),
							1,
							responseText.sfilename); break;
					case 'attachment2': 
						saveAttachment(
							$form.find("#lessonid").val(),
							$form.find(".fileselector").data("studentid"),
							$form.find(".fileselector").data("trainerid"),
							2,
							responseText.sfilename); break;
				}
				
				$form.find(".fileselected").remove();
				$form.find(".fileselector").fadeOut().after(
					$("<span>").html(
						$("<a>").prop("href","files/courses/"+responseText.sfilename).text(responseText.cfilename)));
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
			$(this).parent().next(".progressbar").progressbar({ value: 0 });
			$(this).closest(".uploadform").submit();
		});
		
	});
</script>