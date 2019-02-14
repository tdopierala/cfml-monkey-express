<cfprocessingdirective pageencoding="utf-8" />

<div class="widgetBox">
	<div class="inner">

		<div class="widgetHeaderArea">
			<div class="widgetHeaderArea uiWidgetHeader">
				<h3 class="uiWidgetHeaderTitle">Moje przetrzymane faktury</h3>
			</div>
		</div>

		<div class="widgetContentArea">
			<div class="widgetContentArea uiWidgetContent">

				<cfdiv id="WidgetPrzetrzymaneFakturyUzytkownika" class="uiWidgetChart uiContent" bind="url:index.cfm?controller=widget_widgets&action=przetrzymane-faktury-uzytkownika-widget" />

				<div class="uiWidgetFooter">
					Raport prezentuje tabelkę z fakturami, które są dłużej niż 3 dni na danym etapie. Raport odświeża się automatycznie co 5 minut.
				</div>
			</div>
		</div>

		<div class="clearfix"></div>

	</div>
</div>

<!---<cfset ajaxOnLoad("setupPrzetrzymaneFakturyUzytkownikaRefresh") />--->