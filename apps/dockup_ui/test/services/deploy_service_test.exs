defmodule DeployServiceTest do
  use DockupUi.ModelCase, async: true

  defmodule FakeDeployQueue do
    def enqueue(_params) do
      send self(), :queued_deployment
      :ok
    end
  end

  test "run returns {:ok, deployment} if deployment is saved and the job is scheduled" do
    deps = [deployment_queue: FakeDeployQueue]
    {:ok, deployment} = DockupUi.DeployService.run(%{git_url: "foo", branch: "bar"}, deps)
    %{git_url: "foo", branch: "bar"} = deployment
    assert_received :queued_deployment
  end

  test "run returns {:error, changeset} if deployment cannot be saved" do
    deps = [deployment_queue: FakeDeployQueue]
    {:error, changeset} = DockupUi.DeployService.run(%{branch: "bar"}, deps)
    assert {:git_url, {"can't be blank", [validation: :required]}} in changeset.errors
    refute_received :queued_deployment
  end
end
