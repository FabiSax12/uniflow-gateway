FROM openresty/openresty:1.21.4.1-alpine

RUN apk add --update git perl curl && \
    opm --install-dir=/usr/local/openresty/ get bsiara/lua-resty-openidc
