# ChatSystemApi

## Overview

ChatSystemApi is a Ruby on Rails project designed to build a chat system API. The project allows users to create applications with a unique token and name. Each application can manage multiple chats and messages. The system includes Elasticsearch for message searching, MySQL as the main datastore, and Redis for background job processing.

## Features

- **Applications**: Create and manage applications with unique tokens and names.
- **Chats**: Each application can have multiple chats, each uniquely numbered.
- **Messages**: Messages within chats are uniquely numbered and searchable.
- **Search**: Integrated with Elasticsearch for efficient message searching.
- **Queueing**: Redis is used for background job processing with Sidekiq.

## Technologies Used

- Ruby on Rails
- MySQL (via Docker)
- Elasticsearch (via Docker)
- Redis (via Docker)
- Sidekiq (for background jobs)

## Setup

### Prerequisites

Ensure that you have the following installed on your machine:
- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/)


### Application Endpoints
POST /applications: Create a new application
GET /applications: List all applications
GET /applications/:token: Show a specific application by token
PUT /applications/:token: Update application name

Chat Endpoints
POST /applications/:token/chats: Create a new chat for an application
GET /applications/:token/chats: List all chats for a specific application
PUT /applications/:token/chats/:chat_number: Update chat name

Message Endpoints
POST /applications/:token/chats/:chat_number/messages: Create a new message in a chat
GET /applications/:token/chats/:chat_number/messages: List all messages in a specific chat
PUT /applications/:token/chats/:chat_number/messages/message_number: Update message body
GET /applications/:token/chats/:chat_number/messages/search?q=query: Search for messages by body content within a chat

### Running the Project

To start the project, simply run the following command in the project root directory:

```bash
docker-compose up