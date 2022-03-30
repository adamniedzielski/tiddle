class NamespacedUsersController < ApplicationController
  before_action :authenticate_namespaced_user!

  def index
    head :ok
  end
end
