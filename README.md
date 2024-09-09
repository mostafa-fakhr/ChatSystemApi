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

### Running the Project

To start the project, simply run the following command in the project root directory:

```bash
docker-compose up
