select
        strftime('%Y-%m-%d %H:00', datetime(timestamp, 'unixepoch')),
        max(link_count)
from node_count
where node = NODE
group by strftime('%Y-%m-%d %H:00', datetime(timestamp, 'unixepoch'));
