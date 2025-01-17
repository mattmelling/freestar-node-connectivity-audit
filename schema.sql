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
  inbound_excluded tinyint default 0,
  keeper varchar(64),
  location varchar(64)
); 

create table if not exists node_count (
       timestamp timestamp,
       node integer,
       link_count integer,
       primary key(timestamp, node)
);

update nodes set inbound_excluded = 1 where callsign = 'GB3KH';
update nodes set inbound_excluded = 1 where callsign = 'MB7IJT';
