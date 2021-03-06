<cfoutput>
	
	<div class="wrapper">
		<h3>Redmine</h3>
		
		<div id="redmine" class="wrapper">
			
			<div id="redmine_issues" class="left_block redmine">
				<h5>Zadania przypisane do mnie</h5>
				
				<div class="ajax"></div>
				
				<cfif Len(session.user.redmineapikey)>
					<div class="ajax_loader">
						#imageTag(source="ajax-loader-3.gif")#
					</div>
				<cfelse>
					<div class="information">
						W celu integracji musisz wprowadzić klucz ApiKey.
					</div>
				</cfif>
				
			</div>
		
			<div id="redmine_news" class="right_block redmine">
				<h5>Ostatnie komunikaty</h5>
				
				<div class="ajax"></div>
				
				<cfif Len(session.user.redmineapikey)>
					<div class="ajax_loader">
						#imageTag(source="ajax-loader-3.gif")#
					</div>
				<cfelse>
					<div class="information">
						W celu integracji musisz wprowadzić klucz ApiKey.
					</div>
				</cfif>
			</div>
		
			<div class="clear"></div>
		
			<div id="redmine_ajax" class="both_block redmine">
				
				<div class="ajax_loader" style="display: none;">
					#imageTag(source="ajax-loader-3.gif")#
				</div>
				
				<div class="ajax"></div>
				
			</div>
	
		</div>
		
	</div>
	
</cfoutput>


<cfif Len(session.user.redmineapikey) and Len(session.user.redmineid)>

<script>
$(function() {
	<!---
		Pobieram komunikaty ze wszystkich projektów.
	--->
	$.ajax({
		type			:		"get",
		dataType		:		"JSONP",
		url				:		"<cfoutput>#get('loc').redmine.url#/news.json?key=#session.user.redmineapikey#&callback=?</cfoutput>",
		success			:		function(data) {
			var HTMLresult = "<table class=\"redmine_table\">" 
				+ "<thead>"
				+ "<tr>"
				+ "<th class=\"first leftBorder topBorder bottomBorder\">#</td>"
				+ "<th class=\"leftBorder topBorder bottomBorder\">Projekt</th>"
				+ "<th class=\"leftBorder topBorder bottomBorder\">Autor</th>"
				+ "<th class=\"leftBorder topBorder bottomBorder\">Treść</th>"
				+ "<th class=\"leftBorder rightBorder topBorder bottomBorder\">Dodano</th>"
				+ "</tr>"
				+ "</thead>"
				+ "<tbody>";
			$.each(data.news, function(index, value) {
				var date = new Date(value.created_on);
				HTMLresult += "<tr>"
					+ "<td class=\"leftBorder bottomBorder\">" + value.id + "</td>"
					+ "<td class=\"leftBorder bottomBorder\">" + value.project.name + "</td>"
					+ "<td class=\"leftBorder bottomBorder\">" + value.author.name + "</td>"
					+ "<td class=\"leftBorder bottomBorder\">" + value.summary + "</td>"
					+ "<td class=\"leftBorder rightBorder bottomBorder\">" + value.created_on + "</td>"
					<!---+ "<td class=\"leftBorder rightBorder bottomBorder\">" + date.format("d-m-Y H:i") + "</td>"--->
					+ "</tr>";
			});
			HTMLresult += "</tbody>"
				+ "</table>";
				
			$("#redmine_news .ajax").html(HTMLresult);
			$("#redmine_news .ajax_loader").hide();
		}
	});
	<!---
		Koniec pobieranie komunikatów. 
	--->
	<!---
		Pobieram teraz zagadnienia użytkownika.
	--->
	$.ajax({
		type			:		"get",
		dataType		:		"JSONP",
		url				:		"<cfoutput>#get('loc').redmine.url#/issues.json?key=#session.user.redmineapikey#&assigned_to_id=#session.user.redmineid#&callback=?</cfoutput>",
		success			:		function(data) {
			var HTMLresult = "<table class=\"redmine_table\">"
				+ "<thead>"
				+ "<tr>"
				+ "<th class=\"first leftBorder topBorder bottomBorder\">#</th>"
				+ "<th class=\"c leftBorder topBorder bottomBorder\">Projekt</th>"
				+ "<th class=\"c leftBorder topBorder bottomBorder\">Typ zagadnienia</th>"
				+ "<th class=\"c leftBorder topBorder bottomBorder\">Temat</th>"
				+ "<th class=\"c leftBorder topBorder bottomBorder rightBorder\">%</th>"
				+ "</tr>"
				+ "</thead>"
				+ "<tbody>";
				
			$.each(data.issues, function(index, value) {
				HTMLresult += "<tr>"
					+ "<td class=\"c leftBorder bottomBorder\"><a href=\"<cfoutput>#get('loc').redmine.url#</cfoutput>/issues/" + value.id + ".json?key=<cfoutput>#session.user.redmineapikey#</cfoutput>\" class=\"redmine_ajax_issue\">" + value.id + "</a></td>"
					+ "<td class=\"c leftBorder bottomBorder\">" + value.project.name + "</td>"
					+ "<td class=\"c leftBorder bottomBorder\">" + value.tracker.name + "</td>"
					+ "<td class=\"c leftBorder bottomBorder\">" + value.subject + "</td>"
					+ "<td class=\"c leftBorder rightBorder bottomBorder\"><span class=\"redmine_progress\"><span class=\"redmine_progress_ratio\" style=\"width:" + value.done_ratio + "%;\">&nbsp;</span></span></td>"
					+ "</tr>";
			});
			HTMLresult += "</tbody>"
				+ "</table>";
				
			$("#redmine_issues .ajax").html(HTMLresult);
		 	$("#redmine_issues .ajax_loader").hide();
		}
	});
	<!---
		Koniec pobierania zagadnień
	--->
	<!---
		Obsługa linków
	--->
	$('.redmine_ajax_issue').live('click', function(e) {
		e.preventDefault();
		
		$("#redmine_ajax .ajax_loader").show();
		
		
		$.ajax({
			type		:		'get',
			dataType	:		'JSONP',
			url			:		$(this).attr('href'),
			success		:		function(data) {
				var HTMLresult = "<h4># " + data.issue.id + " " + data.issue.subject + "</h4>"
					+ "<div class=\"issue_summary\">"
					+ "<h5>Dodane przez " + data.issue.author.name + " dnia " + data.issue.created_on + "</h5>"
					+ "<ul class=\"issue_summary_list\">"
					+ "<li><span>Status</span>" + data.issue.status.name + "</li>"
					+ "<li><span>Start</span>" + data.issue.start_date + "</li>"
					+ "<li><span>Priorytet</span>" + data.issue.priority.name + "</li>"
					+ "<li><span>Data oddania</span>" + data.issue.due_date + "</li>"
					+ "<li><span>Przydzielony do</span>" + data.issue.assigned_to.name + "</li>"
					+ "<li><span>% wykonania</span><span class=\"redmine_progress_big\"><span class=\"redmine_progress_ratio_big\" style=\"width:" + data.issue.done_ratio + "%;\">&nbsp;</span></span></li>"
					+ "<li><span>Projekt</span>" + data.issue.project.name + "</li>"
					+ "</ul>"
					+ "<div class=\"clear\"></div>"
					+ "<h5>Opis</h5>"
					+ data.issue.description
					+ "</div>";
				$("#redmine_ajax .ajax").html(HTMLresult);
		 		$("#redmine_ajax .ajax_loader").hide();
			}
		});
	});
	<!---
		Koniec obsługi linków
	--->
});
</script>
</cfif>