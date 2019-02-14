<cfoutput>
<div id="userTabsDiv" class="tabsHeader tabs_wrapper">
	<ul>
		<li class="fl">
			#linkTo(
				text="<span>Mój profil</span>",
				controller="Users",
				action="getUserProfile",
				key=session.userid,
				params="cfdebug",
				class="home",
				title="Mój profil")#
		</li>
		<li>
			#linkTo(
				text="<span>Aktywne dokumenty</span>",
				controller="Users",
				action="getUserActiveWorkflow",
				key=session.userid,
				params='cfdebug',
				class="docs",
				title="Moje aktywne dokumenty")#
		</li>
		<li>
			#linkTo(
				text="<span>Wszystkie dokumenty</span>",
				controller="Users",
				action="getUserWorkflow",
				key=session.userid,
				class="folder",
				title="Wszystkie dokumenty")#
		</li>
	</ul>
</div>
</cfoutput>

<script type="text/javascript">
/* A observer that reports back */
var observer = function(){
	return {
		gethash:function(){
			parent.bookmarks.fixiframe(window.location.hash);
		}
	};
}();

/* Begin observer on load */
window.onload = function(){
	setInterval("observer.gethash()", 400);
}
</script>
