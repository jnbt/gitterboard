defmodule GitterBoard.Gitter do
  use GenServer

  @rest_api "api.gitter.im"
  @stream_api "stream.gitter.im"

  def start_link do
    {:ok, pid} = GenServer.start_link(__MODULE__, :ok)
    GenServer.cast(pid, :listen)
    {:ok, pid}
  end

  def init(:ok) do
    {:ok, []}
  end

  def handle_cast(:listen, _) do
    messages = fetch
    push_messages! messages
    do_listen
    {:noreply, messages}
  end

  def handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, state) do
    cond do
      String.match?(chunk, ~r/\{.*\}/) ->
        message  = chunk |> Poison.decode!
        messages = [message | state] |> Enum.take(config[:limit])
        push_messages! messages
        {:noreply, messages}
      true ->
        # ignore all whitespace and other nonsense
        {:noreply, state}
    end
  end

  def handle_info(%HTTPoison.AsyncEnd{}, state) do
    # in this case something went wrong, so lets crash
    {:stop, "Stream ended", state}
  end

  def handle_info(request, state) do
    super(request, state)
  end

  defp do_listen do
    HTTPoison.start
    HTTPoison.get! url(@stream_api), headers, [stream_to: self, recv_timeout: :infinity]
  end

  defp fetch do
    {:ok, %{status_code: 200, body: body}} = HTTPoison.get(url, headers)
    body |> Poison.decode! |> Enum.reverse
  end

  defp push_messages!(messages) do
    IO.inspect messages
  end

  defp config do
    %{
      limit: 5,
      room: System.get_env("GITTER_ROOM"),
      token: System.get_env("GITTER_TOKEN"),
    }
  end

  defp headers do
    %{
      "Authorization" => "Bearer #{config[:token]}",
      "Accept" => "application/json"
    }
  end

  defp url(host \\ @rest_api) do
    "https://#{host}/v1/rooms/#{config[:room]}/chatMessages?limit=#{config[:limit]}"
  end
end
