defmodule Smartcookie.Repo.Migrations.Init do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :question, :text, null: false
      add :options, {:array, :string}, null: false
      add :correct_answer, :integer, null: false
      add :category, :string, null: false
    end

    create table(:attempts) do
      add :user_id, references(:users), null: false
      timestamps()
    end

    create table(:answers) do
      add :attempt_id, references(:attempts), null: false
      add :question_id, references(:questions), null: false
      add :answer_index, :integer, null: false
    end

    create table(:rationale) do
      add :question_id, :integer, null: false
      add :user_id, references(:users), null: false
      timestamps()
    end
  end
end
