redisModule = {}

function redisModule.check(user, t, key)
    local config = require("checks.qim.qtalkredis")
    local redis = require("resty.redis")
    local red = redis:new()
    red:set_timeout(500)

    local  ok, err = red:connect(config.redis.host, config.redis.port)
    --connect redis ok
    if ok then
        ok, err = red:auth(config.redis.passwd)

        red:select(tonumber(config.redis.subpool))
        ngx.log(ngx.DEBUG, config.redis.host)

        if ok then
            ok, err = red:hkeys(user)

            if ok then
                local checkpass = false
                for k,v in pairs(ok) do
                    local newkey = string.upper(ngx.md5(v .. t))
                    ngx.log(ngx.DEBUG, newkey)
                    if newkey == key then
                        checkpass = true
                        break
                    end
                end
                return checkpass

            else
                return false
            end
        else
            ngx.log(ngx.ERR, "e " .. "redis auth fail " .. err)
            return false
        end

    else
        ngx.log("connect redis error")
        return false
    end
end

return redisModule