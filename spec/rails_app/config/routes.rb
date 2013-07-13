RailsApp::Application.routes.draw do

  get "/inactive", to: "accounts#inactive", as: :inactive_account

end
