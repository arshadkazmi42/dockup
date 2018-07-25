defmodule Dockup.Backends.Compose.DeployJob do
  require Logger
  import DateTime,except: [to_string: 1]

  alias Dockup.{
    DefaultCallback,
    Project,
    Backends.Compose.Container,
    Backends.Compose.DockerComposeConfig
  }

  def spawn_process(%{id: id, git_url: repository, branch: branch}, callback) do
    spawn(fn -> perform(id, repository, branch, callback) end)
  end

  def perform(deployment_id, repository, branch, callback \\ DefaultCallback, deps \\ []) do

    start_time = utc_now()
    project = deps[:project] || Project
    container = deps[:container] || Container
    docker_compose_config = deps[:docker_compose_config] || DockerComposeConfig

    project_id = to_string(deployment_id)

    project.clone_repository(project_id, repository, branch)

    urls = docker_compose_config.rewrite_variables(project_id)
    container.start_containers(project_id)

    callback.set_log_url(deployment_id, log_url(project_id))
    callback.update_status(deployment_id, "waiting_for_urls")
    urls = project.wait_till_up(urls, project_id)

    callback.set_urls(deployment_id, urls)
    callback.update_status(deployment_id, "started")
    callback.send_deployment_time(diff(utc_now(),start_time))
    
  rescue
    exception ->
      stacktrace = System.stacktrace()
      message = Exception.message(exception)
      handle_error_message(callback, deployment_id, message)
      reraise(exception, stacktrace)
  end

  defp log_url(project_id) do
    base_domain = Application.fetch_env!(:dockup, :base_domain)
    "logio.#{base_domain}/#?projectName=#{project_id}"
  end

  defp handle_error_message(callback, deployment_id, message) do
    message = "An error occured when deploying #{deployment_id} : #{message}"
    Logger.error(message)
    callback.update_status(deployment_id, "failed")
  end
end
