module SiteHelper

  def active_nav_item?(path)
    request.fullpath == path ? ' active' : ''
  end

  def getTables
    [@habitat.poly_table, @habitat.point_table].compact
  end
end
