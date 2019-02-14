<cfprocessingdirective pageencoding="utf-8" />
	
<table class="uiTable">
    <thead>
        <tr>
            <th class="leftBorder rightBorder topBorder bottomBorder">Lp.</th>
            <th class="rightBorder topBorder bottomBorder">Imię</th>
            <th class="rightBorder topBorder bottomBorder">Nazwisko</th>
            <th class="rightBorder topBorder bottomBorder">Typ szkoły</th>
            <th class="rightBorder topBorder bottomBorder">Nazwa szkoły</th>
            <th class="rightBorder topBorder bottomBorder">Data rozpoczęcia</th>
            <th class="rightBorder topBorder bottomBorder">Data zakończenia</th>
            <th class="rightBorder topBorder bottomBorder">Kierunek/Specjalizacja</th>
            <th class="rightBorder topBorder bottomBorder">Uzyskany/obroniony tytuł</th>
        </tr>
    </thead>
    <tbody>
        <cfset lp = 1 />
        <cfoutput query="userEducation">
            <tr>
                <td class="leftBorder rightBorder bottomBorder">#lp#</td>
                <td class="rightBorder bottomBorder">#givenname#</td>
                <td class="rightBorder bottomBorder">#UCase(sn)#</td>
                <td class="rightBorder bottomBorder">#stage_name#</td>
                <td class="rightBorder bottomBorder">
                    <cfif Len(institution_name)>
                        #institution_name#
                    <cfelse>
                        #ei_institution_type# #ei_institution_name#
                    </cfif> 
                </td>
                <td class="rightBorder bottomBorder">#DateFormat(date_start, "yyyy-mm-dd")#</td>
                <td class="rightBorder bottomBorder">#DateFormat(date_end, "yyyy-mm-dd")#</td>
                <td class="rightBorder bottomBorder">#course# / #specialization#</td>
                <td class="rightBorder bottomBorder">#degree_name#</td>
            </tr>
        <cfset lp = lp + 1 />
        </cfoutput>
    </tbody>
</table>

<div class="uiFooter">
    <a href="javascript:ColdFusion.navigate('index.cfm?controller=user_educations&action=add', 'left_site_column');" title="Dodaj element do ścieżki edukacji">Dodaj nowy element</a> do szkół i uczelni. <a href="<cfoutput>#URLFor(controller='User_educations',action='export')#</cfoutput>" title="Eksportuj ścieżkę edukacji" target="_blank">Eksportuj ścieżkę</a> do pliku EXCEL.
</div>