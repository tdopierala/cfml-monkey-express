<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitleSmall">Definicje pól</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<table class="uiTable">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder">Nazwa pola</th>
						<th class="topBorder rightBorder bottomBorder">Typ pola</th>
						<th class="topBorder rightBorder bottomBorder"></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="pola">
						<tr>
							<td class="leftBorder bottomBorder rightBorder l">#nazwaPola#</td>
							<td class="bottomBorder rightBorder l">#nazwaTypuPola#</td>
							<td class="bottomBorder rightBorder"></td>
						</tr>
					</cfoutput>
				</tbody>
			</table>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
		
		<cfdiv id="rekrutacja_definicje_pol">
			<cfform name="definicjePol" action="index.cfm?controller=rekrutacja_pola&action=zapisz-pole">
				<ol class="horizontal_right">
					<li>
						<label for="nazwaPola">Nazwa pola</label>
						<cfinput type="text" class="input" name="nazwaPola" />
					</li>
					<li>
						<label for="idTypuPola">Typ pola</label>
						<select name="idTypuPola" class="select_box">
							<cfoutput query="typyPol">
								<option value="#idTypuPola#">#nazwaTypuPola#</option>
							</cfoutput>
						</select>
					</li>
					<li>
						<span class="labelBlock">&nbsp;</span>
						<cfinput type="submit" name="definicjePolSubmit" class="btn btn-green" value="Zapisz" />
					</li>
				</ol>
			</cfform>
		</cfdiv>
		
	</div>

</div>
