DROP TABLE stop_times;
DROP TABLE trips;
DROP TABLE stops;
DROP TABLE routes;


CREATE TABLE routes (
    route_id varchar(20) PRIMARY KEY,
    agency_id integer,
    route_short_name text,
    route_long_name text,
    route_desc text,
    route_type integer,
    route_url varchar,
    route_color char(6),
    route_text_color char(6)
);

CREATE TABLE stops (
    stop_id varchar(30) PRIMARY KEY,
    stop_name text,
    stop_desc text,
    stop_lat double precision,
    stop_lon double precision,
    zone_id integer,
    stop_url varchar,
    location_type integer,
    parent_station varchar(30) references stops,
    wheelchair_boarding integer
);

CREATE TABLE trips (
    route_id varchar(20) references routes,
    service_id varchar(5),
    trip_id varchar(18) primary key,
    trip_headsign varchar,
    trip_short_name varchar,
    direction_id integer,
    block_id integer,
    wheelchair_accessible integer,
    bikes_allowed integer,
    trip_desc text,
    shape_id integer
);

CREATE TABLE stop_times (
    trip_id varchar(18) references trips,
    arrival_time char(8), --ne peut pas etre time a cause de valeurs out-of-range (24:04:00)
    departure_time char(8),
    stop_id varchar(30) references stops not null,
    stop_sequence integer,
    stop_headsign varchar,
    pickup_type integer,
    drop_off_type integer,
    PRIMARY KEY (trip_id, stop_sequence)
);





\copy routes from 'routes.txt' WITH (FORMAT CSV, HEADER);
\copy stops from 'stops.txt' WITH (FORMAT CSV, HEADER);
\copy trips from 'trips.txt' WITH (FORMAT CSV, HEADER);
\copy stop_times from 'stop_times.txt' WITH (FORMAT CSV, HEADER);