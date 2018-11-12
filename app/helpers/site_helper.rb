module SiteHelper

  def active_nav_item?(path)
    request.fullpath == path ? ' active' : ''
  end

  def getTables habitat
    tables = []

    tables.push(habitat.poly_table) unless habitat.poly_table == nil
    tables.push(habitat.point_table) unless habitat.point_table == nil

    tables
  end
end
