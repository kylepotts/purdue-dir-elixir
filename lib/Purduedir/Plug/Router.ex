defmodule Purduedir.Plug.Router do
  use Plug.Router
  plug :match
  plug :dispatch
  plug Purduedir.Plug.JsonParser, parsers: [:urlencoded, :json],
                   json_decoder: Poison

  get "/", do: send_resp(conn, 200, "Welcome")

  post "/search" do
    read_body(conn,[])
    IO.inspect(conn)
    send_resp(conn,200,"OK")
  end

  match _, do: send_resp(conn, 404, "Opps!")
end
