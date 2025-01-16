select
        strftime('%Y-%m-%d %H:00', datetime(timestamp, 'unixepoch')) as day,
        count(*)
from measurements
where lnode = NODE_ID
group by day;
