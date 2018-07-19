defmodule DockupUi.DeploymentController do
  use DockupUi.Web, :controller

  alias DockupUi.{
    Deployment
  }

  def new(conn, _params) do
    render conn, "new.html"
  end

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"id" => id}) do
    deployment = Repo.get!(Deployment, id)
    render conn, "show.html", deployment: deployment
  end

  def home(conn, _params) do
    if get_session(conn, :current_user) do
      redirect(conn, to: deployment_path(conn, :new))
    else
      render(conn, "home.html", layout: {DockupUi.LayoutView, "home.html"})
    end
  end
end
