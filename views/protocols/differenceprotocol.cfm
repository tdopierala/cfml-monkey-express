<cfoutput>
	<h4>Protokół</h4>
	<table class="tables" id="protocolContentTable">
		<thead>
			<tr>
				<cfloop query="protocolfields">
					<th class="c">#attributename#</th>
				</cfloop>
			</tr>
		</thead>
		<tbody>
			<tr class="start">
				<cfloop query="protocolfields">
					<td class="c leftBorder bottomBorder <cfif attributeid eq 119>rightBorder</cfif>">
						<cfset inputclass = "c" />
						<cfset inputvalue = "" />
						
						<cfif attributetypeid eq 4>
							
							<cfset inputclass &= " date_picker " />
						
						</cfif>
						
						<cfif attributeid eq 114>
						
							<cfset inputclass &= " autocompleteindex " />
						
						</cfif>
						
						<cfif attributeid eq 115>
							
							<cfset inputclass &= " autocompleteproduct l" />
							
						</cfif>
						
						<cfif attributeid eq 120>
						
							<cfset inputclass &= " verySmallProtocolInput c " />
							<cfset inputvalue = session.protocol.lp />
							
						<cfelse>
						
							<cfset inputclass &= " smallProtocolInput " />
						
						</cfif>
						
						<cfif attributeid eq 116>
						
							#selectTag(
								name="protocolcontent[start][#attributeid#]",
								options=selectoptions,
								class="#inputclass#")#
						
						<cfelseif attributeid eq 119>
						
							#selectTag(
								name="protocolcontent[start][#attributeid#]",
								options=returnselectoptions,
								class="#inputclass#")#

						<cfelseif attributeid eq 140>
						
							#textAreaTag(
								name="protocolcontent[start][#attributeid#]",
								class="textarea")#
						
						<cfelse>
						
							#textFieldTag(
								name="protocolcontent[start][#attributeid#]",
								value="#inputvalue#",
								class="#inputclass#")#
						
						</cfif>
								
					</td>
				</cfloop>
			</tr>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="7"><span class="addDifferenceProtocolRow fltr">+dodaj wiersz</span></td>
			</tr>
		</tfoot>
	</table>
	
	#submitTag(value="Zapisz",class="button redButton fltr saveProtocol")#
	
	<div class="clear"></div>
	
</cfoutput>

<script type="text/javascript">
	$(function () {
		$('.addDifferenceProtocolRow').live('click', function (e) {
			e.preventDefault();
			$('#flashMessages').show();
			
			var id = $('#protocoltypeid option:selected').attr('value');
			$.ajax({
				type		:		'get',
				dataType	:		'html',
				data		:		{protocoltypeid:id},
				url			:		<cfoutput>"#URLFor(controller='Protocols',action='getProtocolContentRow',params='cfdebug')#"</cfoutput>,
				success		:		function(data) {
					$('#flashMessages').hide();
					$('#protocolContentTable tbody tr:last').after(data);
				},
				error		:		function(xhr, ajaxOptions, throwError) {
					$('#flashMessages').hide();
					alert("Wystąpił błąd w aplikacji.");
				}
			});
		});
		
		/**
		 * Wyszukiwanie w okienku do wpisania indeksu
		 */
		$('.autocompleteindex').live('keyup', function (e) {
			$(this).autocomplete({
				source		:		function(request, response) {
					$.getJSON(<cfoutput>"#URLFor(controller='Asseco',action='getIndexes',params='cfdebug')#"</cfoutput>, {search: request.term}, response);				
				},
				select		:		function(element, ui) {
					$(this).parent().parent().find('.autocompleteproduct').val(ui.item.label);
				}
			});
		});
		
		$('.date_picker').datepicker({
			showOn: "focus",
			dateFormat: 'yy-mm-dd',
			monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
			dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So']
		});

		
	});
</script>
