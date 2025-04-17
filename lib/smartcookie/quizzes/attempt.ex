# lib/smartcookie/quizzes/attempt.ex
defmodule Smartcookie.Quizzes.Attempt do
  use Ecto.Schema
  import Ecto.Changeset
  alias Smartcookie.Accounts.User

  schema "attempts" do
    belongs_to :user, User
    timestamps()
  end

  def changeset(attempt, attrs) do
    attempt
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
    |> foreign_key_constraint(:user_id)
  end
end
