Striped
========
This gems handles the basics of user accounts for Rails, such as validating account currency.

Configuration
-------------
Accounts.configure can be used to configure the gem (you can add the configuration anywhere, most likely in your iniializers)

    Accounts.configure do |config|
      config.provider = :stripe
    end

Available configuration options are:
* active_statuses: an array of account statuses considered active
* current_account_method: a symbol that corresponds to the helper method used to get the current account (default: :current_user)
* inactive_account_path: a symbol that corresponds to the name of the path to which to redirect if the account is inactive
* overdue_status: a status name for the overdue accounts
* provider: the name of the 3rd party service that handles accounts (currently: :stripe)
* scope: the name of the model of the account object (default: :user)
* trialing_status: a status name for the trialing accounts (default: :trialing)


