defmodule Purduedir do
  alias Purduedir.GetHtml, as: G
  #G.start()
  #r = G.get!("https://www.purdue.edu/directory?SearchString=Kyle%20Potts")
  #case r do
    #%HTTPoison.Response{status_code: 200, body: body} -> IO.puts body
  #end

def start(_type, _args) do
  routes = [
    {"/", Purduedir.TopPageHandler, []},
    {"/search", Purduedir.SearchHandler,[]}
  ]
  dispatch = :cowboy_router.compile([
               {:_, routes}
             ])
  {:ok, _} = :cowboy.start_http(:http, 100,
                                [port: 8080],
                                [env: [dispatch: dispatch]])
  Purduedir.Supervisor.start_link
end
end
