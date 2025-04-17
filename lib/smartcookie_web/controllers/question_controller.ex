# lib/smartcookie_web/controllers/question_controller.ex
defmodule SmartcookieWeb.QuestionController do
  use SmartcookieWeb, :controller
  alias Smartcookie.Quizzes

  def index(conn, _params) do
    questions = Quizzes.list_questions()
    render(conn, :index, questions: questions)
  end

  def quiz(conn, _params) do
    questions = Quizzes.list_questions()
    render(conn, :quiz, questions: questions)
  end

  def submit(conn, params) do
    # Save the attempt
    {:ok, attempt} =
      %Quizzes.Attempt{user_id: 1}
      |> Smartcookie.Repo.insert()

    # Save the answers
    answers =
      params
      |> Enum.filter(fn {k, _v} -> String.starts_with?(k, "question_") end)
      |> Enum.map(fn {"question_" <> id, answer_index} ->
        %{
          attempt_id: attempt.id,
          question_id: String.to_integer(id),
          answer_index: String.to_integer(answer_index)
        }
      end)

    Smartcookie.Repo.insert_all(Quizzes.Answer, answers)
    redirect(conn, to: "/attempt/#{attempt.id}")
  end

  def attempt(conn, %{"id" => id}) do
    answers = Quizzes.list_attempt_answers(id)
    IO.inspect(answers)
    render(conn, :attempt, answers: answers)
  end
end
