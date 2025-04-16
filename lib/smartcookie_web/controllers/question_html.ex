# lib/smartcookie_web/controllers/question_html.ex
defmodule SmartcookieWeb.QuestionHTML do
  use SmartcookieWeb, :html

  embed_templates "question_html/*"

  def format_categories(questions) do
    questions
    |> Enum.map(& &1.category)
    |> Enum.uniq()
    |> Enum.sort()
  end
end
