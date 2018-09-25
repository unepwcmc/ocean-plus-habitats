module SiteHelper

  def active_nav_item?(path)
    request.fullpath == path ? ' active' : ''
  end
end
