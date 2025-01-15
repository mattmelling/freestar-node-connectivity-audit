select
        strftime('%Y-%m-%d %H:00', datetime(timestamp, 'unixepoch')) as day,
        count(*)
from measurements
group by day;
