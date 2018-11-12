module PostgisUtils
  SRID = 4326.freeze

  def self.intersection(geom, field='the_geom', make_valid=false)
    field = make_valid ? "ST_MakeValid(#{field})" : field
   "ST_Intersects(#{geom_from_text(geom)}, #{field})"
  end

  def self.coords_to_geojson(type, coords)
    {
      "type": type,
      "coordinates": coords
    }
  end

  def self.geom_from_text(geom)
    "ST_GeomFromText('#{geom}', #{SRID})"
  end
end
