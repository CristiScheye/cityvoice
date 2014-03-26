class SubjectsController < ApplicationController
  def index
    @subjects = Subject.all
  end

  def show
    @subject = Subject.find_by_param(params[:id])
    @numerical_questions_raw = Question.where(:feedback_type => "numerical_response")
    @numerical_responses = Array.new
    @numerical_questions_raw.each do |q|
      response_hash = Hash.new
      ["Repair", "Remove"].each_with_index do |choice, index|
        @count_of_response = @subject.feedback_inputs.where(:question_id => q.id, :numerical_response => (index+1)).count
        response_hash[choice] = @count_of_response
      end
      @numerical_responses << ResponsePresenter.new(q, response_hash)
      # @numerical_responses << OpenStruct.new(:voice_text => q.voice_text , :short_name => q.short_name, :response_hash => response_hash, :question_text => q.question_text)
    end

    @numerical_responses = Question.numerical # array of question objects
    @numerical_responses.map! do |question|
      response_hash = @subject.feedback_inputs.create_response_hash_for(question)
      question.merge!(response_hash)
    end

    # @numerical_responses = @subject.numerical_feedback_inputs #returns all numerical questions and feedback tallies
    # @voice_responses = @subject.voice_feedback_inputs #returns all voice feedbacks

    #all we need is question text, count of repair responses, and count of remove responses
    #instead of response hash, make subject.question[:repair_count] and subject.remove_count

    #BUT do we need to allow for multiple possible numerical questions? (y)
    #for property x, question y, what are the responses and counts?
    # @numerical_responses = [ <question id: 1, ..., response_hash: { 'option1': 2, 'option2': 10, ...}]}

    #numerical_responses_exist is true if either of those > 0
    #need question text for each question(?) for a property @questions = subject.questions ; @questions.each {|q| q.question_text}

    # Brittle: will want to deal with multiple possible voice questions in the future
    @user_voice_messages = @subject.feedback_inputs.where.not(:voice_file_url => nil)
    # Check for any responses
    @numerical_responses.each do |question|
      question.response_hash.each_pair do |response_text, response_count|
        @numerical_responses_exist = true if response_count > 0
      end
    end
  end
end
