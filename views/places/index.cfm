<cfoutput>

	<div class="wrapper">
	
		<h3>Baza nieruchomości</h3>
		
		<div class="wrapper"> <!--- Wrapper zaawansowanego wyszukiwania --->
		
			<div class="placesadvancedsearch horizontal"> <!--- Okienko z zaawansowanym wyszukiwaniem --->
			
				<h5>Wyszukiwanie nieruchomości</h5>
				#startFormTag(controller="Places",action="search",id="searchform")#
				<ol>
					<li>
						#selectTag(
							name="province",
							options=provinces,
							includeBlank=true,
							label="Województwo",
							labelPlacement="before")#
					</li>
					<li>
						#textFieldTag(
							name="city",
							label="Miasto",
							labelPlacement="before",
							class="input")#
					</li>
					<li>
						#textFieldTag(
							name="street",
							label="Ulica",
							labelPlacement="before",
							class="input")#
					</li>
					<li>
						#textFieldTag(
							name="partner",
							label="Partner",
							labelPlacement="before",
							class="input")#
					</li>
					<li>
						#submitTag(value="Szukaj",class="button redButton placesajaxsearch")#
					</li>
				</ol>
				#endFormTag()#
			</div> <!--- Koniec okienka z zaawansowanym wyszukiwaniem --->
		
		</div> <!--- Koniec wrappera zaawansowanego wyszukiwania --->
		
		<div class="ajaxcontent"> <!--- Wrapper wyników wyszukiwania --->
		
			
		
		</div> <!--- Koniec wrappera wyników wyszukiwania --->
	
	</div>

</cfoutput>

<script>
$(function() {
	$('form').submit(function(e) {
		$('#flashMessages').show();
		e.preventDefault();
		
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		$(this).serialize(),
			url			:		<cfoutput>"#URLFor(controller='Places',action='search')#"</cfoutput>,
			success		:		function(data) {
				$('.ajaxcontent').html(data);
				$('#flashMessages').hide();
			}
		});
<!--- 		return false;	 --->
	});
		
});
</script>