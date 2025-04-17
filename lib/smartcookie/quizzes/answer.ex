# lib/smartcookie/quizzes/answer.ex
defmodule Smartcookie.Quizzes.Answer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Smartcookie.Quizzes.Question
  alias Smartcookie.Quizzes.Attempt

  schema "answers" do
    field :answer_index, :integer
    belongs_to :question, Question
    belongs_to :attempt, Attempt
  end

  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:answer_index, :question_id, :attempt_id])
    |> validate_required([:answer_index, :question_id, :attempt_id])
    |> foreign_key_constraint(:question_id)
    |> foreign_key_constraint(:attempt_id)
  end
end
