<cfoutput>
	<div class="wrapper">
		
		<cfswitch expression="#lesson['coursetype'][1]#">
			<cfcase value="1">
				<h4>Szkolenie teoretyczne</h4>
			</cfcase>
			<cfcase value="2">
				<h4>Szkolenie praktyczne</h4>
			</cfcase>
		</cfswitch>
		
		<ol>
			<li> 
				<label>Termin</label>
				<span>#DateFormat(lesson['coursedate'][1],"dd.mm.yyyy")#</span>
			</li>
			<li>
				<label>Miejsce</label>
				<span>#lesson['courseplace'][1]#</span>
			</li>
		</ol>
		
		<table>
			<thead>
				<tr>
					<th>Kurs</th>
					<th>Punkty</th>
					<th>Średnia</th>					
				</tr>
			</thead>
			<tbody>
				<cfloop query="lesson">
					<tr>
						<td>#lessonRates[lesson.clsid]['topic'][1]#</td>
						<td>#lessonRates[lesson.clsid]['rate'][1]#</td>
						<td>
							<cfif lessonRates[lesson.clsid]['rate'][1] neq '' and lessonRates[lesson.clsid]['count'][1] neq ''>
								#(lessonRates[lesson.clsid]['rate'][1] / lessonRates[lesson.clsid]['count'][1])#
							</cfif>
						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
		
	</div>
</cfoutput>