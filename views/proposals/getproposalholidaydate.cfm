<cfoutput>
<li class="proposaldates">
	<label for="proposalholidaydatefrom-657-0">Urlop w dniach</label>
			
	#textFieldTag(
		name="proposalholidaydate[#datefrom#][#rand#]",
		value="",
		label=false,
		class="smallInput date_pick_up required fltl",
		placeholder="Data od")#
	
	#textFieldTag(
		name="proposalholidaydate[#dateto#][#rand#]",
		value="",
		label=false,
		class="smallInput date_pick_up required fltl",
		placeholder="Data do")#
		
	<span class="newproposaldate">dodaj wiersz</span>
	<span class="deleterow">usuń wiersz</span>
</li>
</cfoutput>
<script type="text/javascript">

$(function() {

	$('.date_pick_up').datepicker({
		showOn: "focus",
		buttonImageOnly: true,
		dateFormat: 'dd-mm-yy',
		monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
		dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So'],
		firstDay: 1
	});

});

</script>