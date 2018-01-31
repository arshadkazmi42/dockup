defmodule DockupUi.DeleteDeploymentService do
  require Logger

  alias DockupUi.{
    Deployment,
    Repo
  }

  @backend Application.fetch_env!(:dockup_ui, :backend_module)

  def run(deployment, deps \\ []) do
    Logger.info "Deleting deployment with ID: #{deployment.id}"

    delete_deployment_job = deps[:delete_deployment_job] || @backend
    callback = deps[:callback] || DockupUi.Callback

    with \
      changeset <- Deployment.delete_changeset(deployment),
      {:ok, deployment} <- Repo.update(changeset),
      deployment <- Repo.preload(deployment, :repository),
      :ok <- delete_deployment(delete_deployment_job, deployment, callback)
    do
      {:ok, deployment}
    end
  end

  defp delete_deployment(delete_deployment_job, deployment, callback) do
    delete_deployment_job.destroy(deployment, callback.lambda(%{deployment: deployment}))
    :ok
  end
end
