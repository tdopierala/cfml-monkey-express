<cfprocessingdirective pageEncoding="utf-8" />

<cfsilent>
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="privDodaniePlanogramu" >
		<cfinvokeargument name="groupname" value="Dodanie planogramu" />
	</cfinvoke>
	
	
</cfsilent>

<tr>
	
	<td class="first">&nbsp;</td>
	<td class="admin_submenu_options">
		
		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Typ regału</th>
					<th>Akcje</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="myShelfTypes">
					<tr>
						<td>&nbsp;</td>
						<td><cfoutput>#shelftypename#</cfoutput></td>
						<td>
							<a 
								href="javascript:ColdFusion.Window.create('planograms_store_list-<cfoutput>#shelfid#</cfoutput>', 'Lista sklepów', '<cfoutput>#URLFor(controller='Store_planograms',action='shelfStores',params='shelfid=#shelfid#')#</cfoutput>', {height:535,width:550,modal:true,closable:true,draggable:true,resizable:true,center:true,initshow:true})"
								class="store_planograms_options store_planograms_stores"
								title="Lista sklepów">
								<span>Lista sklepów</span>		
							</a>
							
							<cfoutput>
								<a href="javascript:void(0)" onclick="javascript:initCfWindow('index.cfm?controller=store_planograms&action=shelf-planograms&storetypeid=#storetypeid#&shelftypeid=#shelftypeid#&shelfcategoryid=#shelfcategoryid#', 'planograms_planograms_list-#storetypeid#-#shelftypeid#-#shelfcategoryid#', 535, 600, '#shelfcategoryname# / #shelftypename#', true)" class="store_planograms_options store_planograms_planograms" title="Lista Planogramów"><span>Lista planogramów</span></a>
							</cfoutput>
							
							 <!--<a 
								href="javascript:ColdFusion.Window.create('planograms_planograms_list-<cfoutput>#storetypeid#</cfoutput>-<cfoutput>#shelftypeid#</cfoutput>-<cfoutput>#shelfcategoryid#</cfoutput>', 'Lista planogramów', '<cfoutput>#URLFor(controller='Store_planograms',action='shelfPlanograms',params='storetypeid=#storetypeid#&shelftypeid=#shelftypeid#&shelfcategoryid=#shelfcategoryid#')#</cfoutput>', {height:535,width:600,modal:true,closable:true,draggable:true,resizable:true,center:true,initshow:true})"
								class="store_planograms_options store_planograms_planograms"
								title="Lista planogramów">
								<span>Lista planogramów</span>		
							</a>-->
							
							<cfif privDodaniePlanogramu is true>
							
							<a href="javascript:void(0)" class="store_planograms_options store_planograms_add" onclick="javascript:showCFWin(<cfoutput>#storetypeid#</cfoutput>,<cfoutput>#shelftypeid#</cfoutput>,<cfoutput>#shelfcategoryid#</cfoutput>, '<cfoutput>#shelfcategoryname# / #shelftypename#</cfoutput>', 715, 700);">
								<span>Dodaj nowy planogram</span>
							</a>
							
							</cfif>
						</td>
					</tr>
				</cfloop>
			</tbody>
	</td>
	
</tr>