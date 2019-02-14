<div class="wrapper courses">
	
	<h3><cfoutput>#student.name#</cfoutput></h3>
	
			<!---<cfif student.place eq ''>
				<cfset _place = "--" />
			<cfelse>
				<cfset _place = student.place />
			</cfif>--->
			
			<cfif student.nip eq ''>
				<cfset _nip = "--" />
			<cfelse>
				<cfset _nip = student.nip />
			</cfif>
	
	<cfoutput>
		<div class="intranet-backlink">
			<a href="#URLFor(action='students')#">Lista kandydatów</a>
		</div>
		
		<div class="wrapper formbox">
			
			<div class="student-avatar">
				#imageTag("avatars/monkeyavatar.png")#
				
				<div class="student-options">
					#linkTo(text="Edycja kandydata", action="edit", key=params.key)#
				</div>
			</div>
			
			<div class="student-details-box">
				<ol class="student-details">
					<li>
						<label>Imię i nazwisko</label>
						<span>#student.name#</span>
					</li>
					<li>
						<label>Identyfikator kandydata</label>
						<span>#student.studentid#</span>
					</li>
					<li>
						<label>E-mail</label>
						<span>#student.email#</span>
					</li>
					<li>
						<label>Nr telefonu</label>
						<span>#student.phone#</span>
					</li>
					<li>
						<label>Pesel</label>
						<span>#student.pesel#</span>
					</li>
					<!---<li>
						<label>Nr dowodu</label>
						<span>#student.docid#</span>
					</li>--->
					<li>
						<label>Skan dowodu</label>
						<cfif student.docidscan neq ''>
							<span><a href="files/courses/#student.docidscan#">#student.docidscan#</a></span>
						<cfelse>
							<span>--</span>
						</cfif>
					</li>
					<li>
						<label>Nip</label>
						<span>#student.nip#</span>
					</li>
					<li>
						<label>Regon</label>
						<span>#student.regon#</span>
					</li>
					<li>
						<label>Miejscowość docelowa</label>
						<span>#student.place#</span>
					</li>
					
					<li>
						<label>Plik CV</label>
						<cfif student.cv neq ''>
							<span><a href="files/courses/#student.cv#">#student.cv#</a></span>
						<cfelse>
							<span>--</span>
						</cfif>
					</li>
					
				</ol>
			</div>
			
			<div style="clear:both"></div>
		</div>
		
		<!---<cfif IsDefined("user")>
			<cfdump var="#user#" >
		</cfif>--->
		
		<!---<div class="wrapper formbox">
			<h4>Szczegóły wniosku</h4>
			
			<cfif IsDefined("proposal")>
				<div class="proposalpreview">
					<ol>
						<cfloop query="proposal">
							<cfif attributetypeid eq 3>
								<cfif proposalattributevaluetext neq ''>
									<li>
										<span>#attributename#</span>
										<a href="./files/proposals/#proposalattributevaluetext#">
											<cfset ext = Trim(ListLast(proposalattributevaluetext, ".")) />
											<cfswitch expression="#ext#">
												<cfcase value="pdf" >
													<img src="./images/file-pdf.png" alt="#proposalattributevaluetext#" /> #proposalattributevaluetext#
												</cfcase>
												<cfcase value="doc" >
													<img src="./images/file-word.png" alt="#proposalattributevaluetext#" /> #proposalattributevaluetext#
												</cfcase>
												<cfcase value="docx" >
													<img src="./images/file-word.png" alt="#proposalattributevaluetext#" /> #proposalattributevaluetext#
												</cfcase>
													
												<cfdefaultcase>
													<img src="./images/blank.png" alt="#proposalattributevaluetext#" /> #proposalattributevaluetext#
												</cfdefaultcase>
											</cfswitch>
										</a>
									</li>
								</cfif>
							<cfelse>
								
								<cfif Len(Trim(proposalattributevaluetext)) eq 0>
									<li><span>#attributename#</span>--</li>
								<cfelse>
									<li><span>#attributename#</span>#proposalattributevaluetext#</li>
								</cfif>
								
							</cfif>
						</cfloop>
					</ol>
				</div>
			</cfif>
		</div>--->
		
		<div class="wrapper formbox">
			<h4>Odbyte szkolenia</h4>
			
			<ol class="student-course-list">
				<cfloop query="courses">
					
					<li>
						<span class="course-type">#capitalize(typename)#</span>
						<span class="course-date">#DateFormat(date, "yyyy-mm-dd")#</span>
						<span class="course-place">#place#</span>
						<span>
							#linkTo(
								text="Karta ocen",
								class="student_card",
								controller="Courses",
								action="gradebook",
								params="cid=#id#&sid=#student.id#")#
						</span>
						<div style="clear:both"></div>
					</li>
					
				</cfloop>
			</ol>
		</div>
	</cfoutput>
	
</div>

<div id="student-card-form" title="Karta ocen" style="display:none"></div>

<script>
	$(function(){
		
		$("#student-card-form").dialog({
			autoOpen: false,
			height: 700,
			width: 900,
			modal: true,
			Cancel: function() {
				$(this).dialog("close");
			}
		});
		
		$(".student_card").on("click", function(){
			$this = $(this);
			
			$("#flashMessages").show();
			
			$.get(
				$this.attr("href"),
				function(data){
					$("#student-card-form").html(data);
					$("#flashMessages").hide();
					$("#student-card-form").dialog("open");
				}
			);
			
			return false;
		});
		
	});
</script>