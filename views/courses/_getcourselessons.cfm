<cfoutput>
	<h4>Harmonogram zajęć</h4>
	
		<table class="lesson-list">
			<thead>
				<tr>
					<th>Tytuł</th>
					<th>Instruktor</th>
					<th><cfif params.key neq 2>Data</cfif></th>
					<th></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="lessonsTemplate">
					<tr>
						<td class="lesson-topic">
							<span>#subject#</span>
							<input type="hidden" name="topicid" value="#topicid#" />
						</td>
						<td class="lesson-trainer">
							<span>#trainername#</span>
							<input type="hidden" name="trainer" value="#trainerid#" />
							<input type="hidden" name="trainername" value="#trainername#" />
						</td>
						<td>
							<cfif params.key neq 2>
								<input type="text" name="lessondate" placeholder="data" value="2014-01-01" class="input datepicker text-field-tag ui-corner-all" />
								<!---<input type="text" name="lessontimefrom" placeholder="od" value="08:00" class="input timespinner text-field-tag" />--->
								<!---<input type="text" name="lessontimeto" placeholder="do" value="16:00" class="input timespinner text-field-tag" />--->
							</cfif>
						</td>
						<td class="lesson-exam">
							<!---<cfif params.key neq 2>
								<input type="checkbox" name="lessonexamcheckbox" value="1" class="lessoncheckbox" />
								<input type="hidden" name="lessonexam" value="0" />
							</cfif>--->
						</td>
						<td class="lesson-close">
							#linkTo(
								text=imageTag("close.png"),
								href="##",
								class="remove-lesson")#
						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>

	
	<ol class="add-lesson-list">
		<li>
			<span class="select-field">
				#selectTag(
					name="_topicid", 
					options=lessons,
					includeBlank="-- wybierz temat --",
					class="select-tag")#
			</span>
			<span class="text-field">
				#textFieldTag(
					name="_trainer",
					class="input text-field-tag",
					placeholder="wyszukaj użytkownika")#
			</span>
			<span>
				#linkTo(
					text=imageTag("plus.png"),
					href="##",
					class="add-lesson")#
			</span>
		</li>
	</ol>
	
	<div class="form-submit">
		#submitTag(value="Zapisz", class="formButton button redButton courseSave")#
	</div>		
	
</cfoutput>
<!---<cfdump var="#lessons#" >--->
<script>
	$(function(){
		
		var datepickerOptions={
			showOn: "both",
			buttonImage: "images/schedule.png",
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
			dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So'],
			firstDay: 1
		};
		
		$('.datepicker').datepicker(datepickerOptions);
		
		$.widget( "ui.timespinner", $.ui.spinner, {
			options: { step: 60 * 1000, page: 60 },
			_parse: function( value ) {
				Globalize.culture("pl-PL");
				if ( typeof value === "string" ) {
					if ( Number( value ) == value ) return Number( value );
					return +Globalize.parseDate( value );
				}
				return value;
			},
			_format: function( value ) {
				return Globalize.format( new Date(value), "t" );
			}
		});
		
		$(".timespinner").timespinner();
		
		$(".add-lesson").on("click", function(){
			
			$this = $(this).closest("li");
			$user = $this.find(".text-field").children("input");
			
			var row = {
				topicid	: $this.find("#_topicid").val(),
				subject	: $this.find("#_topicid option[value='" + $this.find("#_topicid").val() + "']").text(),
				userid	: typeof $user.data("userid") != 'undefined' ? $user.data("userid") : 0,
				username: typeof $user.val() != 'undefined' ? $user.val() : ''
			};
			
			if( row.topicid == '' || row.username == '' )
				return false;
			
			var d = new Date();
			var day = d.getFullYear() + '-' + d.getMonth() + '-' + d.getDate();
			var time = d.getHours() + ':' + d.getMinutes();
			
			$(".lesson-list").find("tbody").append(
				$("<tr>")
					.append(
						$("<td>")
							.addClass("lesson-topic")
							.append( 
								$("<span>").text(row.subject))
							.append(
								$("<input>").attr("type", "hidden").attr("name", "topicid").val(row.topicid)))
					.append(
						$("<td>")
							.addClass("lesson-trainer")
							.append(
								$("<span>").text(row.username))
							.append( 
								$("<input>").attr("type", "hidden").attr("name", "trainer").val(row.userid))
							.append( 
								$("<input>").attr("type", "hidden").attr("name", "trainername").val(row.username)))
					.append(
						$("<td>")
							.append(
								$("<input>").addClass("input datepicker text-field-tag ui-corner-all").attr("name","lessondate").attr("placeholder","data").attr("type","text").val(day)).append(" ")
							/*.append(
								$("<input>").addClass("input timespinner text-field-tag").attr("name","lessontimefrom").attr("placeholder","od").attr("type","text").val(time)).append(" ")*/
							/*.append(
								$("<input>").addClass("input timespinner text-field-tag").attr("name","lessontimeto").attr("placeholder","do").attr("type","text").val(time))*/
						)
					.append(
						$("<td>")
							.addClass("lesson-exam")
							.append(
								$("<input>").addClass("lessoncheckbox").attr("name","lessonexamcheckbox").attr("type","checkbox").val(1))
							.append(
								$("<input>").attr("name","lessonexam").attr("type","hidden").val(0)))
					.append(
						$("<td>")
							.addClass("lesson-close")
							.append(
								$("<a>").attr("href","#").append(
									$("<img>").addClass("remove-lesson").attr("src","images/close.png"))))
			);
			
			
			$(".lesson-list tbody tr:last-child").find(".datepicker").datepicker(datepickerOptions);
			$(".lesson-list tbody tr:last-child").find(".timespinner").timespinner();
			
			$this.find("#_topicid").val('');
			$this.find("#_trainer").val('');
			$this.find("#_trainer").removeData("userid");
			$this.find("#_trainer").removeData("username");
			
			return false;
		});
		
		$(".lesson-list tbody").on("click", ".lessoncheckbox", function(){
			if($(this).is(':checked'))
				$(this).next().val(1);
			else
				$(this).next().val(0);
		});
		
	});
</script>