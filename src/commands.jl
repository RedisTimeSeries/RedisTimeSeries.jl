# TS.CREATE key [RETENTION retentionTime] [UNCOMPRESSED] [LABELS field value..]
function create(conn::RedisConnection, key::String, command::String)
	response = execute_command(conn, ["TS.CREATE", key, command])
	println(response)
end

# TS.ALTER key [RETENTION retentionTime] [LABELS field value..]
function alter(conn::RedisConnection, key::String, params::String)
	response = execute_command(conn, ["TS.ALTER", key, params])
	println(response)
end

# TS.ADD call with specified key-value pairs for LABELS
function add(conn::RedisConnection, key::String, timestamp::Int64, value::Float64, labels::Dict{String,String}, retention=0)
	# TS.ADD key timestamp value [RETENTION retentionTime] [UNCOMPRESSED] [LABELS field value..]
	# Note that UNCOMPRESSED is unused in timeseries-py; we are following suit here.
	label_str = ""
	for i in keys(labels) label_str = string(label_str, "$i $(labels[i]) ") end
	response = execute_command(conn, ["TS.ADD", key, string(timestamp), string(value), retention, label_str])
	println(response)
end

# TS.ADD without labels
function add(conn::RedisConnection, key::String, timestamp::Int64, value::Float64, retention=0)
	# TS.ADD key timestamp value [RETENTION retentionTime] [UNCOMPRESSED] [LABELS field value..]
	# Note that UNCOMPRESSED is unused in timeseries-py; we are following suit here.
	response = execute_command(conn, ["TS.ADD", key, string(timestamp), string(value), retention])
	println(response)
end

function get(conn::RedisConnection, key::String)
	response = execute_command(conn, ["TS.GET", key])
	humantime = Libc.strftime(response[1])
	println(string("$humantime => $(response[2])"))
end

function ktv_unfold(ktv::Tuple{String, Int64, Float64})
	ktv_str = ""
	for i in ktv ktv_str = string(ktv_str, "$ktv[1], $ktv[2], $ktv[3] ") end
	return ktv_str
end

# MADD accepts an array of key-time-value tuples.
function madd(conn::RedisConnection, ktv_tuples::Array{Tuple{String, Int64, Float64}})
	#  TS.MADD key timestamp value [key timestamp value ...]
	ktv_arg = ""
	for i in ktv_tuples ktv_arg = string(ktv_arg, ktv_unfold(i)) end
	response = execute_command(conn, ["TS.MADD", ktv_arg])
	println(response)
end

# MADD accepts a key-time-value tuple.
function madd(conn::RedisConnection, ktv_tuple::Tuple{String, Int64, Float64})
	#  TS.MADD key timestamp value [key timestamp value ...]
	response = execute_command(conn, ["TS.MADD", ktv_unfold(ktv_tuple)])
	println(response)
end

function madd(conn::RedisConnection, ktv::Tuple{String, String, Float64})
	#  TS.MADD key timestamp value [key timestamp value ...]
	response = execute_command(conn, ["TS.MADD", ktv[1], ktv[2], string(ktv[3])])
	println(response)
end

#  function incrby(conn::RedisConnection, key::String, value::Float64, params::String)
	#  #  TS.INCRBY key value [TIMESTAMP timestamp] [RETENTION retentionTime] [UNCOMPRESSED] [LABELS field value..]
	#  execute_command(conn, ["TS.INCRBY", key, string(value), params])
#  end

#  function decrby(conn::RedisConnection, key::String, value::Float64, params::String)
	#  #  TS.DECRBY key value [TIMESTAMP timestamp] [RETENTION retentionTime] [UNCOMPRESSED] [LABELS field value..]
	#  execute_command(conn, ["TS.DECRBY", key, string(value), params])
#  end


#  TS.CREATERULE sourceKey destKey AGGREGATION aggregationType timeBucket

#  TS.RANGE key fromTimestamp toTimestamp [COUNT count] [AGGREGATION aggregationType timeBucket]
#  TS.RANGE temperature:3:32 1548149180000 1548149210000 AGGREGATION avg 5000

#  TS.MRANGE fromTimestamp toTimestamp [COUNT count] [AGGREGATION aggregationType timeBucket] [WITHLABELS] FILTER filter..
#  TS.MRANGE 1548149180000 1548149210000 AGGREGATION avg 5000 FILTER area_id=32 sensor_id!=1

#  TS.MGET FILTER filter...

#  TS.INFO key

#  TS.QUERYINDEX filter...
