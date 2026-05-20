defmodule Servy.Parse do
  alias Servy.Conv

  @doc """
  Parses the request string into a conversation map.
  """
  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %Conv{method: method, path: path}
  end
end
