module RedisTimeSeries

import Redis.RedisConnection, Redis.execute_command

export create, alter, add, madd, incrby, decrby, get

include("commands.jl")

end
