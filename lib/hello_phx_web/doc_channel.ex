defmodule HelloPhxWeb.DocChannel do
  use Phoenix.Channel

  def join("doc:" <> _doc_id, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("update", {:binary, bin}, socket) do
    broadcast!(socket, "apply_update", {:binary, bin})
    {:noreply, socket}
  end
end
