resources :csc, only: [:index] do
    get :members, on: :collection
end
