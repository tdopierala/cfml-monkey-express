<div class="wrapper courses">
	
	<h3>Podgląd szkolenia</h3>
	<cfoutput>
		
			<div class="intranet-backlink">
				#linkTo(
					text="&laquo; powrót do: Lista szkoleń",
					controller="Courses",
					action="index")#
			</div>
		
			<div class="wrapper proposalform">
				<h4>Atrybuty szkolenia</h4>
				
				<cfif IsStruct(course)>
				
					<ol>
						<li class="text-field">
							<label>Data szkolenia</label>
							<span>od <strong>#DateFormat(course.datefrom, "yyyy-mm-dd")#</strong> do <strong>#DateFormat(course.dateto, "yyyy-mm-dd")#</strong></span>
						</li>
						
						<li class="text-field">
							<label>Miejsce szkolenia</label>
							<span>#course.place#</span>
						</li>
						
						<li class="select-field">
							<label>Typ szkolenia</label>
							
							<cfswitch expression="#course.typeid#">
								
								<cfcase value="1">
									<span>teoretyczne</span>
								</cfcase>
								
								<cfcase value="2">
									<span>praktyczne</span>
								</cfcase>
								
							</cfswitch>
						</li>
					</ol>
					
				</cfif>
				
			</div>
			
			<cfif IsDefined("lessons")>
				<div class="wrapper proposalform">
					<h4>Lista zajęć</h4>
					
					<ol class="add-lesson-list">
						<cfloop query="lessons">
							<li>
								<span class="lesson-subject">
									#subject#
								</span>
								<span class="lesson-trainer">
									prowadzący: <strong>#givenname# #sn#</strong>
								</span>
								<span class="lesson-dates">
									<cfif course.typeid neq 2>
										<strong>#DateFormat(date, "yyyy-mm-dd")#</strong> od <strong>#TimeFormat(timefrom, "HH:mm")#</strong> do <strong>#TimeFormat(timeto, "HH:mm")#</strong>
									</cfif>
								</span>
							</li>
						</cfloop>
					</ol>
				
				</div>
				
				<div class="wrapper proposalform" id="students-list">
					<h4>Lista uczestników</h4>
					
					<span>
						<a 
							href="#URLFor(controller='Courses',	action='assign-student', params='cid=#params.key#')#"
							title="Dodaj uczestnika"
							class="add_student navigate"
							data-source="student-add-form">
								
							#imageTag(source="plus.png", alt="dodaj uczestnika")#
						</a>
					</span>
					
					<div style="clear:both;"></div>
					
					<table class="students-table">
						<tbody>
							<cfloop query="students">
								<tr>
									<td class="student" data-sid="#studentid#" data-cid="#params.key#">
										<span>#name#</span>
									</td>
									
									<td class="student-action">
										<span>
											<a 
												href="#URLFor(controller='Courses',	action='move')#"
												title="Przeniesienie na inne szkolenie"
												class="mv_student navigate"
												data-source="mv-student-form">
													
												#imageTag(source="import_from_internet.png", alt="przeniesienie na inne szkolenie")#
											</a>
										</span>
									</td>
																		
									<td class="student-action">
										<span>
											#linkTo(
												text=imageTag(source="materials.png", alt="profil kandydata", width="16", height="16"),
												title="Profil kandydata",
												class="vw_student",
												controller="Courses",
												action="profile",
												key=studentid)#
										</span>
									</td>
									
									<td class="student-action">
										<span>
											<a 
												href="#URLFor(controller='Courses', action='gradebook', params='cid=#params.key#&sid=#studentid#')#"
												title="Karta ocen"
												class="student_card navigate"
												data-source="student-card-form">
													
												#imageTag(source="invoice.png", alt="karta ocen")#
											</a>
										</span>
									</td>
									
									
									<cfquery dbtype="query" name="trainer"> 
										SELECT trainer as id, givenname, sn FROM lessons 
										WHERE trainer = <cfqueryparam value="#session.user.id#" cfsqltype="cf_sql_integer">
									</cfquery>
									
									<cfif trainer.id eq session.user.id>
										<td class="student-action">
											<span>
												<a 
													href="#URLFor(controller='Courses', action='rate', params='cid=#params.key#&sid=#studentid#')#"
													title="Wystaw ocene"
													class="rate_card navigate"
													data-source="rate-card-form">
														
													#imageTag(source="tip.png", alt="wystaw ocene")#
												</a>
											</span>
										</td>
									</cfif>
								</tr>
							</cfloop>
						</tbody>
					</table>
					
				</div>
				
			</cfif>
	</cfoutput>
</div>

<div id="mv-student-form" title="Przeniesienie na inne szkolenie" style="display:none"></div>
<div id="student-card-form" title="Karta ocen" style="display:none"></div>
<div id="rate-card-form" title="Karta oceny" style="display:none"></div>
<div id="student-add-form" title="Dodaj nowego uczestnika szkolenia" style="display:none"></div>

<!---<cfdump var="#courses#">--->

