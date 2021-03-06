<div class="wrapper courses">
	
	<h3>Stan rekrutacji</h3>
	
	<cfoutput>#includePartial("tabmenu")#</cfoutput>
	
	<cfoutput>
		
		<div class="intranet-backlink">
			<cfoutput><a href="#URLFor(action='locationAdd')#">Dodaj nowy</a></cfoutput>
		</div>
		
		<cfif flashKeyExists("success")>
	    	<span class="success">#flash("success")#</span>
		</cfif>
		
		<table class="tables locations-table locations">
			<thead>
				<tr>
					<th class="thlp">L.p.</th>
					<th class="thprojekt thsort">
						<span>Projekt</span>						
						<a class = "searchparamlink navigate projekt" 
							title = "Sortuj " 
							data-container = "courses-table-tbody" 
							href = "#URLFor(action='locations', params='page=1&orderby=projekt&order=#order#')#">
								#imageTag("sort-asc-desc2.png")#
						</a>
					</th>
					<!---<th>Kod poczt.</th>--->
					<th class="thadress thsort">
						<span>Adres</span>
						<a class = "searchparamlink navigate city" 
							title = "Sortuj " 
							data-container = "courses-table-tbody" 
							href = "#URLFor(action='locations', params='page=1&orderby=city&order=#order#')#">
								#imageTag("sort-asc-desc2.png")#
						</a>
					</th>
					<th class="thstudent">Kandydat na PPS</th>
					<th title="Data przęjcia sklepu" class="thdate thsort">
						<span>Data</span>
						<a class = "searchparamlink navigate planneddate" 
							title = "Sortuj " 
							data-container = "courses-table-tbody" 
							href = "#URLFor(action='locations', params='page=1&orderby=planneddate&order=#order#')#">
								#imageTag("sort-asc-desc2.png")#
						</a>
					</th>
					<!---<th>E-mail</th>--->
					<!---<th>Nr telefonu</th>--->
					<th class="thcourses">Szkolenia</th>
					<th class="thbep">BEP (zł)</th>
					<th class="thcontract">Umowa</th>
					<th class="thasseco">Asseco</th>
					<th class="thds" title="Data przekazania do Departamentu Sprzedaży">DS</th>
					<th class="thoptions"></th>
				</tr>
				<tr>
					<th></th>
					<th>#textFieldTag(name="s_project", class="loc_filter text_filter s_project")#</th>
					<th>#textFieldTag(name="s_adress", class="loc_filter text_filter s_adress")#</th>
					<th>#textFieldTag(name="s_student", class="loc_filter text_filter s_student")#</th>
					<th></th>
					<th></th>
					<th></th>
					<th>#selectTag(name="s_contract", options=contractstatus, includeBlank="-- wszystkie --", class="loc_filter s_contract")#</th>
					<th></th>
					<th></th>
					<th></th>
				</tr>
			</thead>
			<tbody id="courses-table-tbody">
				<!---#includePartial("locations")#--->
			</tbody>
		</table>
		
	</cfoutput>
	
	<div id="location-edit" title="Edycja rekrutacji" style="display:none"></div>
	<div id="location-confirm" title="Stan rekrutacji" style="display:none"></div>
