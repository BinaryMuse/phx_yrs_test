defmodule HelloPhx.Doc.Server do
  alias HelloPhx.YRS

  use GenServer

  # Client

  def start_link(arg), do: GenServer.start_link(__MODULE__, arg, name: TheDocServer)

  def apply_update(update) when is_binary(update) do
    GenServer.cast(TheDocServer, {:add_update, update})
  end

  def get_update_for_load(state_vector) do
    GenServer.call(TheDocServer, {:get_update_for_load, state_vector})
  end

  # Server

  @impl true
  def init(_) do
    doc = YRS.create_doc()
    state = %{doc: doc}
    {:ok, state}
  end

  @impl true
  def handle_cast({:add_update, update}, state) do
    doc = state.doc |> YRS.apply_update(update)
    {:noreply, %{state | doc: doc}}
  end

  @impl true
  def handle_call({:get_update_for_load, state_vector}, _from, state) do
    update = YRS.get_update_for_load(state.doc, state_vector)
    {:reply, update, state}
  end
end
