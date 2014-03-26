class Question < ActiveRecord::Base
  belongs_to :voice_file

  attr_protected

  scope :numerical, -> { where(feedback_type: 'numerical_response') }
end
