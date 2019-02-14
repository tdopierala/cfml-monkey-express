<cfoutput>
	<div class="wrapper">
		
		<input type="hidden" name="stepid" id="stepid" value="#params.stepid#" />
		<input type="hidden" name="studentid" id="studentid" value="#params.sid#" />
		
		<cfswitch expression="#params.stepid#">
			
			<cfcase value="1">
			
				<h3>Ankieta z systemu eRecruiter</h3>
				
				<div class="wrapper">
					<ol class="recruitmentForm">
						<li>
							<label>Link do ankiety z systemu eRecruiter</label>
							<input type="text" name="message" id="message" class="input" />
							<input type="hidden" name="stepstatus" value="2" id="stepstatus" />
						</li>
					</ol>
				</div>
			
			</cfcase>
			
			<cfcase value="2">
			
				<h3>Spotkanie z kandydatem</h3>
				
				<div class="wrapper">
					<ol class="recruitmentForm">
						<li>
							<label>Czy kandydat przybył na spotkanie?</label>
							<span class="radiobox">Tak&nbsp;<input type="radio" name="stepstatus" value="2" class="stepstatus" /></span>
							<span class="radiobox">Nie&nbsp;<input type="radio" name="stepstatus" value="3" class="stepstatus" /></span>
						</li>
						<li>
							<label>Zaproponowane lokalizacje</label>
							<input type="text" name="message" id="message" class="input" />
							<input type="hidden" name="discard" id="discard" value="" />
						</li>
					</ol>
				</div>
			
			</cfcase>
			
			<cfcase value="3">
			
				<h3>Potwierdzenie chęci współpracy</h3>
				
				<div class="wrapper">
					<ol class="recruitmentForm">
						<li>
							<label>Czy kandydat potwierdził chęć współpracy?</label>
							<span class="radiobox">Tak&nbsp;<input type="radio" name="stepstatus" value="2" class="stepstatus" /></span>
							<span class="radiobox">Nie&nbsp;<input type="radio" name="stepstatus" value="3" class="stepstatus" /></span>
						</li>
						<li>
							<label>Lokalizacja</label>
							<input type="text" name="message" id="message" class="input" />
						</li>
						<li>
							<label>Powód rezygnacji</label>
							<input type="text" name="discard" id="discard" class="input" />
						</li>
					</ol>
				</div>
			
			</cfcase>
			
			<cfcase value="4">
			
				<h3>Skierowanie do weryfikacji KOS</h3>
				
				<div class="wrapper">
					<label>Przekaż do:</label>
					<input type="hidden" name="stepstatus" value="2" id="stepstatus" />
					<input type="hidden" name="kosid" id="kosid" value="" />
					<input type="text" name="message" id="message" class="input select_kos" />
				</div>
			
			</cfcase>
			
		</cfswitch>
		
	</div>
</cfoutput>
<script>
	$(function(){
		
		var t_timeout;
		var _options = {
			source	: 
				function( request, response ) {
					clearTimeout(t_timeout);
					$("#flashMessages").show();
					
					t_timeout = setTimeout(function() {
						$.ajax({
							url			: <cfoutput>"#URLFor(controller='Users',action='get-user-by-group')#"</cfoutput>,
							type		: "get",
							dataType	: "json",
							data		: { 
								group: "KOS",
								search: request.term
							},
							success		: function( data ) {
								console.log(data);
								$("#flashMessages").hide();
								response( $.map( data.DATA, function( item ) {
									return {
										label: item[1],
										value: item[1],
										id: item[0]
									}
								}));
							},
							error: function(){
								$("#flashMessages").hide();
								alert("Błąd wyszukiwania. Spróbuj ponownie później.");
							}
						});
					}, 500);
				}
			,minLength: 2
			,select: function( event,ui ) {
				console.log(ui.item);
				$("#kosid").val(ui.item.id);
			}
		};
		
		$(".select_kos").autocomplete(_options);
	});
</script>