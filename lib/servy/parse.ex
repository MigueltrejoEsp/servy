defmodule Servy.Parse do
  alias Servy.Conv

  @doc """
  Parses the request string into a conversation map.
  """
  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")

    [request_line | _header_lines] = String.split(top, "\n")

    params = parse_String(params_string)

    [method, path, _] =
      request_line
      |> String.split(" ")

    %Conv{method: method, path: path, params: params}
  end

  def parse_String(params_string) do
    params_string
    |> String.trim()
    |> URI.decode_query()
  end
end
