<cfprocessingdirective pageencoding="utf-8" />

<cfsilent>
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
		<cfinvokeargument name="groupname" value="Partner prowadzacy sklep" />
	</cfinvoke>
	
	
</cfsilent>

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Arkusze Oceny Sklepu</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<cfif pps is not true>
				<cfform name="eleader_aos_filtr_formularz" action="index.cfm?controller=eleader&action=aos-sklepu-v2&t=true" >
					<ol class="filters" style="height:65px;line-height:25px;">
						<li>
							<cfinput type="text"  name="sklep" class="input" placeholder="Kod sklepu" value="#session.aosSklepu.sklep#" /> 
						</li>
						<li>
							<cfinput type="datefield" name="aosSklepuOd" class="input" placeholder="Data od" validate="eurodate" mask="dd/mm/yyyy" value="#DateFormat(session.aosSklepu.aosSklepuOd, "dd/mm/yyyy")#" /> 
						</li>
						<li>
							<cfinput type="datefield" name="aosSklepuDo" class="input" placeholder="Data do" validate="eurodate" mask="dd/mm/yyyy" value="#DateFormat(session.aosSklepu.aosSklepuDo, "dd/mm/yyyy")#" />
						</li>
						<li>
							<select name="kosEmail" class="select_box">
								<option value="">[Nazwisko KOS]</option>
								<cfoutput query="kos">
									<option value="#mail#" <cfif mail EQ session.aosSklepu.kosEmail>selected="selected"</cfif>>#usr#</option>
								</cfoutput>
							</select>
						</li>
						<li class="clear">
							<input type="radio" name="odwolania" value="1" <cfif session.aosSklepu.odwolania EQ 1>checked="checked"</cfif>/> TAK
							<input type="radio" name="odwolania" value="0" <cfif session.aosSklepu.odwolania EQ 0>checked="checked"</cfif>/> NIE 
							<input type="radio" name="odwolania" value="-1" <cfif session.aosSklepu.odwolania EQ -1>checked="checked"</cfif>/> WSZYSTKIE 
						</li>
						<li><cfinput type="submit" class="admin_button green_admin_button" name="eleader_aos_filter_formularz_submit" value=">>"/></li>
					</ol>
				</cfform>
			</cfif>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<table class="uiTable">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder w24">&nbsp;</th>
						<th class="topBorder rightBorder bottomBorder">Numer sklepu</th>
						<th class="topBorder rightBorder bottomBorder">Data kontroli</th>
						<th class="topBorder rightBorder bottomBorder">Osoba kontrolująca</th>
						<th class="topBorder rightBorder bottomBorder">Ilość odwołań</th>
						<th class="topBorder rightBorder bottomBorder">&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="arkusze">
						<tr>
							<td class="leftBorder bottomBorder rightBorder">
								<a href="javascript:void(0)" onclick="pobierzArkuszV2('#idaktywnosci#', $(this))" class="extend" title="Pobierz arkusz"><span>&nbsp;</span></a>
							</td>
							<td class="bottomBorder rightBorder l">#kodsklepu#</td>
							<td class="bottomBorder rightBorder r">#DateFormat(poczatekaktywnosci, "yyyy/mm/dd")#</td>
							<td class="bottomBorder rightBorder l">#imiepartnera# #nazwiskopartnera#</td>
							<td class="bottomBorder rightBorder r">
								<cfif pps is true>
									
									<cfif iloscodwolan NEQ 0>
										#iloscodwolan#
									</cfif>
									
								<cfelse>
										
									<cfif iloscodwolan NEQ 0>
										<a href="javascript:ColdFusion.navigate('index.cfm?controller=eleader&action=pobierz-odwolanie&idaktywnosci=#idaktywnosci#', 'odwolaniaAos')" class="" title="Pokaż odwołanie">
											#iloscodwolan#
										</a>
									
									</cfif>
										
								</cfif>
							
							</td>
							<td class="bottomBorder rightBorder r"></td>
						</tr>
					</cfoutput>
				</tbody>
			</table>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
		<cfdiv id="odwolaniaAos"></cfdiv>
	</div>

</div>

</cfdiv>

<script type="text/javascript">
$(function(){
	
	var len = $('script').filter(function () {
		return /^.*intranet\/javascripts\/ajaximport\/initEleaderV2.*/.test( $(this).attr('src') );
	}).length;
	
	if (len === 0) {
		$.getScript("javascripts/ajaximport/initEleaderV2.js");
	}
});
</script>