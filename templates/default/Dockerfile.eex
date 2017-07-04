FROM elixir:1.4.4

WORKDIR /home/prj
ENV HOME=/home
ENV TERM=xterm

COPY mix* ./
COPY config/ config/
COPY lib lib/
COPY test test/


RUN mix do local.hex --force, local.rebar --force, deps.get, compile

CMD elixir --sname pl-proto -S mix run --no-halt

