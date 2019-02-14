<div class="wrapper courses">
	
	<h3>Lista kursantów przypisana do trenera</h3>
	
	<cfoutput>
		
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		</cfif>
		
		<cfif flashKeyExists("error")>
			<span class="error">#flash("error")#</span>
		</cfif>
		
		<!---<div class="wrapper formbox">
			#textFieldTag(name="student-search", label="Szukaj", labelPlacement="before")#
		</div>--->
		
		<table class="tables courses-table">
			<thead>
				<tr>
					<th>L.p.</th>
					<th><a href="##" class="student-sort" data-orderby="name" data-order="desc">Imię i nazwisko</a></th>
					<th>E-mail</th>
					<th>Telefon kontaktowy</th>
					<th>Termin szkolenia</th>
					<th>Rodzaj szkolenia</th>
					<th>Obecność na szkoleniu</th>
					<th></th>
				</tr>
			</thead>
			<tbody id="courses-table-tbody">
				
				<cfset counter = 0 />
				<cfloop query="students">
					<cfset counter++ />
					<tr>
						<td>#counter#</td>
						<td>#name#</td>
						<td><a href="mailto:#email#">#email#</a></td>
						<td>#phone#</td>
						<td>od <span class="strong">#DateFormat(datefrom, "yyyy-mm-dd")#</span> do <span class="strong">#DateFormat(dateto, "yyyy-mm-dd")#</span></td>
						<td>#coursetype['name'][type]#</td>
						<td class="tdcenter" data-lid="#lid#" data-sid="#sid#">
							<cfswitch expression="#presence#">
								<cfcase value="1">
									#imageTag(source="accept.png", alt="Stawił(a) się", class="", id="#CreateUUID()#")#
								</cfcase>
								<cfcase value="2">
									#imageTag(source="decline.png", alt="Nie stawił(a) się", class="", id="#CreateUUID()#")#
								</cfcase>
								<cfdefaultcase>
									#imageTag(source="questionmark.png", alt="Oczekuje", class="presence_confirm", id="#CreateUUID()#")#
								</cfdefaultcase>
							</cfswitch>
						</td>
						<td>
							<cfif _root is true>
								<cfset link_params="lid=#lid#&tid=#tid#" />
							<cfelse>
								<cfset link_params="lid=#lid#" />
							</cfif>
							
							<cfif presence eq 1>
								<a href="#URLFor(action='trainer-checklist', key=sid, params=link_params)#" class="vw_student" title="Lista tematów kandydata" data-active="true">
									#imageTag(source='icon-edit.png', alt='oceń kandydata', width='16', height='16')#
								</a>
							<cfelse>
								<a href="#URLFor(action='trainer-checklist', key=sid, params=link_params)#" class="vw_student" title="Lista tematów kandydata" data-active="false">
									#imageTag(source='icon-edit-gray.png', alt='oceń kandydata', width='16', height='16')#
								</a>
							</cfif>
							
						</td>
					</tr>
					
				</cfloop>
				
			</tbody>
		</table>
	</cfoutput>
</div>
<div id="dialog-confirm" title="Obecność na szkoleniu" style="display:none;">
	<p>Czy kandydat pojawił się na szkoleniu?</p>
</div>
<script>
	$(function() {
		$(".vw_student").on("click", function(event){
			$active = $(this).data("active");
			if($active == true){
				return true;
			} else {
				return false;
			}
		});
		
		$(".presence_confirm").click(function() {
			var uuid = $(this).prop("id");
			$("#dialog-confirm").data("uuid", uuid);
			
			$("#dialog-confirm").dialog("open");
		});
		
		$("#dialog-confirm").dialog({
			autoOpen: false,
			resizable: false,
			height: 140,
			modal: true,
			buttons: {
				"Tak": function() {
					var $dialog = $(this);
					var uuid = $("#dialog-confirm").data("uuid");
					$("#flashMessages").show();
					$.ajax({
						type: "GET",
						url: <cfoutput>"#URLFor(action='trainer-set-lesson-presence')#"</cfoutput>,
						data: {
							sid: $("#"+uuid).closest("td").data("sid"),
							lid: $("#"+uuid).closest("td").data("lid"),
							presence: 1
						},
						success: function(){
							$("#flashMessages").hide();
							$("#"+uuid).prop("src", "images/accept.png");
							$dialog.dialog("close");
						},
						error: function(){
							$("#flashMessages").hide();
							alert("Wystąpił błąd przy zapisywaniu. Spróbuj ponownie później.");
							$dialog.dialog("close");
						}
					});
				},
				"Nie": function() {
					var $dialog = $(this);
					var uuid = $("#dialog-confirm").data("uuid");
					$("#flashMessages").show();
					$.ajax({
						type: "GET",
						url: <cfoutput>"#URLFor(action='trainer-set-lesson-presence')#"</cfoutput>,
						data: {
							sid: $("#"+uuid).closest("td").data("sid"),
							lid: $("#"+uuid).closest("td").data("lid"),
							presence: 2
						},
						success: function(){
							$("#flashMessages").hide();
							$("#"+uuid).prop("src", "images/decline.png");
							$dialog.dialog("close");
						},
						error: function(){
							$("#flashMessages").hide();
							alert("Wystąpił błąd przy zapisywaniu. Spróbuj ponownie później.");
							$dialog.dialog("close");
						}
					});
				}
			}
		});
	});
</script>