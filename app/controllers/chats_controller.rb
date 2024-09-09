class ChatsController < ApplicationController
  before_action :set_application
  before_action :set_chat, only: [:show, :update]

  # POST /applications/:token/chats
  def create
    chat = @application.chats.new(chat_params)
    if chat.save
      render json: { number: chat.number }, status: :created
    else
      render json: { error: 'Name is required' }, status: :unprocessable_entity if chat.errors[:name].present?
    end
  end

  # GET /applications/:token/chats
  def index
    chats = @application.chats
    render json: chats, status: :ok
  end

  # GET /applications/:token/chats/:number
  def show
    if @chat
      render json: @chat, status: :ok
    else
      render json: { error: 'Chat not found' }, status: :not_found
    end
  end

  # PUT /applications/:token/chats/:number
  def update
    if @chat.update(chat_params)
      render json: @chat, status: :ok
    else
      render json: { error: 'Name is required' }, status: :unprocessable_entity if @chat.errors[:name].present?
    end
  end

  private

  def set_application
    @application = Application.find_by(token: params[:application_token])
    unless @application
      render json: { error: 'Application not found' }, status: :not_found
    end
  end

  def set_chat
    @chat = @application.chats.find_by(number: params[:number])
    unless @chat
      render json: { error: 'Chat not found' }, status: :not_found
    end
  end

  def chat_params
    params.require(:chat).permit(:name)
  end
end
