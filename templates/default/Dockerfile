FROM elixir:1.4.4

COPY . /home

WORKDIR /home

RUN mix do local.hex --force, local.rebar --force, deps.get, compile

CMD elixir --sname pl-proto -S mix run --no-halt

