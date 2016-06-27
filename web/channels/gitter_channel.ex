defmodule GitterBoard.GitterChannel do
  use Phoenix.Channel

  @topic "gitter"

  def join(@topic, _, socket) do
    {:ok, socket}
  end

  def broadcast!(messages) do
    GitterBoard.Endpoint.broadcast!(@topic, "update", %{
      messages: messages
    })
  end
end
