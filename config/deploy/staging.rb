role :web, '107.20.169.69'
role :app, '107.20.169.69'
role :db,  '107.20.169.69', :primary => true

set :rails_env, 'staging'