local rd = require("checks.qim.redisCheck");

local _M = {}
function _M:ckeyCheck()

    local _CheckRet = {}
    _CheckRet.httpcode = 200
    _CheckRet.bizcode = 0
    _CheckRet.retmessage = ""

    local inArgs = ngx.req.get_uri_args()
    local inCkey = ngx.var.cookie_q_ckey;

    if nil == inCkey then
        local qcookiesHelper = require("checks.qcookiehelper")
        local ckeyCheckResult = qcookiesHelper:QCookieParse()
        inCkey = ckeyCheckResult["q_ckey"];

    end

    if nil == inCkey then
        _CheckRet.retmessage = "ckey is need";
        _CheckRet.bizcode = 5000
        ngx.log(ngx.ERR, "e " .. "ckey is need")
        return _CheckRet
    else
        local decodedCkeyString = ngx.decode_base64(inCkey)

        if nil == decodedCkeyString then
            _CheckRet.retmessage = "ckey is decode fail";
            _CheckRet.bizcode = 5000
            ngx.log(ngx.ERR, "e " .. "ckey is decode fail")
            return _CheckRet
        end

        require("utils.string_ex")
        local params = decodedCkeyString:split("&")
        local decodedCkey = {}

        for i=1 ,#params do
            local subparam = params[i]
            local kv = subparam:split("=")
            if 2 == #kv then
                decodedCkey[kv[1]] = kv[2]
            end
        end

        -- 客户端版本问题，这里暂时不判定t
        if nil == decodedCkey["u"] or nil == decodedCkey["k"] then
            _CheckRet.retmessage = "ckey is parse wrong";
            _CheckRet.bizcode = 5000
            ngx.log(ngx.ERR, "e " .. "ckey is parse wrong")
            return _CheckRet
        end

        local config = require("checks.qim.qtalkredis")
        local user = decodedCkey["u"]
        local t    = decodedCkey["t"]
        local key  = decodedCkey["k"]


        if nil == t then
            t = ""
        end

        if not rd.check(user, v, key) then
            _CheckRet.retmessage = "ckey is not matching";
            _CheckRet.bizcode = 5000
            ngx.log(ngx.ERR, "e " .. "ckey is not matching")
            return _CheckRet
        end
    end
    return _CheckRet;
end

return _M