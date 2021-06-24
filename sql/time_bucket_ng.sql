-- This file and its contents are licensed under the Apache License 2.0.
-- Please see the included NOTICE for copyright information and
-- LICENSE-APACHE for a copy of the license.

-- time_bucket_ng() is an _experimental_ new version of time_bucket().
--
-- Unlike time_bucket(), time_bucket_ng() supports variable-sized buckets,
-- such as months and years, and also timezones. Note that the behavior
-- and the interface of this function are subjects to change. There could
-- be bugs, and the implementation doesn't claim to be complete. Use at
-- your own risk.
--
-- This function is IMMUTABLE while similar PostgreSQL function, date_trunc(),
-- is STABLE. The difference is that date_trunc() implicitly uses the current
-- TZ to calculate the result. This is not the case with time_bucket_ng(),
-- because it's going to get timezone explicitly in text format, e.g.:
--
--   SELECT time_bucket_ng('3 months', now() :: timestamptz, 'Europe/Berlin');
--
-- In other words, there will be separate continuous aggregates for each
-- timezone. The timestamptz argument is not a problem, since internally it's
-- represented as a simple UTC timestamp.
CREATE OR REPLACE FUNCTION timescaledb_experimental.time_bucket_ng(bucket_width INTERVAL, ts DATE) RETURNS DATE
	AS '@MODULE_PATHNAME@', 'ts_time_bucket_ng' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;

CREATE OR REPLACE FUNCTION timescaledb_experimental.time_bucket_ng(bucket_width INTERVAL, ts DATE, origin DATE) RETURNS DATE
	AS '@MODULE_PATHNAME@', 'ts_time_bucket_ng' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;

-- utility functions
CREATE OR REPLACE FUNCTION timescaledb_experimental.time_bucket_ng(bucket_width INTERVAL, ts TIMESTAMP) RETURNS TIMESTAMP
	AS '@MODULE_PATHNAME@', 'ts_time_bucket_ng_timestamp' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;

CREATE OR REPLACE FUNCTION timescaledb_experimental.time_bucket_ng(bucket_width INTERVAL, ts TIMESTAMP, origin TIMESTAMP) RETURNS TIMESTAMP
	AS '@MODULE_PATHNAME@', 'ts_time_bucket_ng_timestamp' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;

CREATE OR REPLACE FUNCTION timescaledb_experimental.time_bucket_ng(bucket_width INTERVAL, ts TIMESTAMPTZ) RETURNS TIMESTAMPTZ
	AS '@MODULE_PATHNAME@', 'ts_time_bucket_ng_timestamptz' LANGUAGE C STABLE PARALLEL SAFE STRICT;

CREATE OR REPLACE FUNCTION timescaledb_experimental.time_bucket_ng(bucket_width INTERVAL, ts TIMESTAMPTZ, origin TIMESTAMPTZ) RETURNS TIMESTAMPTZ
	AS '@MODULE_PATHNAME@', 'ts_time_bucket_ng_timestamptz' LANGUAGE C STABLE PARALLEL SAFE STRICT;
