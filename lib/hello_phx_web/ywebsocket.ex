defmodule HelloPhxWeb.DocSocket do
  use Phoenix.Socket

  channel "doc:*", HelloPhxWeb.DocChannel

  def connect(_params, socket, _connect_info) do
    {:ok, assign(socket, :user_id, 1234)}
  end

  def id(socket), do: "docsocket:#{socket.assigns.user_id}"
end
