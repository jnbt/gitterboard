defmodule GitterBoard.GitterChannel do
  @moduledoc """
    Channel to handle all Gitter chat messages
  """
  use Phoenix.Channel

  @topic "gitter"

  def join(@topic, _, socket) do
    send(self, :after_join)
    {:ok, socket}
  end

  def broadcast!(messages) do
    GitterBoard.Endpoint.broadcast!(@topic, "update", %{
      messages: messages
    })
  end

  def handle_info(:after_join, socket) do
    {:ok, messages} = GitterBoard.Gitter.replay
    push socket, "update", %{messages: messages}
    {:noreply, socket}
  end
end
