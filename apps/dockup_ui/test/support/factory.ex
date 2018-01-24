defmodule DockupUi.Factory do
  alias DockupUi.{
    Deployment,
    WhitelistedUrl,
    User,
    Organization,
    Repo
  }

  def insert(model, args \\ [])

  def insert(:deployment, args) do
    deployment_factory()
    |> Deployment.changeset(Map.new(args))
    |> Repo.insert!
  end

  def insert(:whitelisted_url, args) do
    whitelisted_url_factory()
    |> WhitelistedUrl.changeset(Map.new(args))
    |> Repo.insert!
  end

  def insert(:user, args) do
    user_factory()
    |> User.changeset(Map.new(args))
    |> Repo.insert!
  end

  def insert(:organization, args) do
    organization_factory()
    |> Organization.changeset(Map.new(args))
    |> Repo.insert!
  end

  defp deployment_factory do
    %DockupUi.Deployment{
      git_url: "https://github.com/code-mancers/dockup.git",
      branch: "master",
      callback_url: "http://example.com/callback",
      status: "queued",
      log_url: "http://example.com/log_url",
    }
  end

  defp whitelisted_url_factory do
    %DockupUi.WhitelistedUrl{
      git_url: "https://github.com/code-mancers/dockup.git"
    }
  end

  defp user_factory do
    %User{email: "foo@example.com", name: "Foo"}
  end

  defp organization_factory do
    %Organization{name: "Codemancers"}
  end
end
