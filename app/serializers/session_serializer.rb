class SessionSerializer < ActiveModel::Serializer
  attributes :id, :auth_token
end
