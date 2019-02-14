<cfsilent>
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="kosP" >
		<cfinvokeargument name="groupname" value="KOS" />
	</cfinvoke>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

	<div class="leftWrapper">
		<div class="headerArea">
			<div class="headerArea uiHeader">
				<h3 class="uiHeaderTitle">Odwołania od AOS</h3>
			</div>
		</div>
		
		<div class="headerNavArea">
			<div class="headerNavArea uiHeaderNavArea">

			</div>
		</div>
		
		<div class="contentArea">
			<div class="contentArea uiContent">

				<table class="uiTable aosTable" id="mainAosTable">
					<thead>
						<tr>
							<!---<th class="leftBorder topBorder rightBorder bottomBorder">PPS</th>--->
							<th class="leftBorder topBorder rightBorder bottomBorder"><span>Sklep</span></th>
							<th class="topBorder rightBorder bottomBorder"><span>Część</span></th>
							<th class="topBorder rightBorder bottomBorder"><span>Pytanie</span></th>
							<th class="topBorder rightBorder bottomBorder"><span>Data odwołania</span></th>
							<th class="topBorder rightBorder bottomBorder"><span>Uzasadnienie</span></th>
							<th class="topBorder rightBorder bottomBorder">&nbsp;</th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="odwolania">
							<tr>
								<!---<td class="leftBorder bottomBorder rightBorder l"></td>--->
								<td class="leftBorder bottomBorder rightBorder l">#kodsklepu#</td>
								<td class="bottomBorder rightBorder l">#nazwazadania#</td>
								<td class="bottomBorder rightBorder l">#nazwapola#</td>
								<td class="bottomBorder rightBorder r">#DateFormat(dataodwolania, "yyyy/mm/dd")#</td>
								<td class="bottomBorder rightBorder l">#trescodwolania#</td>
								<td class="bottomBorder rightBorder c">
									<cfif kosP is false>
									<!---<a href="javascript:void(0)" onclick="acceptAppeal(#id#, $(this))" class="accept" title="Akceptuje"><span>Akceptuje</span></a>--->
									<!---<a href="javascript:void(0)" onclick="declineAppeal(#id#, $(this))" class="decline" title="Odrzucam"><span>Odrzucam</span></a>--->
									<a href="javascript:showCFWindow('odwolanie#id#', 'Odwołanie od oceny AOS', 'index.cfm?controller=eleader&action=appeal&id=#id#')" class="icon-appeal" title="Rozpatrz odwołanie"><span>Rozpatrz odwołanie</span></a>
									</cfif>
									
								</td>
							</tr>
						</cfoutput>
					</tbody>
				</table>
				
			</div><!-- /end contentArea uiContent -->
		</div> <!-- /end contentArea -->
		
		<div class="footerArea">
			
			
		</div> <!-- /end footerArea -->
	
	</div>

	<cfset ajaxOnLoad("sortowanie") />

<script type="text/javascript">
$(function(){
	
	var len = $('script').filter(function () {
		return /^.*intranet\/javascripts\/ajaximport\/initEleader.*/.test( $(this).attr('src') );
	}).length;
	
	if (len === 0) {
		$.getScript("javascripts/ajaximport/initEleader.js");
	}
});
</script>