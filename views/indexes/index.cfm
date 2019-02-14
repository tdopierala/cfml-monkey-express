<cfoutput>

	<div class="wrapper">
		
		<h3>Lista nowych indeksów</h3>
		
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		<cfelseif flashKeyExists("error")>
			<span class="error">#flash("error")#</span>
		</cfif>
		
		<!---<div class="action-buttons"><a href="##" class="refresh"><img src="./images/refresh.png" alt="refresh" width="20" /></a></div>--->
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_index" >
			<cfinvokeargument name="groupname" value="Nowe indeksy" />Nowe indeksy
		</cfinvoke>
		
		<cfif _index is true>
			<ol class="productlinks">
				<li>#linkTo(text="Dodaj nowy indeks", action="add")#</li>
				<!---<li>#linkTo(text="Archiwalne indeksy", controller="products", action="index")#</li>--->
			</ol>
		</cfif>
		
		<div class="product-filter filter">
			<h5>Filtruj indeksy wg kryteriów</h5>
			<div class="product-filter-field">
				#textFieldTag(
					name="datefrom",
					
					class="input product_date",
					placeholder="data od")#
			</div>
			<div class="product-filter-field">
				#textFieldTag(
					name="dateto",
				
					class="input product_date",
					placeholder="data do")#
			</div>
			<div class="product-filter-field product-xls-export">
				#linkTo(
					text=imageTag("excel-icon.png")&" Eksport do pliku *.xls",
					href="##",
					class="product_xls")#
			</div>
			<div style="clear:both"></div>
			
			<div class="product-filter-field" style="width:300px;padding:10px 15px;">
				#selectTag(
					name="category",
					options=categories,
					includeBlank="-- wybierz --",
					label="Kategoria planogramu",
					labelPlacement="before", 
					class="product_select")#
			</div>
			
			<div style="clear:both"></div>
		</div>
		
		<table id="products-table" class="tables products-table">
			<thead>
				<tr>
					<th colspan="2">Nr</th>
					<th>Nazwa produktu</th>
					<th>Data</th>
					<th>Typ</th>
					<th>Użytkownik</th>
					<th>Etap/Status</th>
					<th></th>
				</tr>
				<tr>
					<td colspan="2"></td>
					<td>#textFieldTag(name="pn")#</td>
					<td></td>
					<td>#selectTag(name="pt", options=productType, includeBlank=" - wszystkie - ")#</td>
					<td>#selectTag(name="pu", options=users, includeBlank=" - wszyscy - ")#</td>
					<td>#selectTag(name="ps", options=statuses, selected=params.ps, includeBlank=" - wszystkie - ")#</td>
					<td></td>
				</tr>
			</thead>
			<tbody>
				<!---#includePartial("index")#--->
			</tbody>
		</table>
	
		<div class="product-paginator"></div>
		
	</div>
	<!---<cfdump var="#products#" />--->
</cfoutput>
<!--- <cfif StructKeyExists(session, "userid") and session.userid eq 345>
	<cfdump var="#users#" />
