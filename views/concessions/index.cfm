<cfoutput>
	
	<div class="wrapper concessions">
		<h3>Koncesje</h3>
		
		<ul class="intranet-tab-index">
			<li class="chosen">
				#linkTo(text="Dokumenty", action="index", class="")#
			</li>
			<li>
				#linkTo(text="Koncesje", action="licenses", class="")#
			</li>
		</ul>
		
		<div class="intranet-tab-content">
			
			<div class="intranet-backlink">
				#linkTo(text="Nowa koncesja", action="create")#
			</div>
			
			<table id="concession-table" class="tables concession-table">
				<thead>
					<tr>
						<th rowspan="2">Nr</th>
						<th>Status</th>
						<th>Sklep</th>
						<th rowspan="2" class="thsort">
							<span>Data utworzenia</span>
							
							<a href="#URLFor(action='index', params='order=#params.order#&orderby=createdate')#"
							   title="sortuj"
							   class="_navigate createdate">						   	
								<img src="/intranet/images/sort-asc-desc.png" alt="sortuj" />
							</a>
						</th>
						<th rowspan="2" class="thsort">
							<span>Osoba dodająca</span>
							
							<a href="#URLFor(action='index', params='order=#params.order#&orderby=username')#"
							   title="sortuj"
							   class="_navigate username">						   	
								<img src="/intranet/images/sort-asc-desc.png" alt="sortuj" />
							</a>
						</th>
						<th rowspan="2"></th>
					</tr>
					<tr>
						<th>
							#selectTag(name="status", includeBlank="-- wszystkie --", options=statuses)#
						</th>
						<th>
							#textFieldTag(name="projekt")#
						</th>
					</tr>
				</thead>
				<tbody id="table-data">
					<!---#includePartial("index")#--->
				</tbody>
			</table>
			
			<div class="concession-paginator"></div>
			
			<div style="clear:both;"></div>
		</div>
		
	</div>
	
</cfoutput>

