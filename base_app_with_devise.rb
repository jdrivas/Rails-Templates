
# Generic rails app with devise, cucumber and guard support

remove_file "README.rdoc"
create_file "README.md" 

# Continuous Testing Framework
gem_group :development, :test do
  gem "rspec-rails"
end

gem_group :test do
  gem "factory_girl_rails"
  gem "capybara"
  gem "launchy"
  gem "database_cleaner"
  gem "cucumber-rails"
  gem "spork-rails"
  gem "guard"
  gem "rb-fsevent"
  gem "guard-rspec"
  gem "guard-cucumber"
  gem "guard-spork"
  gem "guard-livereload"
end

# Debugging Tools
gem_group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

run "bundle install"
generate "rspec:install"
generate "cucumber:install"
run "spork --bootstrap"
run "guard init spork livereload rspec cucumber"

# Add devise?
if yes?("Would you like to install Devise?")
  gem 'devise'
  generate "devise:install"
  model_name = ask("What would you like to call the user model [user]?")
  model_name = "user" if model_name.blank?
  generate "devise", model_name
  run "rake db:migrate"
  run "RAILS_ENV=\"test\" rake db:migrate"
end

# Root controller
if yes?("Would you like to install a root controller?")
  name = ask("What should it be called [Welcome]?").underscore
  name = "welcome" if name.blank?
  generate :controller, "#{name} index"
  remove_file "public/index.html"
  route "root to: \"#{name}#index\""
end

# Create the repo and put in the first commit.
git :init
git :add => "."
git :commit => "-m \"First commit!\""
