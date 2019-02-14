<cfprocessingdirective pageencoding="utf-8" />
	
<cfdiv id="left_site_column">
	<div class="leftWrapper">
	
		<div class="headerArea">
			<div class="headerArea uiHeader">
				<h3 class="uiHeaderTitle">Wyszukiwarka indeksów</h3>
			</div>
		</div>
		
		<div class="contentArea">
			<div class="contentArea uiContent">

				<table class="uiTable">
					<thead>
						<tr>
							<th class="leftBorder topBorder rightBorder bottomBorder">Indeks</th>
							<th class="topBorder rightBorder bottomBorder">Kod kreskowy</th>
							<th class="topBorder rightBorder bottomBorder">Nazwa</th>
							<th class="topBorder rightBorder bottomBorder">Kategoria</th>
							<th class="topBorder rightBorder bottomBorder">Status</th>
						</tr>
						<tr>
							<th colspan="5" class="leftBorder bottomBorder rightBorder">
								<input type="text" name="wyszukiwarkaean" class="input" placeholder="Wyszukaj indeksu..." style="width:100%;" id="wyszukiwarkaean" />
							</th>
						</tr>
					</thead>
					<tbody>
						
					</tbody>
				</table>

				<div class="uiFooter">
				</div>
			</div>
		</div>

		<div class="footerArea">
		</div>
		
	</div>
	
</cfdiv>

<script type="text/javascript">
var WyszukiwarkaEan = Class.extend({
	init: function() {
		this.timeOut = null;
		this.url = "index.cfm?controller=asseco&action=lista-ean";
		
		var _tmp = this;
		
		$("#wyszukiwarkaean").on("keypress", function(e){
			var _input = this;
			if (this.timeOut) {
				clearTimeout(this.timeOut);
				this.timeOut = null;
			}

			this.timeOut = setTimeout(function() {_tmp.pobierzIndeksy($(_input).val())}, 500)
		});
	},
	pobierzIndeksy: function(_string) {
		var obj = this;
		$.ajax({
			url: obj.url,
			dataType: 'json',
			type: 'post',
			async: false,
			data: {wyszukiwarkaean:_string},
			success: function(_result) {
				$(".uiTable tbody").find("tr").fadeOut(500).remove();
				var _html = "";
				$.each(_result.ROWS, function(i, item) {
					_html += "<tr><td class=\"leftBorder rightBorder bottomBorder\">"+item['SYMKAR']+"</td><td class=\"rightBorder bottomBorder\">"+item['KODKRES']+"</td><td class=\"rightBorder bottomBorder\">"+item['OPIKAR1']+"</td><td class=\"rightBorder bottomBorder\">"+item['KATEGORIA']+"</td><td class=\"rightBorder bottomBorder\">"+item['STATUS']+"</td></tr>";
				});
				$(".uiTable tbody").append(_html).fadeIn(500);
			},
			error: function(_xhr, _ajaxOptions, _thrownError){
				console.log(_xhr);
				console.log(_ajaxOptions);
				console.log(_thrownError);
			}
		});
	}
});

$(function() {
	var mojaWyszukiwarka = new WyszukiwarkaEan();
});

</script>