<script>
	$(function(){
		$("#mv-student-form").dialog({
			autoOpen: false,
			height: 400,
			width: 500,
			modal: true,
			buttons: {
				"Wyślij": function() {
					
					var studentid = $("#mv-student-form").find(".move-form").data("sid");
					var newcourseid = $("#mv-student-form").find("#courseid").val();
					var oldcourseid = $("#mv-student-form").find(".move-form").data("ocid");
					
					$.ajax({
						type: "GET",
						url: <cfoutput>"#URLFor(action='moveAction')#"</cfoutput>,
						data: { sid : studentid, cid : newcourseid, ocid : oldcourseid },
						dataType: "json",
						success: function(){
							$(".students-table").find("tr").each(function(idx){
								var sid = $(this).find("td:first-child").data("sid");
								
								if(sid == studentid) {
									$(this).remove();
								}
							});
						},
						error: function(){
							alert("Operacja przenoszenie kandydata na inny kurs nie powidła się.");
						}
					});
					
					$(this).dialog("close");
				}
			},
			Cancel: function() {
				$(this).dialog("close");
			}
		});
		
		$("#student-card-form").dialog({
			autoOpen: false,
			height: 700,
			width: 900,
			modal: true,			
			Cancel: function() {
				$(this).dialog("close");
			}
		});
		
		$("#rate-card-form").dialog({
			autoOpen: false,
			height: 700,
			width: 700,
			modal: true,
			buttons: {
				"Zapisz" : function() {
					
					var $dialog = $(this);
					
					var form = {};
					$(".rate-list").each(function(){
						
						var name = $(this).find("input:checked").attr("name");
						var value = $(this).find("input:checked").val();						
						form[name] = value;
					});
					
					$(".textarea").each(function(){
						
						var name = $(this).attr("name");
						var value = $(this).val();						
						form[name] = value;
					});
					
					$(".lessons").find("input[type=hidden]").each(function(){
						
						var name = $(this).attr("name");
						var value = $(this).val();						
						form[name] = value;
					});
					
					//console.log(form);
					//alert($("#update-time").length);
					
					if(parseInt($("#update-time").text()) > 0 || $("#update-time").length == 0){
					
						$.ajax({
							type: "POST",
							url: <cfoutput>"#URLFor(controller='Courses',action='rateAction')#"</cfoutput>,
							data: form,
							success: function(){
								
								$dialog.dialog("close");							
							},
							error: function(){
								alert("Wystąpił błąd przy zapisywaniu ocen. Spróbuj ponownie później.");
								$dialog.dialog("close");
							}
						});
					} else {
						
						$dialog.dialog("close");
					}
				}
			},
			Cancel: function() {
				$(this).dialog("close");
			}
		});
		
		$("#student-add-form").dialog({
			autoOpen: false,
			height: 300,
			width: 350,
			modal: true,
			buttons: {
				"Zapisz" : function() {
					
					var studentid = $("#student-add-form").find("#sid").val();
					var courseid = $("#student-add-form").find("#cid").val();
					
					$.ajax({
						type: "GET",
						url: <cfoutput>"#URLFor(controller='Courses',action='assignStudentAction')#"</cfoutput>,
						data: { sid : studentid, cid : courseid },
						dataType: "json",
						success: function(){
							
							$(".students-table").find("tbody").append(
								$("<tr>").append(
									$("<td>")
										.addClass("student")
										.data("sid", studentid)
										.data("cid", courseid)
										.append(
											$("<span>").text(
												$("#student-add-form").find("#sid option:selected").text())))
								.append(
									$("<td>")
										.addClass("student-action")
										.append(
											$("<span>").append(
												$("<a>")
													.addClass("mv_student navigate")
													.data("source", "mv-student-form")
													.attr("href",<cfoutput>"#URLFor(controller='Courses', action='move')#"</cfoutput>)
													.attr("title", "Przeniesienie na inne szkolenie")
													.append(
														$("<img>").attr("src","/intranet/images/import_from_internet.png").attr("alt", "przeniesienie na inne szkolenie")))))
								.append(
									$("<td>")
										.addClass("student-action")
										.append(
											$("<span>").append(
												$("<a>")
													.addClass("vw_student")
													.attr("href",<cfoutput>"#URLFor(controller='Courses', action='profile')#"</cfoutput> + "&key=" + studentid)
													.attr("title", "Profil kandydata")
													.append(
														$("<img>").attr("src","/intranet/images/materials.png").attr("alt", "profil kandydata").attr("width", 16).attr("height", 16)))))
								.append(
									$("<td>")
										.addClass("student-action")
										.append(
											$("<span>").append(
												$("<a>")
													.addClass("student_card navigate")
													.attr("href",<cfoutput>"#URLFor(controller='Courses', action='gradebook')#"</cfoutput> + "&cid=" + courseid + "&sid=" + studentid)
													.attr("title", "Karta ocen")
													.data("source", "student-card-form")
													.append(
														$("<img>").attr("src","/intranet/images/invoice.png").attr("alt", "karta ocen")))))
								/*.append(
									$("<td>")
										.addClass("student-action")
										.append(
											$("<span>").append(
												$("<a>")
													.addClass("rate_card navigate")
													.attr("href",<cfoutput>"#URLFor(controller='Courses', action='rate')#"</cfoutput> + "&cid=" + courseid + "&sid=" + studentid)
													.attr("title", "Wystaw ocenę")
													.data("source", "rate-card-form")
													.append(
														$("<img>").attr("src","/intranet/images/tip.png").attr("alt", "wystaw ocenę")))))*/
							);
						},
						error: function(){
							alert("Operacja dodawania kandydata nie powidła się.");
						}
					});
					
					$(this).dialog("close");
				}
			},
			Cancel: function() {
				$(this).dialog("close");
			}
		});
		
		$("#students-list").on("click", ".navigate", function(){
			var $this = $(this);
			var source = $this.data("source");
			
			var url =  $this.attr("href");
			
			if ($this.hasClass("mv_student")) {
				var sid = $this.closest("td").prev().data("sid");
				var cid = $this.closest("td").prev().data("cid");
				
				url = url + "&sid=" + sid + "&cid=" + cid;
				console.log(url);
			}
			
			$("#flashMessages").show();
			
			$.get(
				url,
				function(data){
					$("#"+source).html(data);
					$("#flashMessages").hide();
					$("#"+source).dialog("open");
				}
			);
			
			return false;
		});
		
	});
</script>