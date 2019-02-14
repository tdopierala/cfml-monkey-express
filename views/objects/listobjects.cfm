<ul class="uiObjectTreeStruct">
	<cfoutput query="obiekty">
		<li class="level-#level# {id:#id#, lft:#def_lft#, rgt:#def_rgt#}">
			<span class="object_item">#def_name# (<a href="javascript:void(0)" onclick="initCfWindow('index.cfm?controller=objects&action=object-attributes&defid=#id#', 'Atrybuty obiektu')" title="Atrybuty obiektu" class="object_attr">atrybuty</a> | 
			<a href="javascript:ColdFusion.navigate('index.cfm?controller=objects&action=delete-object-def&key=#id#', 'uiObjectsContainer')" title="Usuń obiekt" class="object_delete">usuń</a> | 
			<a href="" title="Przypisz grupy" class="object_tree_groups">przypisz grupy</a>)</span>
		</li>
	</cfoutput>
</ul>

<cfset ajaxOnLoad("initObjectDef")>