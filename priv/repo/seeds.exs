alias Smartcookie.Quizzes

# Clear existing questions
Smartcookie.Repo.delete_all(Smartcookie.Quizzes.Question)

# Anatomy questions
anatomy_questions = [
  %{
    question: "What is the most dependent portion of the abdominal cavity in a supine person?",
    options: ["Lesser sac", "Morison pouch", "Pouch of Douglas", "Right paracolic gutter"],
    # 0-indexed, so 2 = "Pouch of Douglas"
    correct_answer: 2,
    category: "anatomy"
  },
  %{
    question: "Which of the following is NOT a branch of the external carotid artery?",
    options: ["Facial artery", "Lingual artery", "Ophthalmic artery", "Occipital artery"],
    correct_answer: 2,
    category: "anatomy"
  },
  %{
    question: "Which cranial nerve controls eye movements?",
    options: [
      "Optic nerve (CN II)",
      "Oculomotor nerve (CN III)",
      "Trochlear nerve (CN IV)",
      "Abducens nerve (CN VI)"
    ],
    correct_answer: 1,
    category: "anatomy"
  }
]

# Add all questions to the database
Enum.each(anatomy_questions, fn question_attrs ->
  Quizzes.create_question(question_attrs)
end)
