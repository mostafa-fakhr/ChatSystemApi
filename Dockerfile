# Use an official Ruby runtime as a parent image
FROM ruby:3.0.2

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev default-mysql-client && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /myapp

# Copy the Gemfile and Gemfile.lock to the working directory
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the wait-for-it script to the container
COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
RUN chmod +x /usr/local/bin/wait-for-it.sh

# Copy the rest of the application code to the container
COPY . .

# Set environment variables
ENV RAILS_ENV=development
ENV RAILS_LOG_TO_STDOUT=true

# Expose port 3000 to the outside world
EXPOSE 3000

# Start the Rails server and wait for the database to be ready
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && /usr/local/bin/wait-for-it.sh db:3306 -- bundle exec rake db:migrate && rails server -b '0.0.0.0'"]
