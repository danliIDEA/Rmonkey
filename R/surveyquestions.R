#' survey_questions
#' 
#' Creates a data frame from the survey questions and answers
#' 
#' @param survey A sm_survey object, as retrieved by \code{surveylist()}.
#' @return A data frame with one row per question/subquestion/answer choice
#' @export survey_questions
#' 
survey_questions <- function(survey) {
  sd <- survey_details(survey, question_details = TRUE)
  
  # use parser functions to grab questions, choices, and rows
  # Not using choices for now
  questions <- purrr::map_df(sd$pages, parse_page_of_questions) %>%
    mutate(survey_id = sd$id)
  
  rows <- purrr::map_df(sd$pages, parse_page_for_rows) %>%
    rename(subquestion_id = id) %>%
    select(question_id, subquestion_id, subquestion_text = text)
  
  full_questions <- full_join(questions,
                              rows,
                              by = "question_id") %>%
    select(survey_id, question_id, question_type, question_subtype, subquestion_id, heading, subquestion_text)
  
}

# function that returns the table of unique answer choices
survey_choices <- function(survey){
  
  choices <- purrr::map_df(sd$pages, parse_page_for_choices) %>%
    mutate(survey_id = sd$id) %>%
    select(survey_id, question_id, choice_id = id, text, weight, position)
  
  choices
}
