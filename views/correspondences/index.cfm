<cfoutput>

	<div class="wrapper">

		<div class="admin_wrapper">

			<h2 class="tree_group_sprite correspondence">Korespondencja</h2>

			<cfinvoke
			component="controllers.Tree_groupusers"
			method="checkUserTreeGroup"
			returnvariable="priv" >

			<cfinvokeargument
				name="groupname"
				value="Rejestr poczty przychodzącej" />

			</cfinvoke>

			<!---
				20.03.2013
				Rejestr poczty przychodzącej
			--->
			<cfif priv is not false>

				<cfdiv id="refreshCorrespondenceIn">
					#includePartial(partial="rejestr_poczty_przychodzacej")#
				</cfdiv>

			</cfif>

			<cfinvoke
			component="controllers.Tree_groupusers"
			method="checkUserTreeGroup"
			returnvariable="priv" >

			<cfinvokeargument
				name="groupname"
				value="Rejestr poczty wychodzącej" />

			</cfinvoke>

			<!---
				20.03.2013
				Rejestr poczty wychodzącej
			--->
			<cfif priv is not false>

				<cfdiv id="refreshCorrespondenceOut">
					#includePartial(partial="_rejestr_poczty_wychodzacej")#
				</cfdiv>

			</cfif>

			<cfinvoke
			component="controllers.Tree_groupusers"
			method="checkUserTreeGroup"
			returnvariable="priv" >

			<cfinvokeargument
				name="groupname"
				value="Książka nadawcza" />

			</cfinvoke>

			<!---
				20.03.2013
				Książka nadawcza
			--->
			<cfif priv is not false>
				<cfdiv id="refreshCorrespondence">
					#includePartial(partial="_ksiazka_nadawcza")#
				</cfdiv>
			</cfif> <!--- Koniec książki korespondencji --->

		</div>

	</div>

</cfoutput>

<script>
$(function() {
	$('.new_correspondence').live('click', function (e) {
		e.preventDefault();
		$('#flashMessages').show();
		$.ajax({
			type		:	'post',
			dataType	:	'html',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function(data) {
				$('body').append("<div class=\"curtain\"></div>");
				$('.curtain').append(data);
				$('#flashMessages').hide();
			}
		});
		return false;
	});

	$('.new_normal_letters').live('click', function (e) {
		e.preventDefault();
		$('#flashMessages').show();
		$.ajax({
			type		:	'get',
			dataType	:	'html',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function(data) {
				$('body').append("<div class=\"curtain\"></div>");
				$('.curtain').append(data);
				$('#flashMessages').hide();
			}
		});
		return false;
	});

	$('.pick_up_date').live('click', function(e) {
		$(this).datepicker({
			dateFormat: 'yy-mm-dd',
			monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
			dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So'],
			firstDay: 1,
			showOn:'focus'
		}).focus();
	});

	<!---
		Dodawanie nowej poczty przychodzącej
	--->
	$('.new_correspondence_in').live('click', function(e) {
		e.preventDefault();
		$('#flashMessages').show();
		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function(data) {
				$('body').append("<div class=\"curtain\"></div>");
				$('.curtain').append(data);
				$('#flashMessages').hide();
			}
		});
	});

	<!---
		Dodawanie korespondencji wychodzącej
	--->
	$('.new_correspondence_out').live('click', function(e) {
		e.preventDefault();
		$('#flashMessages').show();
		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function(data) {
				$('body').append("<div class=\"curtain\"></div>");
				$('.curtain').append(data);
				$('#flashMessages').hide();
			}
		});
	});

	<!---
		Zamykam okienko.
	--->
	$('.close_curtain').live('click', function (e) {
		$('.curtain').remove();
	});

});
</script>