<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pdsr_priv" >
	<cfinvokeargument name="groupname" value="Partner ds rekrutacji" />
</cfinvoke>

<div class="wrapper courses recruitment">
	
	<h3>Lista szkoleń</h3>
	
	<cfoutput>#includePartial("tabmenu")#</cfoutput>
	
	<cfif _root is true or _pdsr is true>
		<div class="intranet-backlink">
			<cfoutput><a href="#URLFor(action='add-candidate')#">Nowy kandydat</a></cfoutput>
		</div>
	</cfif>
	
	<cfoutput>
		
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		</cfif>
		
		<cfif flashKeyExists("error")>
			<span class="error">#flash("error")#</span>
		</cfif>
		
		<table class="tables courses-table recruitment-table">
				
			<thead>
				<tr>
					<th>L.p.</th>
					<th class="thsort">
						<span>Imię i nazwisko</span>
						<a class="searchparamlink navigate namesort" title="Sortuj" data-sort="desc" data-sortby="name" data-container="courses-table-tbody" href="##">#imageTag(source="sort-desc.png", height="12", width="15")#</a>
					</th>
					<th>Nr telefonu</th>
					<th>E-mail</th>
					<th class="thsort">
						<span>Miejscowość docelowa
							<!---<a class="searchparamlink navigate datesort" title="Sortuj "data-container="courses-table-tbody" href="##">#imageTag(source="sort-asc-desc.png", height="15", width="15")#</a>--->
						</span>
					</th>
					<th class="thsort">
						<span>PdsR</span>
					</th>
					<th>
						<span>Etap</span>
						<!---<a class="searchparamlink navigate namesort" title="Sortuj" data-sort="desc" data-sortby="step" data-container="courses-table-tbody" href="##">#imageTag(source="sort-desc.png", height="12", width="15")#</a>--->
					</th>
					<cfif pdsr_priv is true>
						<th class="tdstep">1</th>
						<th class="tdstep">2</th>
						<th class="tdstep">3</th>
						<th class="tdstep">4</th>
					</cfif>
					<th></th>
				</tr>
				<tr>
					<th colspan="4"></th>
					<th colspan="1" class="candidate-place">
						#selectTag(name="candidate-place", options=places, includeBlank="-- wszystkie --")#
					</th>
					<th colspan="1" class="candidate-recruiters">
						#selectTag(name="candidate-recruiters", options=recruiters, includeBlank="-- wszyscy --")#
					</th>
					<cfif pdsr_priv is true>
						<th colspan="6"></th>
					<cfelse>
						<th colspan="2"></th>
					</cfif>
				</tr>
			</thead>
			<tbody id="courses-table-tbody">
				#includePartial("recruitment")#
			</tbody>
		</table>
	</cfoutput>
	
	<div id="step_box_dialog" title="Etap rekrutacji" style="display:none;"></div>
</div>
<!---<cfdump var="#students#" />--->
<!---<cfdump var="#places#" />--->
<!---<cfdump var="#recruiters#" />--->

<script>
	$(function(){
		
		$(document).on("click", ".step_button img", function(e){
			if($(this).parent().hasClass("active_btn")){
				$("#flashMessages").show();
				$.get(
					<cfoutput>"#URLFor(action='recruitment-step')#"</cfoutput> + "&stepid=" + $(this).closest("td").data("stepid") + "&sid=" + $(this).closest("tr").data("sid"),
					function(data){
						$("#flashMessages").hide();
						$("#step_box_dialog").html(data).dialog("open");
					}
				);
			}
			return false;
		});
		
		$("#step_box_dialog").dialog({
			autoOpen: false,
			resizable: false,
			height: 350,
			width: 450,
			modal: true,
			buttons: {
				"Zapisz": function() {
					var $dialog = $(this),
						stepstatusid = typeof $dialog.find("#stepstatus").val() != "undefined" ? $dialog.find("#stepstatus").val() : $dialog.find("input[name=stepstatus]:checked").val(),
						params = {
							stepid: $dialog.find("#stepid").val(),
							studentid: $dialog.find("#studentid").val(),
							message: stepstatusid != 3 ? $dialog.find("#message").val() : $dialog.find("#discard").val(),
							statusid: stepstatusid,
							kosid: $dialog.find("#kosid").val()
						};
					recruitmentStatusUpdate(params, $dialog);
				}
			}
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
					
					window.location.href=<cfoutput>"#URLFor(action='recruitment')#"</cfoutput>;
				},
				error: function(){
					$("#flashMessages").hide();
					alert("Wystąpił błąd przy zapisywaniu. Spróbuj ponownie później.");
					$dialog.dialog("close");
				}
			});
		}
		
		var reload = function(placeid, pdsrid, sort, sortby){
			placeid = typeof placeid !== 'undefined' ? placeid : 0;
			pdsrid = typeof pdsrid !== 'undefined' ? pdsrid : 0;
			sort = typeof sort !== 'undefined' ? sort : 'asc';
			sortby = typeof sortby !== 'undefined' ? sortby : 'id';
			
			$("#flashMessages").show();
			$.ajax({
				type: "GET",
				url: <cfoutput>"#URLFor(action='recruitment')#"</cfoutput>,
				data: {
					placeid	: placeid, 
					pdsrid	: pdsrid,
					sortby	: sortby,
					sort	: sort
				},
				success: function(data){
					$("#flashMessages").hide();
					$("#courses-table-tbody").html(data);
				},
				error: function(){
					$("#flashMessages").hide();
					alert("Wystąpił błąd podczas pobierania danych. Spróbuj ponownie później.");
				}
			});
		}
		
		$("#candidate-place").on("change", function(){
			reload($(this).val(), 0);
		});
		
		$("#candidate-recruiters").on("change", function(){
			reload(0, $(this).val());
		});
		
		$(".navigate").on("click", function(e){
			e.preventDefault();
			
			var $img = $(this).find("img");
			var src = "/intranet/images/";
			
			var sortby = $(this).data("sortby");
			var sort = $(this).data("sort");
			
			if (sort == "asc") {
				$img.attr("src", src + "sort-desc.png");
				$(this).data("sort", "desc");
			} else if (sort == "desc") {
				$img.attr("src", src + "sort-asc.png");
				$(this).data("sort", "asc");
			}
			
			var place = $("#candidate-place").val();
			var pdsr = $("#candidate-recruiters").val();
			
			reload(place, pdsr, sort, sortby);
			
			return false;
		});
		
		$(".courses-table").on("mouseenter", ".thsort", function(){
			var idx = $(this).index() + 1;
			$(this).addClass("trhover");
			$("td:nth-child(" + idx + ")").addClass("trhover");
		});
		
		$(".courses-table").on("mouseleave", ".thsort", function(){
			var idx = $(this).index() + 1;
			$(this).removeClass("trhover");
			$("td:nth-child(" + idx + ")").removeClass("trhover");
		});
		
	});
</script>