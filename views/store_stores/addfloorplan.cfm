<cfprocessingdirective pageencoding="utf-8" />

<cfsilent>
	<cfinvoke
		component="controllers.Tree_groupusers"
		method="checkUserTreeGroup"
		returnvariable="privDodawanieFloorplanow" >

	<cfinvokeargument
		name="groupname"
		value="Dodawanie floorplanów" />

	</cfinvoke>
	
</cfsilent>

<div class="cfwindow_container clearfix">

	<div class="inner">
		
		<div class="headerArea">
			<div class="headerArea uiHeader">
				<h3 class="uiHeaderTitle">Dodaj floorplan</h3>
			</div>
		</div>

		<div class="contentArea">
			<div class="contentArea uiContent">
				
				<cfif privDodawanieFloorplanow is true>
				
				<cfform name="store_add_floorplan_form" action="#URLFor(controller='Store_stores',action='addFloorplan',key=params.key)#" enctype="multipart/form-data">
							
					<cfinput type="hidden" name="storeid" value="#storeid#" /> 
					
					<ol class="uiList uiForm">
						<li>
							<cfinput type="file" name="filedata" /> 
						</li>
						<li>
							<cfinput type="submit"
									 value="Zapisz"
									 class="admin_button green_admin_button"
									 name="store_add_floorplan_form" />
						</li>
					</ol>
					
				</cfform>
				
				</cfif>
				
				<div class="uiFooter">
				
				</div> <!-- /end uiFooter -->
		
			</div><!-- /end contentArea uiContent -->
		</div><!-- /end contentArea -->
		
		

		<div class="footerArea">
			<ul class="uiList">

				<cfscript>
					// Tutaj znajduje się lista z dodanymi floor planami na sklep
					for (
						i = 1;
						i LTE floorplans.RecordCount;
						i = i + 1
						) {
						
						writeOutput("<li><a href='files/floorplans/#floorplans['filesrc'][i]#' title='#floorplans['filename'][i]#' target='_blank'>#floorplans['filename'][i]#</a></li>");
						
					}
				</cfscript>

			</ul>
		</div> <!-- /end .footerArea -->
	
	</div> <!-- /end .inner -->

</div>
