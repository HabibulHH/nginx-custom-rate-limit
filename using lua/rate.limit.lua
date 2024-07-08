local redis = require "resty.redis"
local cjson = require "cjson"

local _M = {}

function _M.check_rate_limit(client_ip)
    local red = redis:new()
    red:set_timeout(1000) -- 1 second timeout

    local ok, err = red:connect("127.0.0.1", 6379)
    if not ok then
        ngx.log(ngx.ERR, "failed to connect to redis: ", err)
        return ngx.exit(500)
    end

    local limit_key = "limit:" .. client_ip
    local window_size = 60 -- window size in seconds
    local max_requests = 10 -- max requests per window

    -- Get the current time
    local current_time = ngx.now()

    -- Get the current request count and timestamps
    local res, err = red:get(limit_key)
    if res == ngx.null then
        res = cjson.encode({count = 0, timestamps = {}})
    end

    local data = cjson.decode(res)
    local count = data.count or 0
    local timestamps = data.timestamps or {}

    -- Remove timestamps that are outside the window
    while #timestamps > 0 and current_time - timestamps[1] >= window_size do
        table.remove(timestamps, 1)
        count = count - 1
    end

    -- Check if the request is within the limit
    if count >= max_requests then
        return ngx.exit(429) -- Too Many Requests
    end

    -- Add the current timestamp and increment the count
    table.insert(timestamps, current_time)
    count = count + 1

    -- Save the updated count and timestamps to Redis
    local new_data = cjson.encode({count = count, timestamps = timestamps})
    red:set(limit_key, new_data)
    red:expire(limit_key, window_size)

    -- Set Redis connection to keepalive
    red:set_keepalive(10000, 100)
end

return _M
