# require 'rails_helper'

# RSpec.describe UsersController, type: :controller do
#   it { is_expected.to be_an ApplicationController }

#   let(:resource_params) { attributes_for(:user) }

#   let(:user) { instance_double(User, id: 1, as_json: resource_params, **resource_params) }

#   describe 'POST #create' do
#     let(:creator) { UserCreator.new(resource_params) }

#     context 'new user was created' do
#       before { allow(UserCreator).to receive(:new).and_return(creator) }

#       before { expect(creator).to receive(:on).twice.and_call_original }

#       before do
#         expect(creator).to receive(:call) do
#           creator.send(:broadcast, :succeeded, user)
#         end
#       end

#       before { process :create, method: :post, params: { user: resource_params }, format: :json }

#       it('returns created user') { expect(response.body).to eq user.to_json }

#       it('returns HTTP Status Code 201') { expect(response).to have_http_status 201 }
#     end

#     context 'new user was not created' do
#       let(:errors) { instance_double(ActiveModel::Errors) }

#       before { allow(UserCreator).to receive(:new).and_return(creator) }

#       before { expect(creator).to receive(:on).twice.and_call_original }

#       before do
#         expect(creator).to receive(:call) do
#           creator.send(:broadcast, :failed, errors)
#         end
#       end

#       before { process :create, method: :post, params: { user: resource_params }, format: :json }

#       it('returns errors') { expect(response.body).to eq errors.to_json }

#       it('returns HTTP Status Code 422') { expect(response).to have_http_status 422 }
#     end

#     context 'bad request was sent' do
#       before { process :create, method: :post, params: { ' ': resource_params }, format: :json }

#       it('returns HTTP Status Code 400') { expect(response).to have_http_status 400 }
#     end
#   end
# end



