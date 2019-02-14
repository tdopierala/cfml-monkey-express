<cfprocessingdirective pageencoding="utf-8" />

<div class="widgetBox">
	<div class="inner">

		<div class="widgetHeaderArea">
			<div class="widgetHeaderArea uiWidgetHeader">
				<h3 class="uiWidgetHeaderTitle">Suma dni przetrzymanych faktur</h3>
			</div>
		</div>

		<div class="widgetContentArea">
			<div class="widgetContentArea uiWidgetContent">

				<cfdiv id="WidgetPrzetrzymaneFakturyEtapami" class="uiWidgetChart uiContent" bind="url:index.cfm?controller=widget_widgets&action=przetrzymane-faktury-etapami-widget" />

				<div class="uiWidgetFooter">
					Raport prezentuje sumę dni przetrzymanych faktur.
				</div>
			</div>
		</div>

		<div class="clearfix"></div>

	</div>
</div>

<!---<cfset ajaxOnLoad("setupPrzetrzymaneFakturyWykresRefresh") />--->