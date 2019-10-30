module CountriesHelper
  def country_flag_exists? yml_key
    country = I18n.exists?("countries.#{yml_key}.image_flag")
    flag = FileTest.exist?("app/assets/images/#{t("countries.#{yml_key}.image_flag")}")

    country && flag
  end

  def get_habitat_icon_class (habitat, status)
    status = status == 'present' ? '' : "-#{status}"

    "icon--#{habitat}#{status}"
  end
end