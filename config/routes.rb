BitTorious::Application.routes.draw do


	devise_for :users, :controllers => { :registrations => 'registrations' } 

	resources :torrents

	resources :feeds do
		resources :permissions
		member do
			put :grant
			post :grant
		end
	end

	get 'scrape' => 'torrents#scrape'
	get "tags/torrents" => "torrents#tags", :as => :tags

	get 'search' => 'torrents#search'
	get 'announce' => 'torrents#announce', :as => 'announce'

	get 'manage' => 'users#manage'
	post 'manage/:user_id/deny' => 'users#deny', as: :deny_user
	post 'manage/:user_id/approve' => 'users#approve', as: :approve_user
	put  'manage/:user_id' => 'users#update', as: :update_user
	post 'manage/:user_id/transfer' => 'users#transfer', as: :transfer_ownership

	get 'landing' => "welcome#landing",		as: :landing
	get 'dashboard' => "welcome#dashboard",	as: :dashboard
	get 'concepts' => "welcome#concepts",	as: :concepts
	get 'history' => "welcome#history",	as: :history
	get 'deployment' => "welcome#deployment",	as: :deployment
	get 'status' => "welcome#status",		as: :status
	get 'legal' => "welcome#legal",			as: :legal
	get 'faq' => "welcome#faq",				as: :faq
	get 'getting_started' => "welcome#getting_started",	as: :getting_started

	root :to => 'welcome#landing'

end
