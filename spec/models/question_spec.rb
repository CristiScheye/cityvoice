require 'spec_helper'

describe Question do
  it { should belong_to :voice_file }

  describe 'numerical' do
    let!(:question) { create(:question, :number)}
    it 'returns all questions with numerical feedback type' do
      expect(Question.numerical).to eq([question])
    end
  end
end
