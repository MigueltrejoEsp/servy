defmodule Servy.Plugins do
  alias Servy.Conv

  @doc """
  Tracks unhandled requests by logging 404 paths.
  """
  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts("Warning: #{path} is on the loose!")
    conv
  end

  def track(%Conv{} = conv), do: conv

  @doc """
  Rewrites legacy or query-style paths into canonical ones.
  """
  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/#{id}"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  @doc """
  Logs the conversation and returns it unchanged.
  """
  def log(%Conv{} = conv), do: IO.inspect(conv)
end
