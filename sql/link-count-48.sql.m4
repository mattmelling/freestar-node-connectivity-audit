select
        strftime('%Y-%m-%d %H:00', datetime(timestamp, 'unixepoch')),
        max(link_count)
from node_count
where node = NODE
      and (strftime('%s', 'now') - timestamp) < (3600 * 48)
group by strftime('%Y-%m-%d %H:00', datetime(timestamp, 'unixepoch'));
