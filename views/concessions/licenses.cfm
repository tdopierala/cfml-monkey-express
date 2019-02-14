<cfoutput>
	
	<div class="wrapper concessions">
		<h3>Zezwolenia</h3>
		
		<ul class="intranet-tab-index">
			<li>
				#linkTo(text="Dokumenty", action="index", class="")#
			</li>
			<li class="chosen">
				#linkTo(text="Koncesje", action="licenses", class="")#
			</li>
		</ul>
		
		<div class="intranet-tab-content">
			
			<table id="concession-table" class="tables concession-table">
				<thead>
					<tr class="sort1">
						<th rowspan="3">Nr</th>
						<th rowspan="3" class="thsort">
							<span>Status dokumentu</span>
							
							<a href="#URLFor(action='index', params='order=#params.order#&orderby=status')#"
							   title="sortuj"
							   class="_navigate status">
								<img src="/intranet/images/sort-asc-desc.png" alt="sortuj" />
							</a>
						</th>
						<th colspan="2">Zezwolenie</th>
						
						<th rowspan="2">Sklep</th>
						
						<th colspan="3">Daty zezwoleń</th>
					</tr>
					<tr class="sort2">
						<th class="thsort">
							<span>Typ</span>
							
							<a href="#URLFor(action='index', params='order=#params.order#&orderby=type')#"
							   title="sortuj"
							   class="_navigate type">						   	
								<img src="/intranet/images/sort-asc-desc.png" alt="sortuj" />
							</a>
						</th>
						<th>Numer</th>
						
						<th rowspan="2" class="thsort sort3">
							<span>wydania</span>
							
							<a href="#URLFor(action='index', params='order=#params.order#&orderby=dateofissue')#"
							   title="sortuj"
							   class="_navigate dateofissue">						   	
								<img src="/intranet/images/sort-asc-desc.png" alt="sortuj" />
							</a>
						</th>
						<th rowspan="2" class="thsort sort3">
							<span>od</span>
							
							<a href="#URLFor(action='index', params='order=#params.order#&orderby=datefrom')#"
							   title="sortuj"
							   class="_navigate datefrom">						   	
								<img src="/intranet/images/sort-asc-desc.png" alt="sortuj" />
							</a>
						</th>
						<th rowspan="2" class="thsort sort3">
							<span>do</span>
							
							<a href="#URLFor(action='index', params='order=#params.order#&orderby=dateto')#"
							   title="sortuj"
							   class="_navigate dateto">						   	
								<img src="/intranet/images/sort-asc-desc.png" alt="sortuj" />
							</a>
						</th>
					</tr>
					<tr>
						<th></th>
						<th>
							#textFieldTag(name="documentnr")#
						</th>
						<th>
							#textFieldTag(name="projekt")#
						</th>
					</tr>
					
				</thead>
				<tbody id="table-data">
					
					
					
				</tbody>
			</table>
			
		</div>
		
	</div>
	