</cfif> --->
<script>
	
	if (typeof(localStorage.productsortv2) != 'undefined') {
		
		param = JSON.parse(localStorage.getItem('productsortv2'));
		
		if (typeof(param.pn) != 'undefined')	
			$("#pn").val( param.pn );
		
		if(typeof(param.pt) != 'undefined')
			$("#pt").find("option").each(function(){
				if($(this).attr("value") == param.pt)
					$(this).attr("selected", true);
			});
		
		if(typeof(param.pu) != 'undefined')
			$("#pu").find("option").each(function(){
				if($(this).attr("value") == param.pu)
					$(this).attr("selected", true);
			});
			
		if(typeof(param.ps) != 'undefined')
			$("#ps").find("option").each(function(){
				if($(this).attr("value") == param.ps)
					$(this).attr("selected", true);
			});
		
		if(typeof(param.pc) != 'undefined')
			$("#category").find("option").each(function(){
				if($(this).attr("value") == param.pc)
					$(this).attr("selected", true);
			});
		
		refresh(param.pn, param.pt, param.ps, param.pu, param.pc, param.page, param.dfrom, param.dto);		
	}
	
	var ajax_time;
	
	function refresh(_pn, _pt, _ps, _pu, _pc, _page, _dfrom, _dto, view){
		
		_dfrom = typeof _dfrom !== 'undefined' ? _dfrom : 0;
		_dto = typeof _dto !== 'undefined' ? _dto : 0;
		view = typeof view !== 'undefined' ? view : '';
		_page = typeof _page !== 'undefined' ? _page : 1;
		_pc = typeof _pc !== 'undefined' ? _pc : 0;
   
		$("#flashMessages").show();
		
		var param_tab = {
			pn : _pn,
			pt : _pt,
			ps : _ps,
			pu : _pu,
			page : _page,
			dfrom : _dfrom,
			dto : _dto
		};
		
		delete localStorage['productsortv2'];
					
		localStorage.setItem('productsortv2', JSON.stringify(param_tab));
		
		$.ajax({
			type		:	'get',
			dataType	:	'html',
			url		:	<cfoutput>"#URLFor(action='index')#"</cfoutput> + '&pn=' + _pn + '&pt=' + _pt + '&ps=' + _ps + '&pu=' + _pu + '&pc=' + _pc + '&page=' + (_page-1) + '&dfrom=' + _dfrom + '&dto=' + _dto + '&view=' + view,
			success	:	function(data) {
			
				$(".products-table").children("tbody").slideUp().html(data);
				$(".products-table").children("tbody").slideDown();
				$("#flashMessages").hide();
			},
			error : function(){
				$("#flashMessages").hide();
			}
		});
	}
	
	$(function(){
		
		$('.product_date').datepicker({
			showOn: "both",
			buttonImage: "images/schedule.png",
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
			dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So'],
			firstDay: 1,
			onSelect: function(){
				
				var from = $.datepicker.formatDate('yy-mm-dd', $("#datefrom").datepicker("getDate"));
				var to = $.datepicker.formatDate('yy-mm-dd', $("#dateto").datepicker("getDate"));
				
				refresh( $("#pn").val(), $("#pt").val(), $("#ps").val(), $("#pu").val(), $("#category").val(), 1, from, to) ;
			}
		});
		
		$(".product-paginator").on("click", "a.paginlink", function(){
			
			var from = $.datepicker.formatDate('yy-mm-dd', $("#datefrom").datepicker("getDate"));
			var to = $.datepicker.formatDate('yy-mm-dd', $("#dateto").datepicker("getDate"));
			var page = $(this).data("page");
			
			refresh( $("#pn").val(), $("#pt").val(), $("#ps").val(), $("#pu").val(), $("#category").val(), parseInt(page), from, to );
			return false;
		});
		
		$(document).on("click", "a.refresh", function(){
			refresh('',0,0,0);
			$("#ps, #pt, #pu").val("");
			return false;
		});
		
		$("#ps, #pt, #pu, #category").on("change", function(){			
			refresh( '', $("#pt").val(), $("#ps").val(), $("#pu").val(), $("#category").val() );
		});
		
		$("#pn").on("keyup", function(){
			
			var _this = $(this);
			if( _this.val().length > 2 ) {
									
				$("#flashMessages").show();
				clearTimeout(ajax_time);
				
				ajax_time = setTimeout(function(){
					refresh( _this.val(), $("#pt").val(), $("#ps").val(), $("#pu").val(), $("#category").val() );
				},1000);
			}
			else if(_this.val().length <= 2) {
						
				$("#flashMessages").show();
				clearTimeout(ajax_time);
				
				ajax_time = setTimeout(function(){
					refresh('',0,0,0);
				},500);
			}
			else {
				clearTimeout(ajax_time);
				$("#flashMessages").hide();
			}
		});
		
		$(".product_xls").on("click", function(){
			
			var from = $.datepicker.formatDate('yy-mm-dd', $("#datefrom").datepicker("getDate"));
			var to = $.datepicker.formatDate('yy-mm-dd', $("#dateto").datepicker("getDate"));
			
			document.location = <cfoutput>"#URLFor(action='index')#"</cfoutput> + '&pn=' + $("#pn").val() + '&pt=' + $("#pt").val() + '&ps=' + $("#ps").val() + '&pu=' + $("#pu").val() + '&pc=' + $("#category").val() + '&page=' + 0 + '&dfrom=' + from + '&dto=' + to + '&view=' + 'xls';
			
			//refresh( $("#pn").val(), $("#pt").val(), $("#ps").val(), $("#pu").val(), 1, from, to, 'xls');
			
			return false;
		});
		
	});
</script>