# WARNING
Do not use as-is as it is only partially working and I did not everything was tested. There is no spec either, shame.

Spree Refinery Auth
==============
It is an extension that provides authentication and authorization overrides so that we can use Spree AND Refinery both on the same project. This is most probably not the best solution, but that mostly works.

Requirements
------------
- Spree 1.1.0.beta
- Refinery 2

Install
-------
Add to your ```Gemfile```

	gem "spree_refinery_auth", :git => "https://github.com/jipiboily/spree_refinery_auth"


In your devise.rb (in config/initializers):

	config.authentication_keys = [ :email ]
	config.router_name = :spree

Add those two Roles in you "spree_roles" table:

- Refinery
- Superuser

Once your app is launched, first go to the Spree user administration and add those two roles to any user you want.

Notes
-----
You can now log as a Spree user. refinery_users, refinery_roles and refinery_roles_users are not used anymore. You still need the refinery_user_plugins.

Known issues
------------
- You can log out from withing Spree admin, but it uses Refinery's log out link (#monkeypatch)
- assigning rights within Refinery doesn't work
- problem with redirection after login from when trying to access "/refinery" at first
- 