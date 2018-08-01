defmodule DockupUi.Port do
  use Ecto.Schema
  import Ecto.Changeset

  alias DockupUi.{
    Port,
    Container,
    PortSpec,
    Subdomain
  }


  schema "ports" do
    field :endpoint, :string
    field :ready, :boolean

    belongs_to :container, Container
    belongs_to :port_spec, PortSpec
    has_one :subdomain, Subdomain
  end

  @doc false
  def changeset(%Port{} = port, attrs) do
    port
    |> cast(attrs, [:endpoint, :ready, :port_spec_id])
    |> put_assoc(:subdomain, attrs[:subdomain])
    |> validate_required([:port_spec_id])
    |> unique_constraint(:endpoint)
  end
end