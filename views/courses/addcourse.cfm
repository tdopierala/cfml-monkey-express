<div class="wrapper courses">
	
	<h3>Dodawanie nowego szkolenia</h3>
	<cfoutput>
		<form action="" method="post" id="course-form">
			
			<div class="wrapper formbox">
				<h4>Atrybuty szkolenia</h4>
	
				<ol>
					<li class="text-field">
						#textFieldTag(
							name="coursedatefrom",
							label="Data szkolenia", 
							labelPlacement="before", 
							class="input date_picker text-field-tag",
							placeholder="Data od")#
							
						#textFieldTag(
							name="coursedateto",
							class="input date_picker text-field-tag",
							placeholder="Data do")#
					</li>
					
					<li class="select-field">
						#selectTag(
							name="coursetype",
							options=coursetype,
							includeBlank="-- wybierz --",
							label="Typ szkolenia",
							labelPlacement="before",
							class="select-tag")#
					</li>
					
					<li class="text-field">
						#textFieldTag(
							name="courseplace",
							label="Miejsce szkolenia", 
							labelPlacement="before", 
							class="input text-field-tag",
							disabled="disabled")#
					</li>
				</ol>
				
			</div>
			
			<div class="wrapper proposalform" id="lessonsTemplate" style="display:none;"></div>
		
		</form>
	</cfoutput>
</div>
<script>
	$(function(){
		
		var t_timeout;
		var _options = {
			source	:
				function( request, response ) {
					clearTimeout(t_timeout);
					$img = $(document).find("#lessonsTemplate").find("#trainer").parent().find("img");
					$img.css("visibility","visible");
					
					t_timeout = setTimeout(function() {
						$.ajax({
							url			: <cfoutput>"#URLFor(action='get-user-to-courses')#"</cfoutput> + "&searchvalue=" + request.term,
							type		: "get",
							dataType	: "json",
							success		: function( data ) {
								response( $.map( data.DATA, function( item ) {
									if(item[1]===null) item[1]='';
									return {
										label: item[0] + " " + item[1],
										id: item[2]
									}
								}));
								
								$img.css("visibility","hidden");
							}
						});
					}, 500);
				}
			,minLength: 2
			,select: function( event, ui ) {
				$(document).find("#lessonsTemplate").find("#_trainer").data("userid", ui.item.id);
				$(document).find("#lessonsTemplate").find("#_trainer").data("username", ui.item.label);
			}
		};
		
		var _options_store = {
			source	:
				function( request, response ) {
					clearTimeout(t_timeout);
					
					t_timeout = setTimeout(function() {
						$.ajax({
							url			: <cfoutput>"#URLFor(controller='Store_stores',action='search')#"</cfoutput> + "&search=" + request.term + "&limit=15",
							type		: "get",
							dataType	: "json",
							success		: function( data ) {
								response( $.map( data.ROWS, function( item ) {
									return {
										label: item.PROJEKT + ", " + item.MIASTO.trim() + ", " + item.PPS,
										id: item.ID,
										ppsid: item.PPSID,
										pps: item.PPS
									}
								}));
							}
						});
					}, 500);
				}
			,minLength: 3
			,select: function( event, ui ) {
				$(document).find(".placeid").remove();
				$("#courseplace").after(
					$("<input>").addClass("placeid").attr("name","courseplaceid").attr("type","hidden").val(ui.item.id).data("username", ui.item.pps).data("userid", ui.item.ppsid)
				);
				
				var $td = $(document).find(".lesson-list tbody tr").last().children(".lesson-trainer");
				$td.children("span").html(typeof ui.item.pps != 'undefined' ? ui.item.pps : '&nbsp;');
				$td.children("input[name=trainername]").val(typeof ui.item.pps != 'undefined' ? ui.item.pps : '');
				$td.children("input[name=trainer]").val(typeof ui.item.ppsid != 'undefined' ? ui.item.ppsid : 0);
			}
		};
		
		$("#coursetype").on("change", function(){
			
			var _this = $(this).val();
			
			if(_this != 0) {
				
				$("#courseplace").attr("disabled", false).val('').autocomplete(_options_store);
				
				if (_this == 1) $("#courseplace").autocomplete({ disabled: true });
				if (_this == 2) $("#courseplace").autocomplete({ disabled: false });
				
				var url = "<cfoutput>#URLFor(action='get-course-lessons')#</cfoutput>" + "&key=" + _this; 
				$("#flashMessages").show();
				
				$.ajax({
					type	: 'GET',
					url		: url,
					dataType: "html",
					success	: function(data, status, xhr) {
							
						$(document).find("#lessonsTemplate").html(data).fadeIn();
						
						//var user = $(document).find("input[name=courseplaceid]"); 
						var $img = $("<img>").attr("src", "images/ajax-loader-2.gif").css("visibility","hidden");
						
						//typeof $user.data("userid") != 'undefined' ? $user.data("userid") : 0
						
						$(document).find("#lessonsTemplate").find("#_trainer").after($img);
						$(document).find("#lessonsTemplate").find("#_trainer").autocomplete(_options);
						
						/*if (_this == 2) {
							var $td = $(document).find(".lesson-list tbody tr").last().children(".lesson-trainer");
							$td.children("span").html(typeof user.data("username") != 'undefined' ? user.data("username") : '&nbsp;');
							$td.children("input[name=trainername]").val(typeof user.data("username") != 'undefined' ? user.data("username") : '');
							$td.children("input[name=trainer]").val(typeof user.data("userid") != 'undefined' ? user.data("userid") : 0);
						}*/
									
						$("#flashMessages").hide();
					},
					error: function(){
						$("#flashMessages").hide();
						alert("Błąd połączenia. Spróbuj ponownie.");
					}
				});
			} else {
				$(document).find("#lessonsTemplate").fadeOut().empty();
				$("#courseplace").val('');
				$("#courseplace").attr("disabled", true);
			}
			
			return false;
		});
		
		$('#course-form').ajaxForm({
			dataType	: 'json',
			type		: 'post',
			url			: "<cfoutput>#URLFor(action='add-course-action')#</cfoutput>",
			beforeSubmit: function() {
				
				var error=false;
				var datefrom = $("#coursedatefrom").val();
				var dateto = $("#coursedateto").val();
				var place = $("#courseplace").val();
				
				$(".error-msg").remove();
				
				if(datefrom=='' || dateto=='') {					
					$("#coursedatefrom").parent().append( 
						$("<span>").addClass("error-msg").html('&laquo; Podaj datę szkolenia. Pole wymagane!').fadeIn());
					error = true;
				}
				
				if(place=='') {
					$("#courseplace").parent().append(
						$("<span>").addClass("error-msg").html('&laquo; Pole "Miejsce szkolenia" jest wymagane!').fadeIn());
					error = true;
				}
				
				if (error) {
					$("#flashMessages").hide();
					return false;
				}
				
			},
			success: function (responseText, statusText, xhr, $form){
				console.log(responseText);
				$("#flashMessages").hide();
				document.location="<cfoutput>#URLFor(controller='courses',action='index')#</cfoutput>";
			}
		});
		
		$(document).on("click", ".remove-lesson", function(){
			$(this).closest("tr").remove();
		});
		
	});
</script>