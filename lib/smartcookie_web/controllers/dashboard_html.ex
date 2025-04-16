# lib/smartcookie_web/controllers/dashboard_html.ex
defmodule SmartcookieWeb.DashboardHTML do
  use SmartcookieWeb, :html

  embed_templates "dashboard_html/*"

  def score_percentage(%{correct: correct, total: total}) do
    if total > 0 do
      Float.round(correct / total * 100, 1)
    else
      0.0
    end
  end
end