<script>
	$(function(){
		
		//localStorage.clear();
		
		var conession_url = '';
		urlbase = '<cfoutput>#URLFor(controller="Concessions", action="index")#</cfoutput>';
		
		if (typeof(localStorage.conessionsort) != 'undefined') {
			
			param = JSON.parse(localStorage.getItem('conessionsort'));
			
			console.log(param);
			
			conession_url = urlbase + '&' + Object.keys(param).map(function(key){ 
				return key + '=' + param[key]; 
			}).join('&');
			
			console.log(conession_url);
			
			if (typeof(param.projekt) != 'undefined')	
				$("#projekt").val( param.projekt );
				
			if(typeof(param.status) != 'undefined')
				$("#status").find("option").each(function(){
					if($(this).attr("value") == param.status)
						$(this).attr("selected", true);
				});
				
			setNavigate(param);
				
		} else {
			
			conession_url = urlbase;
		}
		
		console.log(conession_url);
		
		getConcessionTable(conession_url);
		
		function getConcessionTable(url){
			
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
				if(key != "order" && key != "orderby" && key != "projekt" && key != "status" && key != "page" && key != "amount")
					delete param_tab[key];
					
			delete ls['conessionsort'];
					
			ls.setItem('conessionsort', JSON.stringify(param_tab));
			j_param = param_tab;

			
			$("#flashMessages").show();
			
			$.ajax({
				type: 'GET',
				url: '<cfoutput>#URLFor(controller="Concessions", action="index")#</cfoutput>',
				data: j_param,
				dataType: "html",
				
				success: function(data, status, xhr){
				
					$("#concession-table").find("tbody").html(data);					
					$("#flashMessages").hide();
				},
				
				error: function(){
				
					alert("Pobranie danych nie powiodło się");
					$("#flashMessages").hide();
					
				}
			});
		}
		
		function setNavigate(param){
			
			$("._navigate").each(function(){
				
				var orderby = param.orderby;
				$img = $(this).find("img");
				src = "/intranet/images/";
				
				if($(this).hasClass("createdate")){
					
					if (param.orderby == 'createdate') 
						if (param.order == 'asc') { param.order = 'desc'; $img.attr("src", src + "sort-desc.png"); }
						else { param.order = 'asc'; $img.attr("src", src + "sort-asc.png"); }
						
					param.orderby = 'createdate';
				}
				
				if($(this).hasClass("username")){
					
					if(param.orderby == 'username')
						if (param.order == 'asc') { param.order = 'desc'; $img.attr("src", src + "sort-desc.png"); }
						else { param.order = 'asc'; $img.attr("src", src + "sort-asc.png"); }
						
					param.orderby = 'username';
				}
				
				url = urlbase + '&' + Object.keys(param).map(function(key){ 
					return encodeURIComponent(key) + '=' + encodeURIComponent(param[key]); 
				}).join('&');
				
				$(this).attr("href", url);
				
				param.orderby = orderby;
			});
		}
		
		$("#status").on("change", function(){
			
			var param = JSON.parse(localStorage.getItem('conessionsort'));
			param.status = $(this).val();
			
			setNavigate(param);
			
			var url = Object.keys(param).map(function(key){ 
				return encodeURIComponent(key) + '=' + encodeURIComponent(param[key]); 
			}).join('&');
			
			getConcessionTable('<cfoutput>#URLFor(controller="Concessions", action="index")#</cfoutput>&' + url);
			
		});
		
		$(".concession-paginator").on("click", "a.paginlink", function(){
			
			var param = JSON.parse(localStorage.getItem('conessionsort'));
			param.page = $(this).data("page");
			
			//setNavigate(param);
			
			var url = Object.keys(param).map(function(key){ 
				return encodeURIComponent(key) + '=' + encodeURIComponent(param[key]); 
			}).join('&');
			
			getConcessionTable('<cfoutput>#URLFor(controller="Concessions", action="index")#</cfoutput>&' + url);
			
			return false;
		});
		
		var timebox;
		$("#projekt").on("keyup", function(){
			
			clearTimeout(timebox);
			$this = $(this);
			
			if ($this.val().length > 2 || $this.val().length == 0) {
				timebox = setTimeout(function(){
					
					var param = JSON.parse(localStorage.getItem('conessionsort'));
					param.projekt = $this.val();
					
					setNavigate(param);
			
					var url = Object.keys(param).map(function(key){ 
						return encodeURIComponent(key) + '=' + encodeURIComponent(param[key]); 
					}).join('&');					
					
					getConcessionTable('<cfoutput>#URLFor(controller="Concessions", action="index")#</cfoutput>&' + url);
							
				}, 500);
			}
		});
		
		$("._navigate").on("click", function(){
			
			var url = $(this).attr("href");
			var $img = $(this).find("img");
			var src = "/intranet/images/";
			
			$("._navigate").find("img").attr("src", src + "sort-asc-desc.png");
			
			if (url.indexOf("asc") > 0) {
				$img.attr("src", src + "sort-desc.png");
				$(this).attr("href", url.replace("asc", "desc"));
			}
			
			if (url.indexOf("desc") > 0) {
				$img.attr("src", src + "sort-asc.png");
				$(this).attr("href", url.replace("desc", "asc"));
			}
			
			getConcessionTable(url);
			
			return false;
		});
		
		$("#concession-table").on("mouseenter", ".thsort", function(){
			
			var idx = $(this).index() + 1;
				
			$(this).addClass("trhover");
			$("td:nth-child(" + idx + ")").addClass("trhover");
		});
		
		$("#concession-table").on("mouseleave", ".thsort", function(){
			
			var idx = $(this).index() + 1;
									
			$(this).removeClass("trhover");
			$("td:nth-child(" + idx + ")").removeClass("trhover");
		});
		
	});
</script>