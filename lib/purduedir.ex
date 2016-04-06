defmodule Purduedir do

  def start(_type, _args) do
    port = 8080

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Purduedir.Plug.Router, [], port: port)
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
