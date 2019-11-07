module CountriesHelper
  def if_country_get_flag yml_key
    country = I18n.exists?("countries.#{yml_key}.image_flag")
    flag = FileTest.exist?("app/assets/images/#{t("countries.#{yml_key}.image_flag")}")

    country && flag ? image_tag(I18n.t("countries.#{yml_key}.image_flag"), alt: '', class: 'header__icon') : nil
  end
end