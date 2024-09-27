defmodule HelloPhx.YRS do
  use Rustler,
    otp_app: :hello_phx,
    crate: :hellophx_yrs

  def add(a, b), do: :erlang.nif_error(:nif_not_loaded)
end
