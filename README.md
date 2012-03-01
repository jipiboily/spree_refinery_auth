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

Once your app is launched, first go to the Spree user administration and add those two roles to any user that have to.

Known issues
------------
- You can't log out from withing Spree admin, only from Refinery admin