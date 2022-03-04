# By default engine routes are drawn after application routes, so this is our best attempt at allowing engines to
# define routing concerns (like `sortable`) that can be used by application routes in this file.
BulletTrain.routing_concerns.each { |concern| instance_eval(&concern) }
