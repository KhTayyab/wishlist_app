class AppConfigurationsController < ApplicationController

	before_action :set_app_configuration, only: [:show, :edit, :update, :destroy]

  # GET /app_configurations
  # GET /app_configurations.json
  def index
    app_configuration = AppConfiguration.find_by_shop_url(params[:shop])
    if app_configuration.nil?
      @app_configuration = AppConfiguration.create(:shop_url => params[:shop])
      render "edit"
    else
      @app_configuration = AppConfiguration.find_by_shop_url(params[:shop])
      render "edit"
    end
  end

  # GET /app_configurations/1/edit
  def edit
  end

  # PATCH/PUT /app_configurations/1
  # PATCH/PUT /app_configurations/1.json
  def update
    respond_to do |format|
      if @app_configuration.update(app_configuration_params)
        format.html { redirect_to app_configurations_path(:shop => @app_configuration.shop_url), notice: 'App configuration was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_configuration
      @app_configuration = AppConfiguration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_configuration_params
      params.require(:app_configuration).permit(:shop_url, :actual_shop_url, :api_key, :api_password, :shop_name, :to_email_address, :cc_email_address)
    end

end
