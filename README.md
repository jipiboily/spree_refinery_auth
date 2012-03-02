# WARNING
Do not use as-is as it is only partially working and I did not everything was tested. There is no spec either, shame.

Spree Refinery Auth
==============
Provides authentication and authorization services for use with Spree AND Refinery both on the same project. This is most probably not the best solution, but that works.


Install
-------
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