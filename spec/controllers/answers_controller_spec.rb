require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:attrs) { attributes_for(:answer) }
  let(:answer) { instance_double(Answer, id: 1, as_json: attrs, **attrs) }


  describe '#create' do
    let(:resource_params) { attributes_for(:answer) }

    before do
      expect(AnswersCreator).to receive(:new).with(permit!(resource_params)) do
        double.tap { |answers_creator| expect(answers_creator).to receive(:create).and_return(answer) }
      end
    end

    before { process :create, method: :post, params: { answer: resource_params }, format: :json }

    it { expect(response.body).to eq answer.to_json }

    it { expect(response).to have_http_status 201 }
  end

  describe '#show' do
    before { expect(Answer).to receive(:find).with('1').and_return(answer) }

    before { process :show, method: :get, params: { id: answer.id }, format: :json }

    it { expect(response).to have_http_status 200 }

    it { expect(response.body).to eq answer.to_json }
  end


  describe '#update' do
    let(:resource_params) { attributes_for(:answer) }

    before { expect(Answer).to receive(:find).with("1").and_return(answer) }

    before do
      expect(AnswersUpdater).to receive(:new).with(answer, permit!(resource_params)) do
        double.tap { |answers_updater| expect(answers_updater).to receive(:update).and_return(answer) }
      end
    end

    before { process :update, method: :patch, params: { id: answer.id, answer: resource_params }, format: :json }

    it { expect(response.body).to eq answer.to_json }

    it { expect(response).to have_http_status 200 }
  end

  describe '#index' do
    let(:params) { attributes_for(:answer) }

    before { expect(subject).to receive(:params).and_return(params) }

    before do
      expect(AnswersSearcher).to receive(:new).with(params) do
        double.tap { |answers_searcher| expect(answers_searcher).to receive(:search).and_return(:collection) }
      end
    end

    before { process :index, method: :get, params: params, format: :json }

    it { expect(response.body).to eq :collection.to_json }

    it { expect(response).to have_http_status 200 }
  end


  describe '#destroy' do
    before { expect(Answer).to receive(:find).with('1').and_return(answer) }

    before do
      expect(AnswersDestroyer).to receive(:new).with(answer) do
        double.tap { |answers_destroyer| expect(answers_destroyer).to receive(:destroy) }
      end
    end

    before { process :destroy, method: :delete, params: { id: answer.id }, format: :json }

    it { expect(response).to have_http_status 204 }
  end
end
