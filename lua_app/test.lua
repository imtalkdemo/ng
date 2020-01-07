local ck = require("checks.qim.check");

result = ck.ckeyCheck();

ngx.log(ngx.DEBUG, result.httpcode, result.bizcode, result.retmessage)

local cjson = require "cjson"
json = cjson.encode(result);

ngx.print(json)