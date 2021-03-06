<!---<cfif IsDefined("proposal")>
	<cfdump var="#proposal#">
</cfif>
<cfabort>--->
<cfoutput>
	
	<div class="wrapper concessions">
		
		<h3>Wniosek o refundacje koncesji</h3>
		
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		<cfelseif flashKeyExists("error")>
			<span class="error">#flash("error")#</span>
		</cfif>
		
		<cfswitch expression="#proposal.type#">
			
			<cfcase value="1">
			
				<ol class="proposalfields">
					<cfloop query="attributefields">
						<li>
							<cfif required eq 1 >
								<cfset req = ' required' />
							<cfelse>
								<cfset req = ' notrequired' />
							</cfif>
									
							<cfswitch expression="#attributetypeid#" >
										
								<cfcase value="1" >
										
									#textFieldTag(
										name="attributevalue[#id#]",
										value=value,
										label=label,
										labelPlacement="before",
										class="input #req#")#
											
								</cfcase>
									
								<cfcase value="2" >
									
									#textAreaTag(
										name="attributevalue[#id#]",
										content=value,
										label=label,
										labelPlacement="before",
										class="textarea #req#")#
										
								</cfcase>
										
								<cfcase value="3" >
											
									#fileFieldTag(
										name="attributevalue[#id#]",
										label=label,
										labelPlacement="before",
										class="filefield #req#")#
										
								</cfcase>
										
								<!---<cfcase value="4" >
									#textFieldTag(
										name="attributevalue[#id#]",
										value=value,
										label=label,
										labelPlacement="before",
										class="input date_picker #required#",
										placeholder=attributename)#
										
									#hiddenFieldTag(
										name="attribute[#attributeid#]",
										value=id)#
											
								</cfcase>--->
										
								<!---<cfcase value="5" >
											
									#selectTag(
										name="proposalattributevalue[#id#]",
										options=VARIABLES['options' & attributeid],
										selected="#proposalattributevaluetext#",
										includeBlank=false,
										label=attributename,
										labelPlacement="before",
										class=required)#
									<!-- #proposalattributevaluetext# -->
								</cfcase>--->
										
							</cfswitch>
						</li>
					</cfloop>
				</ol>
				
			</cfcase> 
			
			<cfcase value="2">
				
				<div class="wrapper proposalform">
					<h4>Szczegółowe dane wniosku</h4>
					
					<ol class="concession-proposal-details">
						<li>
							<label>Imie i nazwisko wnioskodawcy</label>
							<span>#user.givenname# #user.sn#</span>
						</li>
						<li>
							<label>Nr sklepu</label>
							<span>#store.projekt#</span>
						</li>
						<li>
							<label>Data utworzenia wniosku</label>
							<span>#DateFormat(proposal.created, "dd.mm.yyyy")# r.</span>
						</li>
							<li>
							<label>Krok wniosku</label>
							<span>#proposal.concession_stepname.stepname#</span>
						</li>						
					</ol>
				</div>
				
				<div class="wrapper proposalform">
					<h4>Dokumenty do wypełnienia</h4>
					
					#startFormTag(action="accept-proposal", id="document-form")#
						
						#hiddenFieldTag(name="proposalid", value=proposal.id)#
						<cfif IsDefined("concession")>
							#hiddenFieldTag(name="proposal[concession]", value=concession.id)#
						</cfif>
						
						
						<ol id="concession-documents-list" class="concession-proposal-documents">
							
							<cfset flag = true />
							<cfloop query="documents">
								
								<cfif status neq 3 and type neq 3>
									<cfset flag = false /> 
								</cfif>
								<li>
									<div class="innerbox">
										<p><strong>Załącznik nr #type# do Instrukcji nr 3/2012/DF</strong></p>
										<p>
											Status:
											<cfswitch expression="#status#">
												<cfcase value="1">
													<span style="color:##ff0000">niewypełniony</span>
												</cfcase>
												<cfcase value="2">
													<span style="color:##e1e100">niedokończony</span>
												</cfcase>
												<cfcase value="3">
													<span style="color:##00b900">wypełniony</span>
												</cfcase>
											</cfswitch>
										</p>
										<p>Utworzony: #DateFormat(created, "dd.mm.yyyy")# r.</p>
									</div>
									
									<cfif proposal.step eq 1>
									
										<div class="actionbuttons">
											#linkTo(
												text=imageTag('concession-document-fill.png'),
												title="Wypełnij dokument",
												controller="Concessions",
												action="edit-document",
												key=id)#
										</div>
									</cfif>
									
									<cfif documents.status eq 3>
									
										<div class="actionbuttons">
											#linkTo(
												text=imageTag('concession-document-pdf.png'),
												title="Pobierz plik pdf",
												controller="Concessions",
												action="view-document",
												key=id)#
										</div>
									</cfif>
										
									<div style="clear:both;"></div>
								</li>
							</cfloop>
							
							<cfloop query="concession_documents">
								<cfif concession_documents.document_thumb neq ''>
									<li>
										<div class="innerbox">
											<p><strong>Załącznik: #concession_documents.document_name#</strong></p>
											<p>Utworzony: #DateFormat(concession_documents.created, "dd.mm.yyyy")# r.</p>
											<!---<p>
												<a href="files/folders/#concession_documents.document_src#">
													<img src="images/file-pdf.png" alt="pdf" />&nbsp;&nbsp;#concession_documents.document_name#
												</a>
											</p>--->
										</div>
										<div class="actionbuttons">
											#linkTo(
												text=imageTag('concession-document-pdf.png'),
												title="Pobierz plik pdf",
												href="files/folders/#concession_documents.document_src#")#
										</div>
										<div style="clear:both;"></div>
									</li>
								</cfif>
							</cfloop>
						</ol>
						
					#endFormTag()#
					
						<ol class="concession-proposal-documents">
							<li>
								<div class="innerbox">
									<p><strong>Dodatkowy załącznik:</strong></p>
								</div>
								<div style="clear:both;"></div>
									
								<cfform 
									action="#URLFor(controller='concessions',action='uploadFile')#" 
									id="fileuploadform" 
									method="post">
									<fieldset class="invoiceForm">
										<div class="_button">Wybierz plik
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
				</div>
				
				<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="dra">
					<cfinvokeargument name="groupname" value="Dział rozliczeń z Ajentami" />
				</cfinvoke>
							
				<cfif proposal.step gte 3 and dra is true>
						
					<div class="wrapper proposalform">
						<h4>Wniosek KOS'a</h4>
						
						<ol class="concession-proposal-form">						
							<cfloop query="attributefields">
								
								<li>
									<label>#name#</label> <span>#value#</span>
								</li>
								
							</cfloop>
						</ol>
					</div>
					
				</cfif>
				
				<div class="wrapper proposalform">
					
					<cfswitch expression="#proposal.step#">
						
						<cfcase value="1">
							
							<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
								<cfinvokeargument name="groupname" value="Partner prowadzący sklep" />
							</cfinvoke>
							
							<cfif pps is true>
								<cfif flag is true>
									#submitTag(value="Wyślij",class="smallButton redSmallButton sendProposal")#
								<cfelse>
									#submitTag(value="Wyślij",class="smallButton redSmallButton disableButton")#
								</cfif>
							</cfif>
							
						</cfcase>
						
						<cfcase value="2">
							
							<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="kos">
								<cfinvokeargument name="groupname" value="KOS" />
							</cfinvoke>
							
							<cfif kos is true>
								#submitTag(value="Akceptuj",class="smallButton redSmallButton accept1Proposal")#
								#submitTag(value="Odrzuć do poprawki",class="smallButton redSmallButton discard1Proposal")#
							</cfif>
							
						</cfcase>
						
						<cfcase value="3">
							<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="dra">
								<cfinvokeargument name="groupname" value="Dział rozliczeń z Ajentami" />
							</cfinvoke>
							
							<cfif dra is true>
								#submitTag(value="Akceptuj",class="smallButton redSmallButton accept2Proposal")#
							</cfif>
							
						</cfcase>
						
					</cfswitch>
				</div>
			</cfcase>
			
		</cfswitch>
	</div>
	
