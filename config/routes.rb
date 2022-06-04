Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'sequra/orders'
      get 'sequra/disburse_report'
      get 'sequra/merchants'
      get 'sequra/shoppers'
    end
  end

  root 'api/v1/sequra#orders'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
