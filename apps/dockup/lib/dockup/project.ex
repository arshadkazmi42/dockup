defmodule Dockup.Project do
  require Logger
  import Dockup.Retry

  def clone_repository(project_id, repository, branch, command \\ Dockup.Command) do
    project_dir = project_dir(project_id)
    Logger.info "Cloning #{repository} : #{branch} into #{project_dir}"
    File.rm_rf(project_dir)
    File.mkdir_p!(project_dir)
    case command.run("git", ["clone", "--branch=#{branch}", "--depth=1", repository, project_dir]) do
      {_out, 0} -> :ok
      {out, _} -> raise out
    end
  rescue
    error ->
      raise DockupException, "Cannot clone #{branch} of #{repository}. Error: #{error.message}"
  end

  def delete_repository(project_id) do
    project_dir = project_dir(project_id)
    Logger.info "Deleteing project repository at #{project_dir}"
    File.rm_rf(project_dir)
  end

  def project_dir(project_id) do
    Path.join(Dockup.Configs.workdir, project_id)
  end

  def project_dir_on_host(project_id, container \\ Dockup.Container) do
    Path.join(container.workdir_on_host, project_id)
  end

  def project_type(project_id) do
    project_dir = project_dir(project_id)
    cond do
      jekyll_site?(project_dir) -> :jekyll_site
      static_site?(project_dir) -> :static_site
      # Rails etc can be auto detected in the future
      true -> :unknown
    end
  end

  # Waits until the urls all return expected HTTP status.
  # Currently, assuming that URLs are for static sites
  # and they return 200.
  def wait_till_up(service_urls, http \\ __MODULE__, interval \\ 5000) do
    service_urls
    |> Enum.reduce([], fn {_service, port_urls}, acc -> acc ++ Enum.map(port_urls, fn port_url_map -> {port_url_map["url"], 200}  end) end)
    |> Enum.each(fn {url, response} ->
      # Retry 30 times in an interval of 5 seconds
      retry 30 in interval do
        Logger.info "Checking if #{url} returns http satus #{response}"
        ^response = http.get_status(url)
      end
      Logger.info "URL #{url} seem up because they respond with #{response}."
    end)
  end

  def start(project_id, container \\ Dockup.Container, nginx_config \\ Dockup.NginxConfig) do
    container.start_containers(project_id)
    port_mappings = container.port_mappings(project_id)
    port_urls = nginx_config.write_config(project_id, port_mappings)
    container.reload_nginx
    port_urls
  end

  def stop(project_id, container \\ Dockup.Container, nginx_config \\ Dockup.NginxConfig) do
    container.stop_containers(project_id)
    nginx_config.delete_config(project_id)
  end

  def get_status(url) do
    HTTPotion.get(url).status_code
  end

  defp static_site?(project_dir) do
    File.exists? "#{project_dir}/index.html"
  end

  defp jekyll_site?(project_dir) do
    gemfile_path = Path.join(project_dir, "Gemfile")
    File.exists?(gemfile_path) && File.read!(gemfile_path) =~ "jekyll"
  end
end
