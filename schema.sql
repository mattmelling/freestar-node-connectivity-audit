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

insert into nodes (id, callsign, comment) values (548161, 'GB3KH', 'Spoke with 2E0SGG, GB3KH is behind CGNAT so unlikely to be able to accept incoming connections in the short term.')  on conflict(id) do update set comment = excluded.comment; 

create table if not exists node_count (
       timestamp timestamp,
       node integer,
       link_count integer,
       primary key(timestamp, node)
);
