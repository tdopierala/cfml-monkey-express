<cfprocessingdirective pageencoding="utf-8" />
	
<table class="uiTable">
    <thead>
        <tr>
            <th class="leftBorder rightBorder topBorder bottomBorder">Lp.</th>
            <th class="rightBorder topBorder bottomBorder">Imię</th>
            <th class="rightBorder topBorder bottomBorder">Nazwisko</th>
            <th class="rightBorder topBorder bottomBorder">Nazwa kursu/szkolenia</th>
            <th class="rightBorder topBorder bottomBorder">Nazwa certyfikatu</th>
            <th class="rightBorder topBorder bottomBorder">Data ważności certyfikatu</th>
            <th class="rightBorder topBorder bottomBorder">Numer certyfikatu</th>
            <th class="rightBorder topBorder bottomBorder">Data odbycia kursu/zkolenia</th>
        </tr>
    </thead>
    <tbody>
        <cfset lp = 1 />
        <cfoutput query="userCourses">
            <tr>
                <td class="leftBorder rightBorder bottomBorder">#lp#</td>
                <td class="rightBorder bottomBorder">#givenname#</td>
                <td class="rightBorder bottomBorder">#UCase(sn)#</td>
                <td class="rightBorder bottomBorder">#course_name#</td>
                <td class="rightBorder bottomBorder">#certificate_name#</td>
                <td class="rightBorder bottomBorder">#DateFormat(stand_from, "yyyy-mm-dd")# - #DateFormat(stand_to, "yyyy-mm-dd")#</td>
				<td class="rightBorder bottomBorder">#certificate_number#</td>
                <td class="rightBorder bottomBorder">#DateFormat(date_from, "yyyy-mm-dd")# - #DateFormat(date_to, "yyyy-mm-dd")#</td>
            </tr>
        <cfset lp = lp + 1 />
        </cfoutput>
    </tbody>
</table>

<div class="uiFooter">

    <a href="javascript:ColdFusion.navigate('index.cfm?controller=user_educations&action=addCourse', 'left_site_column');" title="Dodaj element do ścieżki edukacji">Dodaj nowy element</a> do kursów i szkoleń. 
	<!---
	<a href="<cfoutput>#URLFor(controller='User_educations',action='exportCourses')#</cfoutput>" title="Eksportuj ścieżkę kursów i szkoleń" target="_blank">Eksportuj ścieżkę kursów i szkoleń
	</a> do pliku EXCEL.
	--->
</div>