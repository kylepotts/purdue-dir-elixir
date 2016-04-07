defmodule Purduedir do
  import Supervisor.Spec
def start_server() do
  IO.puts("Starting API")
  port = 8080
  {:ok, conn} = Redix.start_link("redis://kylepotts:b2f3fe5608b70eec22bb1d43ea67d3b5@50.30.35.9:3323/", name: :redix)

  children = [
    Plug.Adapters.Cowboy.child_spec(:http, Purduedir.Plug.Router, [], port: port)
  ]

  Supervisor.start_link(children, strategy: :one_for_one)
end


def print_person(args) do
  searchQuery = List.last(args)
  children = [
  worker(Purduedir.PrintPerson, [[:hello], [name: :sup_stack]])
]
  s = Supervisor.start_link(children, strategy: :one_for_one)
  person = GenServer.call(:sup_stack,{:search, searchQuery})
  s
end


  def start(_type, _args) do
    clargs = :init.get_plain_arguments()
    IO.inspect(clargs)
    run_type = Enum.fetch(clargs,2)
    case run_type do
      {:ok ,'--api'} -> start_server()
      {:ok , '--q'} -> print_person(clargs)
      _ -> IO.puts("Incorrect Argument")
    end
  end
end
