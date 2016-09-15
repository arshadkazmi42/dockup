defmodule DockupUi.Repo.Migrations.CreateDeployment do
  use Ecto.Migration

  def change do
    create table(:deployments) do
      add :git_url, :string
      add :branch, :string
      add :callback_url, :string
      add :status, :string
      add :log_url, :string
      add :service_urls, :map

      timestamps
    end

  end
end
