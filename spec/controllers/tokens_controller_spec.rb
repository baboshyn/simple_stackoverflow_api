require 'rails_helper'

RSpec.describe TokensController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  it('authenticate user') { is_expected.to be_kind_of(ActionController::HttpAuthentication::Basic::ControllerMethods) }

  describe 'POST #create' do
    context 'user passed authentication' do
      let(:user) { instance_double User, id: '1' }

      before { sign_in user }

      context 'user did not pass authorization' do
        before { expect(subject).to receive(:authorize).and_raise Pundit::NotAuthorizedError }

        before { process :create, method: :post, format: :json }

        it('returns HTTP Status Code 403') { expect(response).to have_http_status 403 }
      end

      context 'user passed authorization' do
        let(:token) { double }

        before { allow(subject).to receive(:authorize).and_return true }

        before { allow(SimpleStackoverflowToken).to receive(:encode).with({ user_id: user.id }).and_return(token) }

        before { process :create, method: :post, format: :json }

        it('returns created token') { expect(response.body).to eq ({ token: token }).to_json }

        it('returns HTTP Status Code 201') { expect(response).to have_http_status 201 }
      end
    end




  #   context 'user was not found by email' do
  #     before { expect(User).to receive(:find_by!).with(email: 'email'.downcase).and_raise ActiveRecord::RecordNotFound }

  #     before { process :create, method: :post }

  #     it('returns HTTP Status Code 404') { expect(response).to have_http_status 404 }
  #   end

  #   context 'user was found by email' do
  #     let(:user) { instance_double User, id: '1' }

  #     before { allow(User).to receive(:find_by!).with(email: 'email'.downcase).and_return(user) }

  #     context 'user did not pass authentication' do
  #       before { allow(user).to receive(:authenticate).with('password').and_return(false) }

  #       before { process :create, method: :post }

  #       it('returns HTTP Status Code 401') { expect(response).to have_http_status 401 }

  #       it('returns "HTTP Basic: Access denied."') { expect(response.body).to eq "HTTP Basic: Access denied.\n" }

  #       it('returns header "WWW-Authenticate"') { expect(response.header['WWW-Authenticate']).to eq "Basic realm=\"Application\"" }
  #     end


  #   end
  end
end

































#    let(:params) { { login: { email: 'test', password: 'test' } } }

#     let(:resource_params) { params[:login] }

#     let(:user) { instance_double User, id: '1' }

#     context 'user was not found by email' do
#       before { expect(User).to receive(:find_by!).with(email: resource_params[:email].downcase).and_raise ActiveRecord::RecordNotFound }

#       before { process :create, method: :post, params: params, format: :json }

#       it('returns HTTP Status Code 404') { expect(response).to have_http_status 404 }
#     end

#     context 'user was found by email' do
#       before do
#         allow(User).to receive(:find_by!).with(email: resource_params[:email].downcase).and_return(user)
#       end



#         context 'password is not valid and user did not pass authorization' do
#           before { allow(user).to receive(:authenticate).with(resource_params[:password]).and_return(false) }

#           before { expect(subject).to receive(:authorize).and_raise Pundit::NotAuthorizedError }

#           before { process :create, method: :post, params: params, format: :json }

#           it('returns HTTP Status Code 403') { expect(response).to have_http_status 403 }
#         end

#         context 'password is valid' do
#           let(:token) { double }

#           before { allow(user).to receive(:authenticate).with(resource_params[:password]).and_return(true) }

#           context 'user did nor pass authorization, (not confirmed)' do
#             before { expect(subject).to receive(:authorize).and_raise Pundit::NotAuthorizedError }

#             before { process :create, method: :post, params: params, format: :json }

#             it('returns HTTP Status Code 403') { expect(response).to have_http_status 403 }
#           end

#           context 'user passed authorization' do
#             before { allow(SimpleStackoverflowToken).to receive(:encode).with({user_id: user.id}).and_return(token) }

#             before { process :create, method: :post, params: params, format: :json }

#             it('returns created token') { expect(response.body).to eq ({ token: token }).to_json }

#             it('returns HTTP Status Code 201') { expect(response).to have_http_status 201 }
#           end
#         end

#         context 'bad request was sent' do
#           before { process :create, method: :post, params: {' ': resource_params}, format: :json }

#           it('returns HTTP Status Code 400') { expect(response).to have_http_status 400 }
#         end
#     end
#   end
# end
