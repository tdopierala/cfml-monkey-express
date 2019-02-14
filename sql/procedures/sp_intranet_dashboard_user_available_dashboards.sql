CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_dashboard_user_available_dashboards`(
	in _user_id int(11)
)
begin
SELECT 
				d.id as id
				,d.dashboardname as dashboardname
				,d.dashboarddisplayname as dashboarddisplayname
			FROM
				dashboard_dashboards d
			WHERE d.id NOT IN (
				SELECT
					ud.dashboardid
				FROM
					dashboard_userdashboards ud
				WHERE ud.userid = _user_id);
end
