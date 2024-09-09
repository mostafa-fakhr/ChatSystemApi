class MessagesController < ApplicationController
  before_action :set_application
  before_action :set_chat
  before_action :set_message, only: [:show, :update]

  # POST /applications/:token/chats/:number/messages
  def create
    message = @chat.messages.new(message_params)
    if message.save
      render json: { number: message.number }, status: :created
    else
      render json: message.errors, status: :unprocessable_entity
    end
  end

  # GET /applications/:token/chats/:number/messages
  def index
    messages = @chat.messages
    render json: messages, status: :ok
  end

  # GET /applications/:token/chats/:number/messages/:number
  def show
    render json: @message, status: :ok
  end

  # PUT /applications/:token/chats/:number/messages/:number
  def update
    if @message.update(message_params)
      @message.__elasticsearch__.index_document # Update Elasticsearch index
      render json: @message, status: :ok
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

# GET /applications/:token/chats/:number/messages/search
def search
  unless request.get?
    return render json: { error: 'Method not allowed. Use GET for searching.' }, status: :method_not_allowed
  end

  query = params[:query]
  chat_id = params[:chat_id] || @chat.id

  if query.present? && chat_id.present?
    results = Message.search(query, chat_id)
    if results.records.any?
      render json: results.records.map(&:as_json), status: :ok
    else
      render json: { error: 'No messages found matching the query' }, status: :not_found
    end
  else
    render json: { error: 'Query parameter is required' }, status: :bad_request
  end
end



  private

  def set_application
    @application = Application.find_by(token: params[:application_token])
    render json: { error: 'Application not found' }, status: :not_found unless @application
  end

  def set_chat
    @chat = @application.chats.find_by(number: params[:chat_number] || params[:number])
    render json: { error: 'Chat not found' }, status: :not_found unless @chat
  end

  def set_message
    @message = @chat.messages.find_by(number: params[:number])
    render json: { error: 'Message not found' }, status: :not_found unless @message
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
