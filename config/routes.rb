Rails.application.routes.draw do
  devise_for :users

  root 'hello_world#index'

  get '/search', to: 'twitchers#search'
  post '/search/results', to: 'twitchers#results'
  get '/history', to: 'users#history'

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
