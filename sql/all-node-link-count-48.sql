select
        strftime('%Y-%m-%d %H:00', datetime(timestamp, 'unixepoch')),
        sum(link_count)
from node_count
where (strftime('%s', 'now') - timestamp) < (3600 * 48)
group by strftime('%Y-%m-%d %H:00', datetime(timestamp, 'unixepoch'));
