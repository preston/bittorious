Rails.application.routes.draw do

	devise_for :users, :controllers => { registrations: :registrations } 

	resources :users do
		member do
			post :deny
			post :approve
		end
	end

	resources :feeds do
		resources :permissions
		resources :torrents do
			member do
				get :peers
			end
		end
		member do
			get :settings
			# patch :grant
			post :grant
		end
	end

	get 'scrape' => 'tracker#scrape'
	get 'announce' => 'tracker#announce'

	get 'landing' => "welcome#landing"
	get 'dashboard' => "welcome#dashboard"
	get 'concepts' => "welcome#concepts"
	get 'history' => "welcome#history"
	get 'deployment' => "welcome#deployment"
	get 'status' => "welcome#status"
	get 'legal' => "welcome#legal"
	get 'faq' => "welcome#faq"
	get 'getting_started' => "welcome#getting_started",	as: :getting_started

	root :to => 'welcome#landing'
	get 'dashboard/feeds' => 'welcome#feeds'
	get 'dashboard/torrents' => 'welcome#torrents'
	get 'dashboard/settings' => 'welcome#settings'

end
