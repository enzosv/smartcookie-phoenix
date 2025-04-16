# lib/smartcookie/quizzes/question.ex
defmodule Smartcookie.Quizzes.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :question, :string
    field :options, {:array, :string}
    field :correct_answer, :integer
    field :category, :string

    has_many :answers, Smartcookie.Quizzes.Answer
  end

  def changeset(question, attrs) do
    question
    |> cast(attrs, [:question, :options, :correct_answer, :category])
    |> validate_required([:question, :options, :correct_answer, :category])
    |> validate_length(:options, min: 2)
    |> validate_number(:correct_answer, greater_than_or_equal_to: 0)
    |> validate_correct_answer_in_options_range()
  end

  defp validate_correct_answer_in_options_range(changeset) do
    options = get_field(changeset, :options) || []
    correct_answer = get_field(changeset, :correct_answer)

    if correct_answer != nil && length(options) > 0 && correct_answer >= length(options) do
      add_error(changeset, :correct_answer, "must be within the range of available options")
    else
      changeset
    end
  end
end
