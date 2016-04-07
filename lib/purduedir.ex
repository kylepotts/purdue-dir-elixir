defmodule Purduedir do
  import Supervisor.Spec
def start_server() do
  IO.puts("Starting API")
  port = 8080
  {:ok, conn} = Redix.start_link(System.get_env("PDIR_REDIS"), name: :redix)

  children = [
    Plug.Adapters.Cowboy.child_spec(:http, Purduedir.Plug.Router, [], port: port)
  ]

  Supervisor.start_link(children, strategy: :one_for_one)
end


def print_person(args) do
  searchQuery = List.last(args)
  children = [
  worker(Purduedir.PrintPerson, [[:hello], [name: :person_printer]])
]
  s = Supervisor.start_link(children, strategy: :one_for_one)
  GenServer.call(:person_printer,{:search, searchQuery})
  s
end


  def start(_type, _args) do
    clargs = :init.get_plain_arguments()
    #IO.inspect(clargs)
    run_type = Enum.fetch(clargs,2)
    case run_type do
      {:ok ,'--api'} -> start_server()
      {:ok , '--q'} -> print_person(clargs)
      _ -> IO.puts("Incorrect Argument")
    end
  end
end
