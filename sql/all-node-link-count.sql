select
        strftime('%Y-%m-%d %H:00', datetime(timestamp, 'unixepoch')),
        sum(link_count)
from node_count
group by strftime('%Y-%m-%d %H:00', datetime(timestamp, 'unixepoch'));
