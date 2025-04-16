# lib/smartcookie/quizzes.ex
defmodule Smartcookie.Quizzes do
  @moduledoc """
  The Quizzes context.
  """

  import Ecto.Query, warn: false
  alias Smartcookie.Repo
  alias Smartcookie.Quizzes.{Question, Answer}

  # Question functions

  def list_questions do
    Repo.all(Question)
  end

  def list_questions_by_category(category) do
    from(q in Question, where: q.category == ^category)
    |> Repo.all()
  end

  def get_question!(id), do: Repo.get!(Question, id)

  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  def change_question(%Question{} = question, attrs \\ %{}) do
    Question.changeset(question, attrs)
  end

  # Answer functions

  def list_user_answers(user_id) do
    from(a in Answer, where: a.user_id == ^user_id)
    |> Repo.all()
    |> Repo.preload(:question)
  end

  def get_answer!(id), do: Repo.get!(Answer, id)

  def create_answer(attrs \\ %{}) do
    %Answer{}
    |> Answer.changeset(attrs)
    |> Repo.insert()
  end

  def get_or_create_answer(attrs) do
    query =
      from a in Answer,
        where:
          a.user_id == ^attrs.user_id and
            a.question_id == ^attrs.question_id,
        limit: 1

    case Repo.one(query) do
      nil -> create_answer(attrs)
      answer -> update_answer(answer, attrs)
    end
  end

  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  def change_answer(%Answer{} = answer, attrs \\ %{}) do
    Answer.changeset(answer, attrs)
  end

  # Quiz statistics functions

  def get_user_score(user_id) do
    query =
      from a in Answer,
        join: q in Question,
        on: a.question_id == q.id,
        where: a.user_id == ^user_id,
        select: %{
          correct:
            fragment("SUM(CASE WHEN ? = ? THEN 1 ELSE 0 END)", a.answer_index, q.correct_answer),
          total: count(a.id)
        }

    case Repo.one(query) do
      %{correct: correct, total: total} ->
        %{correct: correct || 0, total: total || 0}

      _ ->
        %{correct: 0, total: 0}
    end
  end

  def get_user_score_by_category(user_id, category) do
    query =
      from a in Answer,
        join: q in Question,
        on: a.question_id == q.id,
        where: a.user_id == ^user_id and q.category == ^category,
        select: %{
          correct:
            fragment("SUM(CASE WHEN ? = ? THEN 1 ELSE 0 END)", a.answer_index, q.correct_answer),
          total: count(a.id)
        }

    case Repo.one(query) do
      %{correct: correct, total: total} ->
        %{correct: correct || 0, total: total || 0}

      _ ->
        %{correct: 0, total: 0}
    end
  end
end
