<cfoutput>

	<div class="advancedfilters">
	
		<h4>Filtruj instrukcje</h4>
	
		#startFormTag(action="getInstructions",class="instructionfilterform")#
			<ol>
			
				<li>
					<span class="filterdescription">Kategoria</span>
					
					#selectTag(
						name="instructioncategoryid",
						options=instructioncategories,
						label=false)#
				</li>
				
				<li>
				
					<span class="filterdescription">Data dodania</span>
					
					#textFieldTag(
						name="datefrom",
						class="smallInput date_picker",
						placeholder="Data dodania od",
						label=false)#
						
					#textFieldTag(
						name="dateto",
						class="smallInput date_picker",
						placeHolder="do",
						label=false)#
				</li>
				
				<li style="width:100%;">
				
					#submitTag(value=">>",class="instructionButton fltr")#

				</li>
			
			</ol>
		#endFormTag()#
	
		<div class="clear"></div>
	
	</div>

</cfoutput>

<script type="text/javascript">
$(function() {
	$('.instructionButton').live('click', function(e) {
		e.preventDefault();
		
		$('#flashMessages').show();
		var formData = $('.instructionfilterform').serialize();
		$.ajax({
			type		:		'post',
    		dataType	:		'html',
    		data		:		formData,
    		url			:		<cfoutput>"#URLFor(controller='Instructions',action='getInstructions',format='json',params='cfdebug')#"</cfoutput>,
    		success		:		function(data) {
    			$('.instructions').html(data);
    			$('#flashMessages').hide();
    		}
		});
		
	});
	
	$('.date_picker').datepicker({

		dateFormat: 'yy-mm-dd',
		monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
		dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So']
	});
});
</script>