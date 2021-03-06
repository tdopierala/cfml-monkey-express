<cfoutput>

	<div class="wrapper">
	
		<h3>Dodaj protokół</h3>
	
		<div class="wrapper">
		
			<cfoutput>#includePartial(partial="/protocols/subnav")#</cfoutput>
		
		</div>
		
		<!--- Początek formularza generowania protokołu --->
		#startFormTag(action="actionAddProtocol",multipart=true)#
		
			<div class="forms">
				<ol>
					<li>
						#selectTag(
							name="protocoltypeid",
							options=protocoltypes,
							label="Wybierz typ protokołu",
							labelPlacement="before",
							includeBlank=true,
							class="protocoltype")#
					</li>
				</ol>
			</div>
		
			<div class="forms protocolheader">
				
			</div>
			
			<div class="forms protocolcontent">
				
			</div>
			
		#endFormTag()#
		<!--- Koniec formularza generowania protokołu --->
		
	</div>

</cfoutput>

<script type="text/javascript">

	$(function () {
		$('.protocoltype').live('change', function (e) {
			e.preventDefault();
			var id = $(this).attr('value');
			
			$('#flashMessages').show();
			
			$.ajax({
				type		:		'get',
	    		dataType	:		'html',
	    		url			:		"index.cfm?controller=protocols&action=get-protocol-header&key=" + id + "&params=cfdebug",
	    		success		:		function(data) {
	    			$('.protocolheader').html(data);
	    			$('.protocolheader').show();
	    			$('#flashMessages').hide();
	    		}
			});
			
			$.ajax({
				type		:		"get",
				dataType	:		"html",
				url			:		"index.cfm?controller=protocols&action=get-protocol-content&key=" + id + "&params=cfdebug",
				success		:		function(data) {
					$('.protocolcontent').html(data);
					$('.protocolcontent').show();
					$('#flashMessahes').hide();
				}
			});
			
		});
		
		/*
		 * Kiedy formularz został już pobrany dodaję reguły walidacji pól formularza.
		 * Jedyna walidacja na tą chwilę to wymuszenie wpisania treści w wymagane pola.
		 * Jeśli nie będą wypełnione wymagane pola, system zwróci komunikat.
		 */
		$('.saveProtocol').live('click', function(e) {
			
			/*
	    	 * Usunięcie poprzednich komunikatów walidacji.
	    	 */
	    	 $('.required').removeClass('redborder');
	    	 $('.validationerror').remove();
	    	
	    	/*
	    	 * Walidacja - sprawdzenie czy wypełniono wszystkie wymagane pola formularza
	    	 */
			var error = false;
			var errorRequired = "<span class=\"validationerror\">Nie uzupełniłeś tego pola. Jest ono wymagane aby zapisać formularz.</span>";
			
			$('.required').each(function(i) {
				if (!$(this).attr('value').length) {
					$(this).addClass('redborder');
					$(this).parent().append(errorRequired);
					error = true;
				}
			});

			if (error) e.preventDefault();

		});


	});

</script>