role :web, "107.20.170.68"
role :app, "107.20.170.68"
role :db,  "107.20.170.68", :primary => true

set :rails_env, 'staging'