defmodule Purduedir.Plug.Router do
  alias Purduedir.GetHtml, as: GetHtml
  use Plug.Router
  use Plug.ErrorHandler

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["*/*"],
    json_decoder: JSON
  plug :match
  plug :dispatch

  GetHtml.start()


  get "/", do: send_resp(conn, 200, "Welcome")

  post "/search" do
    searchString = conn.body_params["searchString"]
    {:ok,exists} = Redix.command(:redix, ["EXISTS",searchString])
    if exists == 0 do
      r = GetHtml.get!(searchString)
      json_response = case r do
        %HTTPoison.Response{status_code: 200, body: body} -> body
      end
      Redix.command(:redix, ["SET", searchString, json_response])
      send_resp(conn,200,json_response)
    else
      {:ok,json_response} = Redix.command(:redix,["GET",searchString])
      send_resp(conn,200, json_response)
    end

  end

  defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
  send_resp(conn, conn.status, "Invalid JSON body")
end

  match _, do: send_resp(conn, 404, "Opps!")
end