</div>	
<!---<cfdump var="#locations#">--->
<!---<cfdump var="#courses#">--->
<script>
	$(function(){
		
		//delete localStorage.courseloc_sort;
		
		urlbase = '<cfoutput>#URLFor(action="locations")#</cfoutput>';
		
		if (typeof(localStorage.courseloc_sort) != 'undefined') {			
			param = JSON.parse(localStorage.getItem('courseloc_sort'));
			
			url = urlbase + '&' + Object.keys(param).map(function(key){ 
				return key + '=' + param[key]; 
			}).join('&');
			
			if(typeof(param.contract) != 'undefined')
				$("#s_contract").find("option").each(function(){
					if($(this).attr("value") == param.contract)
						$(this).attr("selected", true);
				});
				
			setNavigate(param);
				
		} else {			
			url = urlbase;
		}
		
		get_table_rows(url);
		
		function get_table_rows(url){
			
			var ls = window['localStorage'];
			var j_param;
			var params = url.split("?");
			var _params = params[1].split("&");			
			
			var param_tab = {};
			
			for(i=0; i<_params.length; i++){
				var tmp = _params[i].split("=");
				
				if(tmp[1] != '')
					param_tab[tmp[0]] = tmp[1];
			}
			
			for(key in param_tab)
				if(key != "orderby" && key != "order" && key != "page" && key != "amount" && key != "contract" && key != "projekt" && key != "adress" && key != "student")
					delete param_tab[key];
					
			delete ls['courseloc_sort'];
					
			ls.setItem('courseloc_sort', JSON.stringify(param_tab));
			j_param = param_tab;
			
			$("#flashMessages").show();
			
			$.ajax({
				type: 'GET',
				url: '<cfoutput>#URLFor(action="locations")#</cfoutput>',
				data: j_param,
				dataType: "html",				
				success: function(data, status, xhr){				
					$("#courses-table-tbody").html(data);					
					$("#flashMessages").hide();
				},				
				error: function(){				
					alert("Pobranie danych nie powiodło się. Spróbuj ponownie później.");
					$("#flashMessages").hide();					
				}
			});
		}
		
		function setNavigate(param){
			
			$(".navigate").each(function(){
				
				var orderby = param.orderby;
				$img = $(this).find("img");
				src = "/intranet/images/";
				
				if($(this).hasClass(param.orderby)){
					
					if (param.order == 'asc') $img.attr("src", src + "sort-asc2.png");
					else $img.attr("src", src + "sort-desc2.png");
					
					url = urlbase + '&' + Object.keys(param).map(function(key){ 
						return encodeURIComponent(key) + '=' + encodeURIComponent(param[key]); 
					}).join('&');
				
					$(this).attr("href", url);
				}
			});
		}
		
		$(".locations-table").on("click", ".navigate", function(){
			
			var url = $(this).attr("href");
			var $img = $(this).find("img");
			var src = "/intranet/images/";
			
			$(".navigate").find("img").attr("src", src + "sort-asc-desc2.png");
			
			if (url.indexOf("asc") > 0) {
				$img.attr("src", src + "sort-desc2.png");
				$(this).attr("href", url.replace("asc", "desc"));
			}
			
			if (url.indexOf("desc") > 0) {
				$img.attr("src", src + "sort-asc2.png");
				$(this).attr("href", url.replace("desc", "asc"));
			}
			
			get_table_rows(url);
			
			return false;
		});
		
		$(".locations-table").on("change", ".s_contract", function(){
			
			var param = JSON.parse(localStorage.getItem('courseloc_sort'));
			param.contract = $(this).val();
			
			setNavigate(param);
			
			var url = Object.keys(param).map(function(key){ 
				return encodeURIComponent(key) + '=' + encodeURIComponent(param[key]); 
			}).join('&');
			
			get_table_rows('<cfoutput>#URLFor(action="locations")#</cfoutput>&' + url);
			
			return false;
		});
		
		var timeout;
		$(".locations-table").on("keyup", ".text_filter",function(){
			
			var _this = $(this);
			
			var param = JSON.parse(localStorage.getItem('courseloc_sort'));
			
			if( _this.val().length == 0 ){
				
				$("#flashMessages").show();
				clearTimeout(timeout);
				
				timeout = setTimeout(function(){
					
					if(_this.hasClass('s_project')) delete param['projekt'];						
					if(_this.hasClass('s_adress')) delete param['adress'];
					if(_this.hasClass('s_student')) delete param['student'];
					
					setNavigate(param);
					
					var url = Object.keys(param).map(function(key){ 
						return encodeURIComponent(key) + '=' + encodeURIComponent(param[key]); 
					}).join('&');
					
					get_table_rows('<cfoutput>#URLFor(action="locations")#</cfoutput>&' + url);
					
				},1000);
			}
			else if( _this.val().length > 2 ) {
									
				$("#flashMessages").show();
				clearTimeout(timeout);
				
				timeout = setTimeout(function(){
					
					if(_this.hasClass('s_project'))
						param.projekt = _this.val();
						
					if(_this.hasClass('s_adress'))
						param.adress = _this.val();
						
					if(_this.hasClass('s_student'))
						param.student = _this.val();
					
					setNavigate(param);
					
					var url = Object.keys(param).map(function(key){ 
						return encodeURIComponent(key) + '=' + encodeURIComponent(param[key]); 
					}).join('&');
					
					get_table_rows('<cfoutput>#URLFor(action="locations")#</cfoutput>&' + url);
					
				},1000);
			}
			else {
				clearTimeout(timeout);
				$("#flashMessages").hide();
			}
		});
		
		$("#location-edit").dialog({
			autoOpen: false,
			height: 500,
			width: 700,
			modal: true,
			buttons: {
				"Zapisz" : function() {
					$dialog = $(this);
					
					var form = {};
					$(this).find(".formfield").each(function(){												
						var name = $(this).attr("name");
						form[name] = $(this).val();
					});

					$.ajax({
						type: "POST",
						url: <cfoutput>"#URLFor(action='location-edit')#"</cfoutput>,
						data: form,
						success: function(){								
							$dialog.dialog("close");							
						},
						error: function(){
							alert("Wystąpił błąd przy zapisywaniu ocen. Spróbuj ponownie później.");
							$dialog.dialog("close");
						}
					});
				}
			},
			Cancel: function() {
				$(this).dialog("close");
			}
		});
		
		$("#location-confirm").dialog({
			autoOpen: false,
			height: 400,
			width: 500,
			modal: true,
			buttons: {
				"Zapisz" : function() {
					$dialog = $(this);
					
					var form = {};
					$(this).find(".formfield").each(function(){
												
						var name = $(this).attr("name");
						
						if($(this).attr('type') == 'checkbox')
							$(this).is(':checked') ? form[name]=1 : form[name]=0;
						
						else
							form[name] = $(this).val();
					});
					
					console.log(form);
					
					$.ajax({
						type: "POST",
						url: <cfoutput>"#URLFor(action='location-confirm')#"</cfoutput>,
						data: form,
						success: function(){
								
							$dialog.dialog("close");							
						},
						error: function(){
							alert("Wystąpił błąd przy zapisywaniu ocen. Spróbuj ponownie później.");
							$dialog.dialog("close");
						}
					});					
				}
			},
			Cancel: function() {
				$(this).dialog("close");
			}
		});
		
		$(".courses").on("click", ".prompt", function(){
			var $this = $(this);
			
			if(confirm("Na pewno usunąć cały proces rekrutacji?")){
				
				$.ajax({
					type: "GET",
					url: $this.attr("href"),
					success: function(){
						$this.closest("tr").fadeOut().remove();
					},
					error: function(){
						alert("Wystąpił błąd podczas usuwania. Spróbuj ponownie później.");
					}
				});
			}
			
			return false;
		});
		
		$(".courses").on("click", ".dialog", function(){
			var $this = $(this);
			var source = $this.data("source");
			
			var url =  $this.attr("href");
			
			$("#flashMessages").show();
			
			$.get(url, function(data){
				$("#"+source).html(data);
				$("#flashMessages").hide();
				$("#"+source).dialog("open");
			});
			
			return false;
		});
		
		$(".locations-table").on("click", ".course-btn", function(){
			
			if($(this).data("id") != ''){				
				window.location=<cfoutput>"#URLFor(action='view')#"</cfoutput> + "&key=" + $(this).data("cid");
			}
		});
		
		$(".locations-table").on("mouseenter", ".thsort", function(){
			
			var idx = $(this).index() + 1;
				
			$(this).addClass("trhover");
			$("td:nth-child(" + idx + ")").addClass("trhover");
		});
		
		$(".locations-table").on("mouseleave", ".thsort", function(){
			var idx = $(this).index() + 1;
			
			$(this).removeClass("trhover");
			$("td:nth-child(" + idx + ")").removeClass("trhover");
		});
		
	});
</script>