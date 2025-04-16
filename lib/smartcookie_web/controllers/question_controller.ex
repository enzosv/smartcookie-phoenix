# lib/smartcookie_web/controllers/question_controller.ex
defmodule SmartcookieWeb.QuestionController do
  use SmartcookieWeb, :controller
  alias Smartcookie.Quizzes
  alias Smartcookie.Quizzes.Question

  def index(conn, _params) do
    questions = Quizzes.list_questions()
    render(conn, :index, questions: questions)
  end

  def category(conn, %{"category" => category}) do
    questions = Quizzes.list_questions_by_category(category)
    render(conn, :category, questions: questions, category: category)
  end

  def show(conn, %{"id" => id}) do
    question = Quizzes.get_question!(id)
    render(conn, :show, question: question)
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
