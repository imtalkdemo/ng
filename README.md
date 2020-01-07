## Openresty的相关使用

### 本地开发环境

```shell script
## 此处可以指定path，这样可以避免代码里面有大量的绝对路径
nginx -p `pwd`/ -c conf/nginx.conf

## 重启相应的nginx服务
nginx -p `pwd`/ -c conf/nginx.conf -s reload
```

