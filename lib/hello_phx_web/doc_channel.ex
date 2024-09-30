defmodule HelloPhxWeb.DocChannel do
  alias HelloPhx.Doc.Server, as: DocServer

  use Phoenix.Channel

  def join("doc:" <> _doc_id, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("get_update_for_load", {:binary, state_vector}, socket) do
    update = DocServer.get_update_for_load(state_vector)
    IO.puts("update for load:")
    IO.inspect(update)
    {:reply, {:ok, {:binary, update}}, socket}
  end

  def handle_in("update", {:binary, bin}, socket) do
    DocServer.apply_update(bin)
    broadcast!(socket, "apply_update", {:binary, bin})
    {:noreply, socket}
  end
end
