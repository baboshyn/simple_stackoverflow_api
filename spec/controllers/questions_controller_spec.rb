require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  # xit { is_expected.to be_an ApplicationController }
  let(:attrs) { attributes_for(:question) }
  let(:question) { instance_double(Question, id: 1, as_json: attrs, **attrs) }


  describe '#create' do
    let(:resource_params) { attributes_for(:question) }

    before do
      expect(QuestionsCreator).to receive(:new).with(permit!(resource_params)) do
        double.tap { |questions_creator| expect(questions_creator).to receive(:create).and_return(question) }
      end
    end

    before { process :create, method: :post, params: { question: resource_params }, format: :json }

    it { expect(response.body).to eq question.to_json }

    it { expect(response).to have_http_status 201 }
  end

  describe '#show' do
    before { expect(Question).to receive(:find).with('1').and_return(question) }

    before { process :show, method: :get, params: { id: question.id }, format: :json }

    it { expect(response).to have_http_status 200 }

    it { expect(response.body).to eq question.to_json }
  end


  describe '#update' do
    let(:resource_params) { attributes_for(:question) }

    before { expect(Question).to receive(:find).with("1").and_return(question) }

    before do
      expect(QuestionsUpdater).to receive(:new).with(question, permit!(resource_params)) do
        double.tap { |questions_updater| expect(questions_updater).to receive(:update).and_return(question) }
      end
    end

    before { process :update, method: :patch, params: { id: question.id, question: resource_params }, format: :json }

    it { expect(response.body).to eq question.to_json }

    it { expect(response).to have_http_status 200 }
  end

  describe '#index' do
    let(:params) { attributes_for(:question) }

    before { expect(subject).to receive(:params).and_return(params) }

    before do
      expect(QuestionsSearcher).to receive(:new).with(params) do
        double.tap { |questions_searcher| expect(questions_searcher).to receive(:search).and_return(:collection) }
      end
    end

    before { process :index, method: :get, params: params, format: :json }

    it { expect(response.body).to eq :collection.to_json }

    it { expect(response).to have_http_status 200 }
  end


  describe '#destroy' do
    before { expect(Question).to receive(:find).with('1').and_return(question) }

    before do
      expect(QuestionsDestroyer).to receive(:new).with(question) do
        double.tap { |questions_destroyer| expect(questions_destroyer).to receive(:destroy) }
      end
    end

    before { process :destroy, method: :delete, params: { id: question.id }, format: :json }

    it { expect(response).to have_http_status 204 }
  end
end
