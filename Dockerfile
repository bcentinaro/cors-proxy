FROM elixir:1.8-slim AS builder

ARG APP_NAME=cors_proxy
ARG APP_VSN=0.1.0
ARG MIX_ENV=prod

ENV APP_NAME=${APP_NAME} \
    APP_VSN=${APP_VSN} \
    MIX_ENV=${MIX_ENV}

WORKDIR /opt/app

RUN apt-get update -y && \
    apt-get install git build-essential curl -y && \
    mix local.rebar --force && \
    mix local.hex --force

COPY ./ /opt/app

WORKDIR /opt/app

RUN mix do deps.get, deps.compile, compile

RUN \
    mkdir -p /opt/built && \
    mix distillery.release --verbose && \
    cp /opt/app/_build/${MIX_ENV}/rel/${APP_NAME}/releases/${APP_VSN}/${APP_NAME}.tar.gz /opt/built && \
    cd /opt/built && \
    tar -xzf ${APP_NAME}.tar.gz && \
    rm ${APP_NAME}.tar.gz

# From this line onwards, we're in a new image, which will be the image used in production
FROM debian:stretch-slim

EXPOSE 80 

ARG APP_NAME=cors_proxy

RUN apt-get update -y && \
    apt-get install -y \
    bash \
    openssl \
    libssl-dev 


ENV REPLACE_OS_VARS=true \
    APP_NAME=${APP_NAME} \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

WORKDIR /opt/app

ENTRYPOINT []

COPY --from=builder /opt/built .

CMD trap 'exit' INT; /opt/app/bin/${APP_NAME} foreground
