<style type="text/css">
	div.groups-sortable-row { background-color: #e1e1e1; }
	
	ul.groups-sortable-root ul { margin: 0; margin-left: 30px; }
	ul.groups-sortable-root div.groups-sortable-row { padding: 10px; }
	ul.groups-sortable-root li { margin: 5px 0; }
	.placeholder { outline: 1px dashed #4183C4; margin: -1px; min-height: 50px; }
</style>
<!---<script language="JavaScript">
	(function($) {
		$.fn.domNext = function() { return this.children(":eq(0)").add(this.next()).add(this.parents().filter(function() { return $(this).next().length > 0; }).next()).first(); };
		$.fn.domPrev = function() { return this.prev().find("*:last").add(this.parent()).add(this.prev()).last(); };
	})(jQuery);
	function lastNode(obj){ if (obj.has('ol').length > 0) return lastNode(obj.children("ol").children("li:last-child")); else return obj; }
</script>--->
<cfoutput>
	<div class="wrapper">
		<h3>Struktura organizacyjna</h3>
		
		<!---<cfdump var="#tree#">
		<cfabort />--->
		
		<div class="wrapper companystructure">
			
			<ul class="groups-sortable-root" id="id_0">
			
				<cfset prevlvl = 0 />
				<cfloop array="#tree#" index="idx">
					
					<cfif not IsStruct(idx)>
						<cfif idx neq departname and idx neq ''>
							
							<li class="groups-sortable-branch">
								<div class="groups-sortable-row">#idx#</div>
					<cfelse>
						<cfif idx.depth lt prevlvl>
							<cfset i = prevlvl - idx.depth />
							<cfloop index="c" from="1" to = "#i#" > 
								</ul></li>
							</cfloop>
						</cfif>
							
							<li class="groups-sortable-branch">
								<div class="groups-sortable-row" id="id_#idx.id#">
									<cfif FileExists(ExpandPath("images/avatars/thumbnailsmall")&"/#idx.photo#")>
										
										#imageTag(source="avatars/thumbnailsmall/#idx.photo#",class="userimg")#
										
									<cfelse>
										
										#imageTag(source="avatars/monkeyavatar.png",alt="#idx.name#",title="#idx.name#",class="userimg")#
										
									</cfif>
									
									#idx.name# <span>(#idx.position#)</span>
									
									#mailTo(emailAddress=idx.mail,name=idx.mail)#
								</div>
								
						<cfif (idx.rgt - idx.lft) gt 1 >
							<ul>
						<cfelse>
								</li>
						</cfif>
						
						<cfset prevlvl = idx.depth />
					</cfif>
					
				</cfloop>
				</li>
			</ul>
			
		</div>
	</div>
</cfoutput>
<script language="JavaScript">
	$(function(){
		$( ".groups-sortable-root .li-disabled" ).disableSelection();
		
		$('.groups-sortable-root').nestedSortable({
			handle: 'div',
			items: 'li',
			listType: 'ul',
			placeholder: 'placeholder',
			opacity: 0.5,
			stop: function( event, ui ){
				var li = $(ui.item);
				var prev = 0, next = 0;
				
				if( li.is("li:first-child") )
					prev = li.parent().prev().attr("id").substring(3);
				else
					if (li.prev().has('ol').length > 0) {
						var obj = lastNode($(li.prev()));
						prev = obj.children('div').attr("id").substring(3);
					}
					else 
						prev = li.prev().children().attr("id").substring(3);
				
				if ( li.has('ol').length > 0 )
					next = li.children("ol").children("li:first-child").children('div').attr("id").substring(3);
				else
					if( li.is("li:last-child") )
						next = li.parent().parent().next().children().attr("id").substring(3);
					else
						next = li.next().children().attr("id").substring(3);
				
				//alert(prev + ' > < ' + next);
			},
			update: function ( event, ui ) {
				
				/*$.ajax({
					type		:	'post',
					dataType	:	'html',
					data		:	{
										my_id		:	$(ui.item).children().attr("id").substring(3),
										parent_id	:	$(ui.item).parent().prev().attr("id").substring(3)
									},
					url			:	"<cfoutput>#URLFor(controller='Groups_tmp',action='moveObject')#</cfoutput>",
					success		:	function(data) {						
						//alert('OK!');
					}
				});*/
			}
		});
	});
</script>