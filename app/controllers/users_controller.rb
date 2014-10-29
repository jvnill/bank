class UsersController < Clearance::UsersController
  private

  def url_after_create
    new_connected_app_path
  end
end
