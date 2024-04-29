# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# Set deployment environment to production
ENV RAILS_ENV=production \
    RACK_ENV=production \
    BUNDLE_WITHOUT="development:test"

# Add the node repo for Node.js LTS version
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -

# Install packages needed to build gems and run the app
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips pkg-config nodejs

# Install application gems, skipping dev and test groups
COPY Gemfile Gemfile.lock ./
RUN bundle config set without 'development test' && \
    bundle install --jobs 4 --retry 3

# Copy application code
COPY . .

# Precompile assets and bootsnap for production
RUN bundle exec bootsnap precompile && \
    bundle exec rake assets:precompile

# Prepare entrypoint
COPY bin/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails ./
USER rails:rails

# Expose port and start the server
EXPOSE 3000
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
