<div class="wrapper">
	
	<h3>Lista szkoleń</h3>
	
	<cfoutput>#includePartial("tabmenu")#</cfoutput>
	
	<div class="intranet-backlink">
		<cfoutput><a href="#URLFor(action='add-course')#">Nowe szkolenie</a></cfoutput>
	</div>
	
	<cfoutput>
		
		<cfif flashKeyExists("success")>
	    	<span class="success">#flash("success")#</span>
		</cfif>
		
		<cfif flashKeyExists("error")>
	    	<span class="error">#flash("error")#</span>
		</cfif>
		
    	<table class="tables courses-table" 
			data-orderby="#params.orderby#"
			data-order="#params.order#"
			data-type="#params.type#">
				
			<thead>
				<tr>
					<th rowspan="2">Id</th>
					<th class="thsort" rowspan="2">
						<span>Data rozpoczęcia szkolenia</span>
							<a 
								class = "searchparamlink navigate datesort" 
								title = "Sortuj " 
								data-container = "courses-table-tbody" 
								href = "#URLFor(action='index', params='page=1&orderby=datefrom&order=desc&type=#params.type#')#">								
									
									#imageTag("sort-asc-desc.png")#
									
									<!---<cfif orderby eq 'starter'>
										<cfif _order eq 'asc'>
											#imageTag("sort-asc.png")#
										<cfelse>
											#imageTag("sort-desc.png")#
										</cfif>
									<cfelse>
										#imageTag("sort-asc-desc.png")#
									</cfif>--->
							</a>
					</th>
					<th class="thsort" rowspan="2">
						<span>Data zakończenia szkolenia</span>
							<a 
								class = "searchparamlink navigate datesort" 
								title = "Sortuj " 
								data-container = "courses-table-tbody" 
								href = "#URLFor(action='index', params='page=1&orderby=dateto&order=desc&type=#params.type#')#">
									
									#imageTag("sort-asc-desc.png")#
							</a>
					</th>
					<th rowspan="2">Miejsce szkolenia</th>
					<th>Typ szkolenia</th>
					<th rowspan="2">Uczestników</th>
					<th rowspan="2"></th>
				</tr>
				<tr>
					<th>
						#selectTag(name="course-type", options=coursetype, includeBlank="-- wszystkie --", class="course-type-select")#
					</th>
				</tr>
			</thead>
			<tbody id="courses-table-tbody">
				<!---#includePartial("index")#--->
			</tbody>
		</table>
    </cfoutput>
	
</div>

<script>
	$(function(){
		
		//delete localStorage['courses_sort'];
		
		urlbase = '<cfoutput>#URLFor(action="index")#</cfoutput>';
		
		if (typeof(localStorage.courses_sort) != 'undefined') {
			
			param = JSON.parse(localStorage.getItem('courses_sort'));
			
			console.log(param);
			
			url = urlbase + '&' + Object.keys(param).map(function(key){ 
				return key + '=' + param[key]; 
			}).join('&');
				
			if(typeof(param.type) != 'undefined')
				$("#course-type").find("option").each(function(){
					if($(this).attr("value") == param.type)
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
				if(key != "type" && key != "orderby" && key != "order" && key != "page" && key != "amount")
					delete param_tab[key];
					
			delete ls['courses_sort'];
					
			ls.setItem('courses_sort', JSON.stringify(param_tab));
			j_param = param_tab;
			
			$("#flashMessages").show();
			
			$.ajax({
				type: 'GET',
				url: '<cfoutput>#URLFor(controller="Courses", action="index")#</cfoutput>',
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
				
				if($(this).hasClass("datesort")){
					
					if (param.orderby == 'dateto')
						if (param.order == 'asc') { /*param.order = 'desc';*/ $img.attr("src", src + "sort-desc.png"); }
						else { /*param.order = 'asc';*/ $img.attr("src", src + "sort-asc.png"); }
					
					if (param.orderby == 'datefrom')
						if (param.order == 'asc') { /*param.order = 'desc';*/ $img.attr("src", src + "sort-desc.png"); }
						else { /*param.order = 'asc';*/ $img.attr("src", src + "sort-asc.png"); }
						
					param.orderby = 'datefrom';
				}
				
				url = urlbase + '&' + Object.keys(param).map(function(key){ 
					return encodeURIComponent(key) + '=' + encodeURIComponent(param[key]); 
				}).join('&');
				
				$(this).attr("href", url);
				
				param.orderby = orderby;
			});
		}
		
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
		
		$(".courses-table").on("click", ".navigate", function(){
			
			var url = $(this).attr("href");
			var $img = $(this).find("img");
			var src = "/intranet/images/";
			
			$(".navigate").find("img").attr("src", src + "sort-asc-desc.png");
			
			if (url.indexOf("asc") > 0) {
				$img.attr("src", src + "sort-desc.png");
				$(this).attr("href", url.replace("asc", "desc"));
			}
			
			if (url.indexOf("desc") > 0) {
				$img.attr("src", src + "sort-asc.png");
				$(this).attr("href", url.replace("desc", "asc"));
			}
			
			get_table_rows(url);
			
			return false;
		});
		
		$(".courses-table").on("change", ".course-type-select", function(){
			
			var param = JSON.parse(localStorage.getItem('courses_sort'));
			param.type = $(this).val();
			
			setNavigate(param);
			
			var url = Object.keys(param).map(function(key){ 
				return encodeURIComponent(key) + '=' + encodeURIComponent(param[key]); 
			}).join('&');
			
			get_table_rows('<cfoutput>#URLFor(controller="Courses", action="index")#</cfoutput>&' + url);
			
			return false;
		});
	});
</script>