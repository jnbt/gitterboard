defmodule GitterBoard.PageController do
  use GitterBoard.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
