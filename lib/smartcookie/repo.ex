defmodule Smartcookie.Repo do
  use Ecto.Repo,
    otp_app: :smartcookie,
    adapter: Ecto.Adapters.Postgres
end
