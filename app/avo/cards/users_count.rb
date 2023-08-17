class Avo::Cards::UsersCount < Avo::Dashboards::MetricCard
  self.id = "users_count"
  self.label = "Users count"
  self.description = "Total number of registered users"

  def query
    result ::User.all.count
  end
end
