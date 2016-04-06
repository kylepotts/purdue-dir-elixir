defmodule Purduedir.SearchHandler do
    alias Purduedir.GetHtml, as: GetHtml
  def init(_transport, req, []) do
    GetHtml.start()
    {:ok, req, nil}
  end

  def handle(req, state) do
    {method,_} = :cowboy_req.method(req)
    hasBody = :cowboy_req.has_body(req)
    if method == "POST" and hasBody do
      {:ok, post_body, _} = :cowboy_req.body(req)
      {:ok, %{"searchString" => searchString}}= JSON.decode(post_body)
      r = GetHtml.get!(searchString)
      json_response = case r do
        %HTTPoison.Response{status_code: 200, body: body} -> body
      end
      {:ok, req} = :cowboy_req.reply(200, [], json_response, req)
      {:ok, req, state}
    else
      if method == "POST" and hasBody == false do
        {:ok, req} = :cowboy_req.reply(400,[], "Invalid Request (Maybe you didn't send a body?)",req)
        {:ok,req,state}
      else
        {:ok, req} = :cowboy_req.reply(405,[], "Method Not Allowed",req)
        {:ok,req,state}
      end
    end
  end
  def terminate(_reason, _req, _state), do: :ok
end
