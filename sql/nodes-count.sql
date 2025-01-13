select
        strftime('%Y-%m-%d', datetime(timestamp, 'unixepoch')) as day,
        count(*)
from measurements
group by day;
