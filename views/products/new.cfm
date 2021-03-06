<script>
	$(function(){
		$("div.actionType").hover(function(){
			//$(this).css({ "background-position": "0 -70px" });
			$(this).addClass("_hover");
		},function(){
			//$(this).css({ "background-position": "0 0" });
			$(this).removeClass("_hover");
		});
		
		$("div.actionType").mousedown(function(){
			$(this).css({
				//"background-position": "0 -140px",
				"padding-top"		: "+=1px",
				"padding-left"		: "+=1px",
				"width"			: "-=1px",
				"height"			: "-=1px"
			}).addClass("_selected");
		}).mouseup(function(){
			$(this).css({
				//"background-position": "0 -70px",
				"padding-top"		: "-=1px",
				"padding-left"		: "-=1px",
				"width"			: "+=1px",
				"height"			: "+=1px"
			});
		});
		
		$(document).on("mouseenter", ".input_file", function(){
			$(this).parent().css({ "background-position": "0 -30px" });
		}).on("mouseleave",function(){
			$(this).parent().css({ "background-position": "0 0" });
		});
		
		$(document).on("mousedown", ".input_file", function(){
			$(this).parent().css({
				"background-position": "0 -60px",
				"padding-top"		: "+=1px",
				"padding-left"		: "+=1px",
				"width"			: "-=1px",
				"height"			: "-=1px"
			});
			var obj = $(this);
			setTimeout(function(){
				obj.parent().css({
					"background-position": "0 -30px",
					"padding-top"		: "-=1px",
					"padding-left"		: "-=1px",
					"width"			: "+=1px",
					"height"			: "+=1px"
				});
			}, 100);
		});
	});
</script>
<cfoutput>

	<div class="wrapper">
		
		<h3>Dodawanie nowego produktu</h3>
		
		<div id="products" class="warpper">
			
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_index" >
				<cfinvokeargument name="groupname" value="Propozycje nowych indeksów" />Nowe indeksy
			</cfinvoke>
			
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_dm" >
				<cfinvokeargument name="groupname" value="Departament Marketingu" />
			</cfinvoke>
				
			<div class="product_menu">
				
				<cfif _index is true>
			
						<div class="actionType" id="new">
							<img src="./images/product_new_150px.png" alt="Propozycja nowego produktu" width="50" />
							<span>Propozycja nowego produktu</span>
						</div>
						
						<div class="actionType" id="replace">
							<img src="./images/product_replace_150px.png" alt="Propozycja nowego produktu w zamian za inny" width="50" />
							<span>Propozycja nowego produktu w zamian za inny</span>
						</div>
						
						<div class="actionType" id="unlock">
							<img src="./images/product_unlock_150px.png" alt="Odblokowanie produktu" width="50" />
							<span>Odblokowanie produktu</span>
						</div>
						
						<div class="actionType" id="renew">
							<img src="./images/product_renew_150px.png" alt="Odblokowanie produktu w zamian za inny" width="50" />
							<span>Odblokowanie produktu w zamian za inny</span>
						</div>
				
				</cfif>
				
				<cfif _dm is true>
					
					<div class="actionType" id="proposal">
						<img src="./images/product_new_150px.png" alt="Propozycja produktu od DM" width="50" />
						<span>Propozycja produktu od DM</span>
					</div>
					
				</cfif>
				
				<div style="clear:both;"></div>
			
			</div>
			
			<div class="product_details">
				
			</div>
		</div>
		
	</div>
	
</cfoutput>
<script>
	$(function(){
		
		$(document).on("click", "div.actionType", function(){
			$("#flashMessages").show();
			
			$("div.actionType").removeClass("_selected");
			$(this).addClass("_selected");
			$.ajax({
				type		:	'get',
				dataType	:	'html',
				url		:	<cfoutput>"#URLFor(controller='products',action='new')#"</cfoutput> + "&form=" + $(this).attr("id"),
				success	:	function(data) {
					$('div.product_details')
						.hide()
						.html(data)
						.slideDown("fast");
					$("#flashMessages").hide();
				}
			});
		});
		
	});
</script>