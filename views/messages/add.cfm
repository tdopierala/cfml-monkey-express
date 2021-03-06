<cfoutput>

	<div class="wrapper">

		<h3>Dodaj nowy komunikat</h3>

		<div class="wrapper">
			<cfoutput>#includePartial(partial="/users/subnav")#</cfoutput>
		</div>

		<div class="forms">
			#startFormTag(controller="Messages",action="actionAdd")#
				<ol class="horizontal">
					<li>
						#select(
							objectName="message",
							property="messagepriorityid",
							options=messagepriorities,
							label="Priorytet komunikatu",
							labelPlacement="before")#
					</li>
					<li>
						#textField(
							objectName="message",
							property="messagetitle",
							class="input",
							label="Nagłówek komunikatu",
							labelPlacement="before")#
					</li>
					<li>
						#textArea(
							objectName="message",
							property="messagebody",
							class="textarea ckeditor",
							label="Treść komunikatu",
							labelPlacement="before")#
					</li>
					<li>
						<span class="messagelabelspan">Ważność komunikatu</span>
						#textField(
							objectName="message",
							property="messagestartdate",
							class="inputSmall messagestartdate date_picker",
							placeholder="od:",
							label=false)#

						#textField(
							objectName="message",
							property="messagestopdate",
							class="inputSmall messagestopdate date_picker",
							placeholder="do: ",
							label=false)#
					</li>
					<li>#submitTag(value="Zapisz",class="button redButton fltr")#</li>
				</ol>
			#endFormTag()#

			<div class="clear"></div>

		</div>

	</div>

</cfoutput>

<script type="text/javascript">

	$(function() {
		$('.date_picker').datepicker({
			showOn: "both",
			buttonImage: "images/schedule.png",
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
			dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So']
		});

	});

</script>