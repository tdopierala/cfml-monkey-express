<cfsilent>
	<cfxml variable="xml">
	<?xml version="1.0" encoding="UTF-8"?>
		<frameChart is3D="false" font="Tahoma-13">
			<frame xDepth="12" yDepth="11" outline="black"/>
			<yAxis scaleMin="0.9" scaleMax="1.0" isAntialiased="true">
				<labelFormat pattern="#,##0.###"/>
				<parseFormat pattern="#,##0.###"/>
				<groupStyle>
					<format pattern="#,##0.###"/>
				</groupStyle>
			</yAxis>
			<xAxis isAntialiased="true">
				<labelFormat pattern="#,##0.###"/>
				<parseFormat pattern="#,##0.###"/>
				<labelStyle orientation="Vertical"/>
			</xAxis>
			<legend
				allowSpan="true" equalCols="false" isVisible="false" halign="Right" isMultiline="true" isAntialiased="true" >
				<decoration style="None"/>
			</legend>
			<elements drawOutline="false" drawShadow="true" />
			<popup background="#eeeeee" font="Arial-12" isMultiline="true" isAntialiased="true" provideAltText="true" foreground="black"/>
		</frameChart>
	</cfxml>

</cfsilent>

<cfchart
	format="png"
	showmarkers="false"
	showlegend="false"
	yaxistitle="Suma dni przetrzymanych faktur"
	style="#xml#" >

	<cfchartseries
		type="area"
		serieslabel="Suma dni"
		seriescolor="##75bd4e"
		query="faktury"
		valuecolumn="dni"
		itemcolumn="workflowstepstatusname"
		paintstyle="plain" >

	</cfchartseries>

</cfchart>