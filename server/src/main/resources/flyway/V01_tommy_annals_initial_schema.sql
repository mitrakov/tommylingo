-- SCHEMA
CREATE SCHEMA IF NOT EXISTS annals;
SET search_path TO annals;
CREATE TYPE ParamType AS ENUM ('N', 'S');



-- User table
CREATE TABLE IF NOT EXISTS "user" (
  user_id SERIAL PRIMARY KEY NOT NULL,
  login VARCHAR(128) UNIQUE NOT NULL,
  hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE  "user" IS 'This table stores users';
COMMENT ON COLUMN "user".user_id IS 'Primary key, auto-incremented';
COMMENT ON COLUMN "user".login IS 'Login, unique';
COMMENT ON COLUMN "user".hash IS 'Password hash, NOT in plain text';
COMMENT ON COLUMN "user".created_at IS 'Current timestamp';



-- Event table
CREATE TABLE IF NOT EXISTS event (
  event_id SERIAL PRIMARY KEY NOT NULL,
  user_id INT NOT NULL REFERENCES "user" (user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  name VARCHAR(128) NOT NULL,
  description VARCHAR(255) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT event_user_name UNIQUE (user_id, name)
);
COMMENT ON TABLE  event IS 'This table stores individual events for each user';
COMMENT ON COLUMN event.event_id IS 'Primary key, auto-incremented';
COMMENT ON COLUMN event.user_id IS 'Foreign key to user table';
COMMENT ON COLUMN event.name IS 'Event name';
COMMENT ON COLUMN event.description IS 'Event description, optional';
COMMENT ON COLUMN event.created_at IS 'Current timestamp';



-- Param table
CREATE TABLE IF NOT EXISTS param (
  param_id SERIAL PRIMARY KEY NOT NULL,
  event_id INT NOT NULL REFERENCES event (event_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  name VARCHAR(128) NOT NULL,
  description VARCHAR(255) NULL,
  type ParamType NOT NULL DEFAULT 'S',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT param_event_name UNIQUE (event_id, name)
);
COMMENT ON TABLE  param IS 'This table stores parameters for each event ID';
COMMENT ON COLUMN param.param_id IS 'Primary key, auto-incremented';
COMMENT ON COLUMN param.event_id IS 'Foreign key to event table';
COMMENT ON COLUMN param.name IS 'Event name';
COMMENT ON COLUMN param.description IS 'Event description, optional';
COMMENT ON COLUMN param.type IS 'Type of this parameter: N=numeric, S=string';
COMMENT ON COLUMN param.created_at IS 'Current timestamp';



-- Main table
CREATE TABLE IF NOT EXISTS chronicle (
  id BIGSERIAL PRIMARY KEY NOT NULL,
  date DATE NOT NULL DEFAULT now(),
  param_id INT NOT NULL REFERENCES param (param_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  value_num DECIMAL NULL,
  value_str VARCHAR(255) NULL CHECK (value_num IS NOT NULL OR value_str IS NOT NULL),
  comment VARCHAR(255) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT chronicle_date_param UNIQUE (date, param_id)
);
COMMENT ON TABLE  chronicle IS 'Main table; stores parameter key-value pairs for each date';
COMMENT ON COLUMN chronicle.id IS 'Primary key, auto-incremented';
COMMENT ON COLUMN chronicle.date IS 'Date';
COMMENT ON COLUMN chronicle.param_id IS 'Foreign key to parameters';
COMMENT ON COLUMN chronicle.value_num IS 'Numberic value of the event, optional but either `value_num` or `value_str` must be defined';
COMMENT ON COLUMN chronicle.value_str IS 'String value of the event, optional but either `value_num` or `value_str` must be defined';
COMMENT ON COLUMN chronicle.comment IS 'Comment on this record, optional';
COMMENT ON COLUMN chronicle.created_at IS 'Current timestamp';
