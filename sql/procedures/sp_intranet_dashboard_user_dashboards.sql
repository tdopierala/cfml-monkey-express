CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_dashboard_user_dashboards`(
	in _user_id int(11)
)
begin

	SELECT
			ud.id as id
				,ud.dashboardid as dashboardid
				,d.dashboardname as dashboardname
				,d.dashboarddisplayname as dashboarddisplayname
				,ud.userid as userid
				,ud.display_in as display_in
			FROM
				dashboard_userdashboards ud
			INNER JOIN dashboard_dashboards d on ud.dashboardid = d.id
			WHERE ud.userid = _user_id;

end
