defmodule DockupUi.ConfigController do
  use DockupUi.Web, :controller


  def index(conn, _params) do
    render(conn, "index.html")
  end
end
