<cfprocessingdirective pageencoding="utf-8" />
	
<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Ścieżka edukacji</h3>
		</div>
	</div>

	<div class="headerNavArea">
	<div class="headerNavArea uiHeaderNavArea">
		<ul class="uiHeaderNavAreaList">
			<li>
				<a
					href="javascript:ColdFusion.navigate('index.cfm?controller=user_educations&action=education', 'user_education_div');"
					title="Szkoły i uczelnie"
					class="active">
					Szkoły i uczelnie
				</a>
			</li>
			
			<li class="rborder">
				<a 
					href="javascript:ColdFusion.navigate('index.cfm?controller=user_educations&action=courses', 'user_education_div');"
					title="Kursy i szkolenia"
					class="">
					Kursy i szkolenia
				</a>
			</li>
		</ul>
	</div>
	</div>
	
	<div class="contentArea">
		<div class="contentArea uiContent">

			<cfdiv id="user_education_div">
				<cfinclude template="_education.cfm" />
			</cfdiv>

		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>