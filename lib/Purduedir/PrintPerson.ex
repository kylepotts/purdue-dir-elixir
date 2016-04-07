defmodule Purduedir.PrintPerson do
  use GenServer
  alias Purduedir.GetHtml, as: GetHtml

def start_link(state, opts \\ []) do
  GenServer.start_link(__MODULE__, state, opts)
end


def handle_call({:search, name},_from,t) do
  name = to_string(name)
  r = GetHtml.get!(name)
  json_response = case r do
    %HTTPoison.Response{status_code: 200, body: body} -> body
  end
  {:ok,people} = JSON.decode(json_response)

  case people do
    %{"type" => "success", "people" => p} -> print_people(p)
    %{"type" => "error", "error_text" => error_text} -> IO.puts(error_text)
  end
  #grab_all_headers(people)
  {:reply,json_response,t}
end

def print_people(people) do
  headers = grab_all_headers(people)
  grab_all_data(people,headers)
end

def grab_all_headers(people) do
  Enum.map(people, &grab_person_header/1) |> List.flatten |> Enum.uniq
end

def grab_person_header(person) do
  headers = Enum.map(person, fn(%{"data" => _, "header" => h}) -> h end)
end

def grab_all_data(people,headers) do
  data = Enum.map(people,fn(person) -> grab_person_data(person,headers) end)
  TableRex.quick_render!(data, headers) |> IO.puts
end

def grab_person_data(person,headers) do

  data = for header <- headers do
    item = search_for_person_header(person,header)
    item
  end
end

def search_for_person_header(person,header) do
  items = Enum.filter(person,fn(data_item) -> reduce_by(data_item,header) end)
  case items do
    [] -> ""
    [%{"header" => _, "data" => d}] -> d
  end
end

def reduce_by(data_item,header) do
  %{"header" => h, "data" => d} = data_item
  if h == header do
    true
  else
    false
  end
end


end
