defmodule HelloPhx.YRS do
  use Rustler,
    otp_app: :hello_phx,
    crate: :hellophx_yrs

  def create_doc(), do: :erlang.nif_error(:nif_not_loaded)
  def set_text(_doc, _text), do: :erlang.nif_error(:nif_not_loaded)
  def get_text(_doc), do: :erlang.nif_error(:nif_not_loaded)
end
