# TODO Unfold command into multiple args? Is Julia null-friendly for optional args?
function create(conn::RedisConnection, key::String, command::String)
	# TS.CREATE key [RETENTION retentionTime] [UNCOMPRESSED] [LABELS field value..]
	execute_command(conn, ["TS.CREATE", key, command])
end

function alter(conn::RedisConnection, key::String, params::String)
	# TS.ALTER key [RETENTION retentionTime] [LABELS field value..]
	execute_command(conn, ["TS.ALTER", key, params])
end

function add(conn::RedisConnection, key::String, timestamp::Int64, value::Float64, params::String)
	#  TS.ADD key timestamp value [RETENTION retentionTime] [UNCOMPRESSED] [LABELS field value..]
	execute_command(conn, ["TS.ADD", key, string(timestamp), string(value), params])
end

function madd(conn::RedisConnection, key::String, timestamp::Int64, value::Float64, params::String)
	#  TS.MADD key timestamp value [key timestamp value ...]
	execute_command(conn, ["TS.MADD", key, string(timestamp), string(value), params])
end

function incrby(conn::RedisConnection, key::String, value::Float64, params::String)
	#  TS.INCRBY key value [TIMESTAMP timestamp] [RETENTION retentionTime] [UNCOMPRESSED] [LABELS field value..]
	execute_command(conn, ["TS.INCRBY", key, string(value), params])
end

function decrby(conn::RedisConnection, key::String, value::Float64, params::String)
	#  TS.DECRBY key value [TIMESTAMP timestamp] [RETENTION retentionTime] [UNCOMPRESSED] [LABELS field value..]
	execute_command(conn, ["TS.DECRBY", key, string(value), params])
end


#  TS.CREATERULE sourceKey destKey AGGREGATION aggregationType timeBucket

#  TS.RANGE key fromTimestamp toTimestamp [COUNT count] [AGGREGATION aggregationType timeBucket]
#  TS.RANGE temperature:3:32 1548149180000 1548149210000 AGGREGATION avg 5000

#  TS.MRANGE fromTimestamp toTimestamp [COUNT count] [AGGREGATION aggregationType timeBucket] [WITHLABELS] FILTER filter..
#  TS.MRANGE 1548149180000 1548149210000 AGGREGATION avg 5000 FILTER area_id=32 sensor_id!=1

#  TS.GET key

#  TS.MGET FILTER filter...

#  TS.INFO key

#  TS.QUERYINDEX filter...
