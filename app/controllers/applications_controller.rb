class ApplicationsController < ApplicationController
  # GET /applications
  def index
    applications = Application.all
    render json: applications, status: :ok
  end
    
  # POST /applications
  def create
    application = Application.new(application_params)
    if application.save
      render json: { token: application.token }, status: :created
    else
      render json: { error: 'Name is required' }, status: :unprocessable_entity
    end
  end

  # GET /applications/:token
  def show
    application = Application.find_by(token: params[:token])
    if application
      render json: application, status: :ok
    else
      render json: { error: 'Application not found' }, status: :not_found
    end
  end

  # PUT /applications/:token
  def update
    application = Application.find_by(token: params[:token])

    # Prevent token update
    if application_params[:token].present?
      render json: { error: 'Token cannot be updated' }, status: :unprocessable_entity
      return
    end

    if application && application.update(application_params)
      render json: application, status: :ok
    else
      render json: application.errors, status: :unprocessable_entity
    end
  end

  private

  def application_params
    # Ensure only the name can be updated. Token is auto-generated and cannot be updated.
    params.require(:application).permit(:name)
  end
end