</cfoutput>
<!---<cfdump var="#concession_documents#" >--->
<script>
	$(function(){
		
		$(".disableButton").on("click", function(){
			
			alert("Wypełnij wszystkie dokumenty aby wysłać wniosek.");
			//$(this).attr("disabled", true);
			
			return false;			
		});
		
		$(".sendProposal,.accept2Proposal").on("click", function(){			
			
			$("#document-form").submit();
			return false;			
		});
		
		$(".accept1Proposal").on("click", function(){			
			
			if($("#proposal-concession").val() != 'undefined')
				document.location = <cfoutput>"#URLFor(controller='Concessions', action='verify-proposal')#"</cfoutput> + '&key=' + $("#proposal-concession").val();
			else
				alert('Błdny numer wniosku');
			//$("#document-form").submit();
			return false;			
		});
		
		$(".discard1Proposal").on("click", function(){			
			
			/*if($("#proposal-concession").val() != 'undefined')
				document.location = <cfoutput>"#URLFor(controller='Concessions', action='verify-proposal')#"</cfoutput> + '&key=' + $("#proposal-concession").val();
			else
				alert('Błdny numer wniosku');*/
			//$("#document-form").submit();
			return false;			
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
			url			: "<cfoutput>#URLFor(controller='concessions',action='uploadFile',key=params.key)#</cfoutput>",
			
			beforeSubmit: function(arr, $form, options){
				$("#fileprogressbar").show();
				timebox = setInterval( function(){ 
					progress( $("#fileprogressbar") ); 
				} ,100);
			},
			
			success: function (response, statusText, xhr, $form){
				
				clearInterval(timebox);
				$("#fileprogressbar").progressbar( "option", "value", 100 );
				
				var $name = $("<p><strong>Załącznik: "+ response.CFILENAME +"</strong></p>");
				var $date = $("<p>Utworzony: "+ response.CREATEDATE +" r.</p>");
				
				var $img = $("<img>")
					.attr("src", "images/concession-document-pdf.png")
					.attr("alt", "pdf")
					.attr("title", "Pobierz plik")
					.attr("target", "_blank");
					
				var $a = $("<a>")
					.attr("href", "files/folders/" + response.SFILENAME)
					.append($img);
				
				var $innerbox = $('<div>').addClass("innerbox")
					.append($name)
					.append($date);
				
				var $action = $("<div>").addClass("actionbuttons").add($a);
					
				var $li  = $('<li>').append($innerbox).append($action).hide();
				
				$("#concession-documents-list").first().append($li);
				
				$("#concession-documents-list").children().last().fadeIn();
				
				$("#fileprogressbar").slideUp();
				
			}
		});
		
		$(".documentinstancecontent").on("change", function(){

			time=0;
			
			$("#fileprogressbar").progressbar({ value: 0 });
			
			/*
			var ext = $(this).val().split(".");
			if( ext[ ext.length - 1 ] != 'xls' )
				alert('Nieprawidłowy format pliku! Wybierz plik *.xls');
			else
			*/
			
			$("#fileuploadform").submit();
		});
		
	});
</script>