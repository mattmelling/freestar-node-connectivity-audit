select
        strftime('%Y-%m-%d %H:00', datetime(timestamp, 'unixepoch')) as day,
        sum(case status when 1 then 1 else 0 end) as good,
        sum(case status when 0 then 1 else 0 end) as bad
from measurements
group by day;
