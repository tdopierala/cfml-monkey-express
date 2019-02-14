<cfoutput>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_dh" >
		<cfinvokeargument name="groupname" value="Departament Handlowy" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_dm" >
		<cfinvokeargument name="groupname" value="Departament Marketingu" />
	</cfinvoke>
	
	<div class="wrapper">
		
		<h3>Dodawanie nowego produktu</h3>
		
		<div id="products" class="warpper products">
			
			<ul class="intranet-tab-index">
				
				<cfif _dh is true>
					<li class="chosen"><a href="##new" id="new" data-form="new" title="Propozycja nowego produktu">Nowy</a></li>
				</cfif>
				
				<cfif _dh is true>
					<li><a href="##replace" id="replace" data-form="replace" title="Propozycja nowego produktu w zamian za inny">Nowy za inny</a></li>
				</cfif>
				
				<cfif _dh is true>
					<li><a href="##unlock" id="unlock" data-form="unlock" title="Odblokowanie starego indeksu">Odblokowanie</a></li>
				</cfif>
				
				<cfif _dh is true>
					<li><a href="##renew" id="renew" data-form="renew" title="Przywrócenie produktu w zamian za inny">Przywrócenie za inny</a></li>
				</cfif>
				
				<cfif _dh is true>
					<li><a href="##kzow" id="kzow" data-form="kzow" title="KZ/OW wraca do sprzedaży">KZ/OW</a></li>
				</cfif>
				
				<cfif _dh is true>
					<li><a href="##explo" id="explo" data-form="explo" title="Propozycja nowego produktu złożonego z indeksów eksploatacyjnych">Nowy z inde. eksplo.</a></li>
				</cfif>
				
				<cfif _dm is true>
					<li><a href="##dm" id="dm" data-form="dm" title="Propozycja nowego produktu od DM">Propozycja DM</a></li>
				</cfif>
			</ul>
			
			<div class="intranet-tab-content">
				
			</div>
			
		</div>
		
	</div>
	
</cfoutput>
<script>
	$(function(){
		
		$(document).on("click", ".productSubmit", function(){
			var flag = 0;
			$(document).find(".invalidmsg").remove();
			
			$(document).find(".required").each(function(){
				
				$(this).removeClass("invalid").next(".invalidmsg").remove();
				
				if($(this).val() == ''){
					$(this).addClass("invalid");
					
					if(!$(this).hasClass("size"))
						$(this).after('<span class="invalidmsg">&laquo;&nbsp;pole obowiązkowe</span>');
					flag = 1;
				}
			});
			
			$(document).find("#product-form").find("ol").children("li").find("input.input").each(function(idx){				
				var _this = $(this);
				if (_this.val() != 'undefined') {
					if(_this.hasClass("price")){ _this.val(_this.val().replace(",",".")); }
					
					if (_this.val().indexOf("CONCATENATE") > -1) {
						_this.addClass('invalid').after('<span class="invalidmsg">&laquo;&nbsp;nieprawidłowa wartość pola</span>');
						flag = 1;
					}					
				}
			});
			
			/*if($(document).find("#product-form").find("input[name=image]").length <= 0){
				$(document).find(".imageForm").children("._button").after('<span class="invalidmsg">&laquo;&nbsp;pole wymagane</span>');
				flag = 1;
			}*/
			
			if($(document).find("#productimguploadform").find(".productimg").length <= 0){
				$(document).find(".imageForm").children("label").find(".invalidmsg").remove();
				$(document).find(".imageForm").children("label").append('<span class="invalidmsg">Przynajmniej jedno zdjcie jest wymagane</span>');
				flag = 1;
			}
			
			$(document).find(".product-input").val($("#replaced").val());
			
			if (flag != 1) {
				$(document).find("#product-form").submit(); 
			}
			else { 
				$(document).find("#product-form")[0].scrollIntoView(true); 
				$("#flashMessages").hide();
			}
				
			return false;
		});
		
		var loadForm = function(id){
			$this = $("#"+id);
			$this.closest("ul").children("li").removeClass("chosen");			
			$("#flashMessages").show();
			
			$.ajax({
				type		:	'get',
				dataType	:	'html',
				url			:	<cfoutput>"#URLFor(action='form')#"</cfoutput> + "&form=" + $this.data("form"),
				success		:	function(data) {					
					$('.intranet-tab-content').hide().html(data).show();
					$("#flashMessages").hide();
					$this.parent("li").addClass("chosen");
				},
				error 		:	function() {					
					alert("Błąd pobierania danych. Spróbuj ponownie później.");
					$("#flashMessages").hide();
				}
			});
		};
		
		var hash = window.location.hash.substring(1);
		if (typeof hash === 'undefined' || hash.length <= 0) {
			hash = 'new';
		}
		
		loadForm(hash);
		
		$(".intranet-tab-index").find("a").on("click", function(){
			var $this = $(this);			
			loadForm($this.data("form"));
			return false;
		});
		
	});
</script>