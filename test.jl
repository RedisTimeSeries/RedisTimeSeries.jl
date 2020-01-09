include("src/RedisTimeSeries.jl")
import .RedisTimeSeries
import Redis

conn = Redis.RedisConnection() # host=127.0.0.1, port=6379, db=0, no password

key = "temperature:2:32"
Redis.del(conn, key)
RedisTimeSeries.create(conn, key, "RETENTION 60000 LABELS sensor_id 2 area_id 32")
RedisTimeSeries.alter(conn, key, "LABELS sensor_id 2 area_id 32 sub_area_id 15")
RedisTimeSeries.add(conn, key, 1548149180000, 26.0, Dict{String,String}("sensor_id" => "2", "area_id" => "32"))
RedisTimeSeries.get(conn, key)
for n in 1:1000
	RedisTimeSeries.madd(conn, (key, "*", Float64(n)))
	RedisTimeSeries.get(conn, key)
	sleep(1)
end

Redis.disconnect(conn)