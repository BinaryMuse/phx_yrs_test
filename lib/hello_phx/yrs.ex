defmodule HelloPhx.YRS do
  use Rustler,
    otp_app: :hello_phx,
    crate: :hellophx_yrs

  def create_doc(), do: :erlang.nif_error(:nif_not_loaded)
  def apply_update(_doc, _update), do: :erlang.nif_error(:nif_not_loaded)
  def get_update_for_load(_doc, _state_vector), do: :erlang.nif_error(:nif_not_loaded)
end
