create table if not exists measurements (
  timestamp timestamp,
  lnode integer,
  rnode integer,
  callsign varchar(64),
  status integer,
  primary key(timestamp, rnode)
);

create table if not exists nodes (
  id integer primary key,
  callsign varchar(64),
  comment text
); 

create table if not exists node_count (
       timestamp timestamp,
       node integer,
       link_count integer,
       primary key(timestamp, node)
);
