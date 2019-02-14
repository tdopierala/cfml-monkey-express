<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="contentArea">
	<div class="contentArea uiContent">
		
		<cfloop collection="#polaAnkiet#" item="ankieta" >
			<div class="polaAnkiety">
				<div class="inner">
					<h5><cfoutput>#polaAnkiet[ankieta]["NAZWAANKIETY"]#</cfoutput></h5>
					<ol>
						<cfset pola = polaAnkiet[ankieta]['POLA'] />
						<cfloop query="pola">
							<li><cfoutput>#nazwaPola#</cfoutput></li>
						</cfloop>
					</ol>
				</div>
			</div>
		</cfloop>
		
		<div class="uiFooter">
			<cfdiv id="rekrutacja_przypisz_do_ankiety">
				<cfform name="przypiszPoleDoAnkiety" action="index.cfm?controller=rekrutacja_pola&action=dodaj-pole-do-ankiety">
					<ol class="horizontal_right">
						<li>
							<label for="idDefinicjiPola">Nazwa pola</label>
							<select name="idDefinicjiPola" class="select_box">
								<cfoutput query="definicjePol">
									<option value="#definicjePol.idDefinicjiPola#">#definicjePol.nazwaPola#</option>
								</cfoutput>
							</select>
						</li>
						<li>
							<label for="idDefinicjiAnkiety">Nazwa ankiety</label>
							<select name="idDefinicjiAnkiety" class="select_box">
								<cfoutput query="definicjeAnkiet">
									<option value="#definicjeAnkiet.idDefinicjiAnkiety#">#definicjeAnkiet.nazwaAnkiety#</option>
								</cfoutput>
							</select>
						</li>
						<li>
							<span class="labelBlock">&nbsp;</span>
							<cfinput type="submit" name="przypiszPoleDoAnkiety" value="Zapisz" class="btn btn-green" />
						</li>
					</ol>
				</cfform>
			</cfdiv>
		</div>
	</div>
</div>

