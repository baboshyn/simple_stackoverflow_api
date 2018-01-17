require 'rails_helper'

RSpec.describe QuestionSerializer do
  subject { QuestionSerializer.new create(:question) }

  let(:attributes) { subject.attributes.keys }

  it('returns necessary attributes for Question') { expect(attributes).to eq %i[id title body user_id] }
end
