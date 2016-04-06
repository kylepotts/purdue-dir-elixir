defmodule Purduedir.ScrapeHtml do
  def scrape(html_text) do
    tree = html_text |> Exquery.tree
    {type,error_text} = check_for_error(tree)
    if type == :none do
      list_items = tree |> Exquery.Query.all({:tag,"table",[{"class","more"}]})
      people = Enum.map(list_items, &get_person_info/1)
      %{:type => "sucess", :people => people}
    else
      %{:type => "error", :error_text => error_text}
    end
  end

  defp get_person_info(tree) do
    {tag,children} = tree
    name = grab_name(children)
    table_data = grab_table_data(children)
    [%{:header => "name", :data => name} | table_data]
  end

  defp check_for_error(tree) do
    {_, children} = tree |> Exquery.Query.one({:tag,"section",[{"id","results"}]})
    p = children |> Exquery.Query.one({:tag, "p",[]})
    case p do
      nil -> {:none,""}
      {_, [{_, error_text,_}]} -> {:error, error_text}
      _ -> handle_too_many_error(p)
    end
  end

  defp handle_too_many_error(p) do
    {_,[{_,error_text,_},_,{_, more_error_text,[]}]} = p
    full_error_text = error_text <> more_error_text
    {:error,full_error_text}
  end


  defp grab_name(tree) do
    {_, children} = tree |> Exquery.Query.one({:tag, "th", []})

    name = case children do
      [{_, [{_,name,_}]}] -> name
      [{_,name,_}] -> name
    end
    name
  end

  defp grab_table_data(tree) do
    rows = tree |> Exquery.Query.all({:tag, "tbody",[]}) |> Exquery.Query.all({:tag, "tr",[]})
    Enum.map(rows,&handle_rows/1)
  end

  defp handle_rows(tree) do
    {tag_data, children} = tree
    {_, [{_, header_text, _}]} = children |> Exquery.Query.one({:tag, "th",[]})
    {_, data} = children |> Exquery.Query.one({:tag, "td",[]})

    d = case data do
      [{_, data_text, _}] -> data_text
      #match for email
      [{{:tag, _,_}, [{_, data_text, _}]}] -> data_text
    end

    %{:header => header_text, :data => d}
  end

end
