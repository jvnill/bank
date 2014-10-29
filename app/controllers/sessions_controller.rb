class UsersController < Clearance::UsersController
  private

  def url_after_create
    connected_apps_path
  end
end
