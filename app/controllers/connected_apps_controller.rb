class ConnectedAppsController < ApplicationController
  before_action :authorize
  before_action :fetch_connected_app, only: %i[destroy download]

  def index
    @connected_apps = current_user.connected_apps
  end

  def new
    @connected_app = current_user.connected_apps.build
  end

  def create
    @connected_app = current_user.connected_apps.build(connected_app_param)

    if @connected_app.save
      redirect_to connected_apps_path
    else
      render :new
    end
  end

  def destroy
    @connected_app.destroy

    respond_to do |format|
      format.html { redirect_to connected_apps_path }
      format.js
    end
  end

  def download
    send_file @connected_app.public_key_path
  end

  private

  def connected_app_param
    params.require(:connected_app).permit(:name, :redirect_url)
  end

  def fetch_connected_app
    @connected_app = current_user.connected_apps.find(params[:id])
  end
end
