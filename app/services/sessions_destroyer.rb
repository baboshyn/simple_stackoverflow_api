class SessionsDestroyer
  def initialize(user)
    @user = user
  end

  def destroy
    @user.sessions.destroy_all
  end
end
