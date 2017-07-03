defmodule <%= prj_module_name %>.Router do

  require Logger
  use Plug.Router


  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded, :json],
                     pass:  ["*/*"],
                     json_decoder: Poison

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Hello uservice!")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

end
