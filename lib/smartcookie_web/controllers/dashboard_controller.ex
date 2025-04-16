# lib/smartcookie_web/controllers/dashboard_controller.ex
defmodule SmartcookieWeb.DashboardController do
  use SmartcookieWeb, :controller
  alias Smartcookie.Quizzes

  def index(conn, _params) do
    user = conn.assigns.current_user

    # Get overall statistics
    overall_stats = Quizzes.get_user_score(user.id)

    # Get questions and categories for sidebar
    questions = Quizzes.list_questions()

    categories =
      questions
      |> Enum.map(& &1.category)
      |> Enum.uniq()
      |> Enum.sort()

    # Get stats per category
    category_stats =
      Enum.map(categories, fn category ->
        {category, Quizzes.get_user_score_by_category(user.id, category)}
      end)

    render(conn, :index,
      overall_stats: overall_stats,
      category_stats: category_stats,
      categories: categories
    )
  end
end
