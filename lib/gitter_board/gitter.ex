defmodule GitterBoard.Gitter do
  use GenServer

  @rest_api "api.gitter.im"

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
    {:noreply, messages}
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
