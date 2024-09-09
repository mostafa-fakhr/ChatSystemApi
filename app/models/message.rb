require 'elasticsearch/model'

class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :chat, counter_cache: true

  validates :number, presence: true, uniqueness: { scope: :chat_id }
  validates :body, presence: true

  before_validation :set_number, on: :create

  # Define indexing behavior for Elasticsearch
  def as_indexed_json(options = {})
    as_json(only: [:body, :chat_id, :created_at, :updated_at])
  end

  # Define Elasticsearch index settings and mappings
  settings index: { 
    analysis: { 
      tokenizer: { 
        ngram_tokenizer: { 
          type: 'ngram', 
          min_gram: 2, 
          max_gram: 3, 
          token_chars: ['letter', 'digit'] 
        } 
      }, 
      analyzer: { 
        custom_analyzer: { 
          type: 'custom', 
          tokenizer: 'ngram_tokenizer', 
          filter: ['lowercase'] 
        } 
      } 
    } 
  } do
    mappings dynamic: 'false' do
      indexes :body, analyzer: 'custom_analyzer'
      indexes :chat_id, type: 'long'
      indexes :created_at, type: 'date'
      indexes :updated_at, type: 'date'
    end
  end

  # Define a search method to query Elasticsearch
  def self.search(query, chat_id)
    __elasticsearch__.search(
      {
        query: {
          bool: {
            must: [
              { match: { chat_id: chat_id } },
              { multi_match: {
                  query: query,
                  fields: ['body'],
                  type: 'phrase_prefix'  # Use phrase prefix matching for partial matches
                }
              }
            ]
          }
        }
      }
    )
  end

  private

  def set_number
    max_number = chat.messages.maximum(:number) || 0
    self.number = max_number + 1
  end
end
