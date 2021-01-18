# The `Account` and `Public` Namespaces for Controllers and Views
Many web applications have a private section where users manage their data and separate public pages where that data is presented to site visitors (e.g. Yelp, Airbnb, etc.) To make these applications easy to develop, we have a default `Account` namespace for those private views and controllers where users manage their account data.

## Additional Namespaces
In Bullet Train applications with [multiple team types](/docs/teams.md), you may find it helpful to introduce additional controller and view namespaces to represent and organize user interfaces and experiences for certain team types that vary substantially from the `Account` namespace default.
