class Avo::Dashboards::Overview < Avo::Dashboards::BaseDashboard
  self.id = "overview"
  self.name = "Overview"
  self.grid_cols = 4

  def cards
    card Avo::Cards::UsersCount
  end
end
