# lib/smartcookie/quizzes/answer.ex
defmodule Smartcookie.Quizzes.Answer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Smartcookie.Accounts.User
  alias Smartcookie.Quizzes.Question

  schema "answers" do
    field :answer_index, :integer
    belongs_to :user, User
    belongs_to :question, Question

    timestamps()
  end

  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:answer_index, :user_id, :question_id])
    |> validate_required([:answer_index, :user_id, :question_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:question_id)
  end
end
