# WARNING
Do not use as-is as it is only partially working and I did not everything was tested. There is no spec either, shame.

Spree Refinery Auth
==============
Provides authentication and authorization services for use with Spree AND Refinery both on the same project. This is most probably not the best solution, but that works.


Install
-------
add this to your application.rb:

    config.before_initialize do
      # require 'refinery_patch'
      require 'restrict_refinery_to_refinery_users'
    end

    config.to_prepare do
      ::Refinery::AdminController.send :include, ::RestrictRefineryToRefineryUsers
      ::Refinery::AdminController.send :before_filter, :restrict_refinery_to_refinery_users
    end

Add those two Roles in you "spree_roles" table:

- Refinery
- Superuser

Once your app is launched, first go to the Spree user administration and add those two roles to any user you want.

Notes
-----
You can now log as a Spree user. refinery_users, refinery_roles and refinery_roles_users are not used anymore. You still need the refinery_user_plugins.

Known issues
------------
- You can't log out from withing Spree admin, only from Refinery admin (well, there is no a link to the logout of Refinery which kills the session for both. #monkeypatch)
- assigning right within Refinery doesn't work