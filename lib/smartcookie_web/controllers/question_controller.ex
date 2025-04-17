# lib/smartcookie_web/controllers/question_controller.ex
defmodule SmartcookieWeb.QuestionController do
  use SmartcookieWeb, :controller
  alias Smartcookie.Quizzes
  alias Smartcookie.Quizzes.Question
  alias Smartcookie.Quizzes.Attempt

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
      %Smartcookie.Quizzes.Attempt{user_id: 1}
      |> Smartcookie.Repo.insert()

    # Loop through submitted answers
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

    Smartcookie.Repo.insert_all(Smartcookie.Quizzes.Answer, answers)

    redirect(conn, to: "/quiz")
  end

  def answer(conn, %{"id" => id, "answer_index" => answer_index}) do
    user = conn.assigns.current_user
    question = Quizzes.get_question!(id)

    case Quizzes.get_or_create_answer(%{
           user_id: user.id,
           question_id: question.id,
           answer_index: String.to_integer(answer_index)
         }) do
      {:ok, answer} ->
        is_correct = answer.answer_index == question.correct_answer

        conn
        |> put_flash(
          :info,
          if(is_correct,
            do: "Correct!",
            else:
              "Incorrect. The correct answer was #{Enum.at(question.options, question.correct_answer)}."
          )
        )
        |> redirect(to: ~p"/questions/#{question.category}")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Error saving your answer.")
        |> redirect(to: ~p"/questions/#{question.id}")
    end
  end
end
