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


def print_person(searchString) do
  children = [
  worker(Purduedir.PrintPerson, [[:hello], [name: :person_printer]])
]
  s = Supervisor.start_link(children, strategy: :one_for_one)
  GenServer.call(:person_printer,{:search, searchString})
  s
end

def search_args_for(args,search_for) do
  arg = Enum.filter(Enum.with_index(args),fn({item,index}) -> search_for == item end)
  case arg do
    [] -> {false,nil}
    [a] -> {true, elem(a,1)}
  end
end

  def start(_type, _args) do
    clargs = :init.get_plain_arguments()
    {to_search?, query_index} = search_args_for(clargs, '--q')
    {to_run_api, _} = search_args_for(clargs, '--api')
    IO.inspect(clargs)
    IO.inspect(to_search?)
    if to_search? do
      {:ok,searchString} = Enum.fetch(clargs,query_index+1)
      print_person(searchString)
    else
      if to_run_api do
        start_server()
      end
    end
  end

end
