Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      post 'export', to: 'posts#export'
    end
  end
end