</cfoutput>
<script>
	$(function(){
		
		urlbase = '<cfoutput>#URLFor(controller="Concessions", action="licenses")#</cfoutput>';
		
		if (typeof(localStorage.lisensesort) != 'undefined') {
			
			param = JSON.parse(localStorage.getItem('lisensesort'));
			
			url = urlbase + '&' + Object.keys(param).map(function(key){ 
				return key + '=' + param[key]; //encodeURIComponent() 
			}).join('&');
			
			if (typeof(param.projekt) != 'undefined')
				$("#projekt").val( param.projekt );
			
			if (typeof(param.documentnr) != 'undefined')	
				$("#documentnr").val( decodeURIComponent(param.documentnr) );
				
			setNavigate(param);
				
		} else {
			
			url = urlbase;
		}
		
		getConcessionTable(url);
		
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
				if(key != "order" && key != "orderby" && key != "projekt" && key != "documentnr" && key != "page" && key != "amount")
					delete param_tab[key];
					
			delete ls['lisensesort'];
					
			ls.setItem('lisensesort', JSON.stringify(param_tab));
			j_param = param_tab;

			
			$("#flashMessages").show();
			
			$.ajax({
				type: 'GET',
				url: '<cfoutput>#URLFor(controller="Concessions", action="licenses")#</cfoutput>',
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
				
				if($(this).hasClass("type")){
					
					if (param.orderby == 'type') 
						if (param.order == 'asc') { param.order = 'desc'; $img.attr("src", src + "sort-desc.png"); }
						else { param.order = 'asc'; $img.attr("src", src + "sort-asc.png"); }
						
					param.orderby = 'type';
				}
				
				if($(this).hasClass("dateofissue")){
					
					if (param.orderby == 'dateofissue') 
						if (param.order == 'asc') { param.order = 'desc'; $img.attr("src", src + "sort-desc.png"); }
						else { param.order = 'asc'; $img.attr("src", src + "sort-asc.png"); }
						
					param.orderby = 'dateofissue';
				}
				
				if($(this).hasClass("datefrom")){
					
					if(param.orderby == 'datefrom')
						if (param.order == 'asc') { param.order = 'desc'; $img.attr("src", src + "sort-desc.png"); }
						else { param.order = 'asc'; $img.attr("src", src + "sort-asc.png"); }
						
					param.orderby = 'datefrom';
				}
				
				if($(this).hasClass("dateto")){
					
					if(param.orderby == 'dateto')
						if (param.order == 'asc') { param.order = 'desc'; $img.attr("src", src + "sort-desc.png"); }
						else { param.order = 'asc'; $img.attr("src", src + "sort-asc.png"); }
						
					param.orderby = 'dateto';
				}
				
				url = urlbase + '&' + Object.keys(param).map(function(key){ 
					return key + '=' + param[key]; 
				}).join('&');
				
				$(this).attr("href", url);
				
				param.orderby = orderby;
			});
		}
		
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
		
		var timebox;
		$("#projekt").on("keyup", function(){
			
			clearTimeout(timebox);
			$this = $(this);
			
			if ($this.val().length > 2 || $this.val().length == 0) {
				timebox = setTimeout(function(){
					
					var param = JSON.parse(localStorage.getItem('lisensesort'));
					param.projekt = $this.val();
					
					setNavigate(param);
			
					var url = Object.keys(param).map(function(key){
						return key + '=' + param[key]; 
					}).join('&');
					
					getConcessionTable('<cfoutput>#URLFor(controller="Concessions", action="licenses")#</cfoutput>&' + url);
							
				}, 500);
			}
		});
		
		$("#documentnr").on("keyup", function(){
			
			clearTimeout(timebox);
			$this = $(this);
			
			if ($this.val().length > 2 || $this.val().length == 0) {
				timebox = setTimeout(function(){
					
					var param = JSON.parse(localStorage.getItem('lisensesort'));
					param.documentnr = $this.val();
					
					setNavigate(param);
			
					var url = Object.keys(param).map(function(key){
						return key + '=' + param[key]; 
					}).join('&');
					
					getConcessionTable('<cfoutput>#URLFor(controller="Concessions", action="licenses")#</cfoutput>&' + url);
							
				}, 500);
			}
		});
		
		$("#concession-table").on("mouseenter", ".thsort", function(){
			
			var idx = $(this).index() + 1;
			
			if($(this).parent().hasClass("sort2"))
				idx += 2;
			
			if($(this).hasClass("sort3"))
				idx += 1;
				
				
			$(this).addClass("trhover");
			$("td:nth-child(" + idx + ")").addClass("trhover");
		});
		
		$("#concession-table").on("mouseleave", ".thsort", function(){
			
			var idx = $(this).index() + 1;
			
			if($(this).parent().hasClass("sort2"))
				idx += 2;
				
			if($(this).hasClass("sort3"))
				idx += 1;
			
			$(this).removeClass("trhover");
			$("td:nth-child(" + idx + ")").removeClass("trhover");
		});
		
	});
</script>