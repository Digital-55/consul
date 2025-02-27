namespace :admin do
  root to: "dashboard#index"

  resources :organizations, only: :index do
    get :search, on: :collection
    member do
      put :verify
      put :reject
    end
  end

  namespace :sures do
    resources :actuations
    resources :customizes
    resources :searchs_settings
    resources :customize_cards
  end

  resources :sgs do
    post :create_generic, on: :collection
    get :delete_generic, on: :member
    get :generate_setting, on: :collection
    post :update_setting, on: :member
    get :delete_setting, on: :member
    post :generate_table_setting, on: :member
    get :delete_table_setting, on: :member
    post :generate_table_select, on: :member
    get :delete_table_select, on: :member
  end

  namespace :parbudget do
    resources :ambits do
      post :create_ambit, on: :collection
      post :update_ambit, on: :member
    end
    resources :topics do
      post :generate_topic, on: :collection
      post :update_topic, on: :member
    end
    resources :centers
    resources :projects
    resources :responsibles
    resources :meetings
    resources :editors, only: [:index, :new, :create, :destroy] do
      get :search, on: :collection
    end
    resources :readers, only: [:index, :new, :create, :destroy] do
      get :search, on: :collection
    end

  end

  # namespace :complan do
  #   resources :performances
  #   resources :centers
  #   resources :projects do 
  #     post :create_project, on: :collection
  #     post :update_project, on: :member
  #   end
  #   resources :strategies do 
  #     post :create_strategy, on: :collection
  #     post :update_strategy, on: :member
  #   end
  #   resources :financings
  #   resources :typologies do 
  #     post :create_typology, on: :collection
  #     post :update_typology, on: :member
  #   end
  #   resources :thecnical_tables
  #   resources :editors, only: [:index, :new, :create, :destroy] do
  #     get :search, on: :collection
  #   end
  #   resources :readers, only: [:index, :new, :create, :destroy] do
  #     get :search, on: :collection
  #   end
  # end

  resources :hidden_users, only: [:index, :show] do
    member do
      put :restore
      put :confirm_hide
    end
  end

  resources :hidden_budget_investments, only: :index do
    member do
      put :restore
      put :confirm_hide
    end
  end

  resources :debates, only: :index do
    member do
      put :restore
      put :confirm_hide
    end
  end

  resources :event_agends

  resources :proposals, only: [:index, :show, :update] do
    member { patch :toggle_selection }
    resources :milestones, controller: "proposal_milestones"
    resources :progress_bars, except: :show, controller: "proposal_progress_bars"
  end

  resources :hidden_proposals, only: :index do
    member do
      put :restore
      put :confirm_hide
    end
  end

  resources :users, only: [:index, :new, :show, :destroy] do
    get :hide, on: :member
  end

  resources :profiles

  resources :moderated_texts
  namespace :moderated_texts do
    resources :imports, only: [:new, :create]
  end

  resources :auto_moderated_content, controller: :auto_moderated_content, only: :index do
    put :show_again
    put :confirm_moderation
  end

  resources :proposal_notifications, only: :index do
    member do
      put :restore
      put :confirm_hide
    end
  end

  ### Modified in: config/routes/custom.rb
  ### ToDo: Figure out a way to maintain Consul's routes in this file,
  #         whilst modifying them in routes/custom.rb
  #         The main problem is that routes can not be duplicated
  ###

  resources :budgets do
    member do
      put :calculate_winners
    end

    resources :groups, except: [:show], controller: "budget_groups" do
      resources :headings, except: [:show], controller: "budget_headings"
    end

    resources :budget_investments, only: [:index, :show, :edit, :update] do
      resources :milestones, controller: "budget_investment_milestones"
      resources :progress_bars, except: :show, controller: "budget_investment_progress_bars"
      member { patch :toggle_selection }
    end

    resources :budget_phases, only: [:edit, :update]
  end

  resources :milestone_statuses, only: [:index, :new, :create, :update, :edit, :destroy]

  resources :signature_sheets, only: [:index, :new, :create, :show]

  resources :banners, only: [:index, :new, :create, :edit, :update, :destroy] do
    collection { get :search }
  end

  resources :menus do
    resources :menu_items do
      collection do
        patch :sort
      end
    end
  end

  resources :custom_pages do
    get :draft_preview
    resources :custom_page_modules do
      put :clear_image
      collection do
        patch :sort
      end
    end
    resources :subtitles, controller: :custom_page_modules, type: 'SubtitleModule'
    resources :claims, controller: :custom_page_modules, type: 'ClaimModule'
    resources :rich_texts, controller: :custom_page_modules, type: 'RichTextModule'
    resources :youtubes, controller: :custom_page_modules, type: 'YoutubeModule'
    resources :ctas, controller: :custom_page_modules, type: 'CTAModule'
    resources :custom_images, controller: :custom_page_modules, type: 'CustomImageModule'
    resources :lists, controller: :custom_page_modules, type: 'ListModule'
  end

  resources :comments, only: :index do
    member do
      put :restore
      put :confirm_hide
    end
  end

  resources :topics, only: :index do
    member do
      put :restore
      put :confirm_hide
    end
  end

  resources :tags, only: [:index, :create, :update, :destroy]

  resources :officials, only: [:index, :edit, :update, :destroy] do
    get :search, on: :collection
  end

  resources :settings, only: [:index, :update]
  put :update_map, to: "settings#update_map"
  put :update_content_types, to: "settings#update_content_types"

  resources :moderators, only: [:index, :create, :destroy] do
    get :search, on: :collection
  end

  resources :valuators, only: [:show, :index, :edit, :update, :create, :destroy] do
    get :search, on: :collection
    get :summary, on: :collection
  end

  resources :valuator_groups

  resources :managers, only: [:index, :create, :destroy] do
    get :search, on: :collection
  end

  resources :superadministrators, only: [:index, :new, :create, :destroy] do
    get :search, on: :collection
  end

  resources :administrators, only: [:index, :new, :create, :destroy] do
    get :search, on: :collection
  end

  resources :sures_administrators, only: [:index, :new, :create, :destroy] do
    get :search, on: :collection
  end

  resources :section_administrators, only: [:index, :new, :create, :destroy] do
    get :search, on: :collection
  end

  resources :consultants, only: [:index, :new, :create, :destroy] do
    get :search, on: :collection
  end

  resources :editors, only: [:index, :new, :create, :destroy] do
    get :search, on: :collection
  end
  resources :users, only: [:index, :show, :destroy, :hide]

  scope module: :poll do
    resources :polls do
      get :booth_assignments, on: :collection
      patch :add_question, on: :member

      resources :booth_assignments, only: [:index, :show, :create, :destroy] do
        get :search_booths, on: :collection
        get :manage, on: :collection
      end

      resources :officer_assignments, only: [:index, :create, :destroy] do
        get :search_officers, on: :collection
        get :by_officer, on: :collection
      end

      resources :recounts, only: :index
      resources :results, only: :index
    end

    resources :officers, only: [:index, :new, :create, :destroy] do
      get :search, on: :collection
    end

    resources :booths do
      get :available, on: :collection

      resources :shifts do
        get :search_officers, on: :collection
      end
    end

    resources :questions, shallow: true do
      resources :answers, except: [:index, :destroy], controller: "questions/answers" do
        resources :images, controller: "questions/answers/images"
        resources :videos, controller: "questions/answers/videos"
        get :documents, to: "questions/answers#documents"
      end
      post "/answers/order_answers", to: "questions/answers#order_answers"
    end

    resource :active_polls, only: [:create, :edit, :update]
  end

  resources :verifications, controller: :verifications, only: :index do
    get :search, on: :collection
  end

  resource :activity, controller: :activity, only: :show

  resources :newsletters do
    member do
      post :deliver_user
      post :deliver
    end
    get :users, on: :collection
  end

  resources :admin_notifications do
    member do
      post :deliver
    end
  end

  resources :system_emails, only: [:index] do
    get :view
    get :preview_pending
    put :moderate_pending
    put :send_pending
  end

  resources :emails_download, only: :index do
    get :generate_csv, on: :collection
  end

  resource :stats, only: :show do
    get :proposal_notifications, on: :collection
    get :direct_messages, on: :collection
    get :polls, on: :collection
  end

  namespace :legislation do
    resources :processes do
      resources :questions do
        #post :destroy_question_option, on: :member
        get :other_answers, on: :collection
        get :range_answers, on: :collection
        get :number_answers, on: :collection
      end
      resources :proposals do
        member { patch :toggle_selection }
      end
      resources :draft_versions
      resources :milestones
      resources :progress_bars, except: :show
      resource :homepage, only: [:edit, :update]
    end
  end

  namespace :api do
    resource :stats, only: :show
  end

  resources :geozones, only: [:index, :new, :create, :edit, :update, :destroy]

  namespace :site_customization do
    resources :pages, except: [:show] do
      resources :cards, only: [:index]
    end
    resources :images, only: [:index, :update, :destroy]
    resources :content_blocks, except: [:show]
    delete "/heading_content_blocks/:id", to: "content_blocks#delete_heading_content_block", as: "delete_heading_content_block"
    get "/edit_heading_content_blocks/:id", to: "content_blocks#edit_heading_content_block", as: "edit_heading_content_block"
    put "/update_heading_content_blocks/:id", to: "content_blocks#update_heading_content_block", as: "update_heading_content_block"
    resources :information_texts, only: [:index] do
      post :update, on: :collection
    end
    resources :documents, only: [:index, :new, :create, :destroy]
  end

  resource :homepage, controller: :homepage, only: [:show]

  namespace :widget do
    resources :cards
    resources :feeds, only: [:update]
  end

  namespace :dashboard do
    resources :actions, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :administrator_tasks, only: [:index, :edit, :update]
  end
end
