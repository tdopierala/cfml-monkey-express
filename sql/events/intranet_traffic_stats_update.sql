CREATE EVENT `intranet_traffic_stats_update` ON SCHEDULE EVERY 1 MONTH STARTS '2014-03-01 00:00:01' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN

delete from intranet.tbl_log_stats;

insert into intranet.tbl_log_stats (count, year, month, date)
SELECT count(*), year(logdatetime) as y, month(logdatetime) as m, DATE_FORMAT(logdatetime, '%Y%m') as d
FROM intranet.tbl_logs
where logdatetime < DATE_FORMAT(NOW() ,'%Y-%m-01')
group by y,m
order by y, m;

END