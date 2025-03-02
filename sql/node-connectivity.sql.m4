select
        strftime('%Y-%m-%d %H:%M', datetime(timestamp, 'unixepoch')) as day,
        case when sum(status) > 0 then 1 else 0 end
from measurements where rnode = NODE_ID
group by day
order by day desc
limit 50
