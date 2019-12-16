class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_translations

  def set_translations
    @current_translations = I18n.backend.send(:translations)[I18n.locale]
    @language_options = [{id: 'en', name: 'English'}]
    @current_language = @language_options.select{ |lan| lan[:id] == I18n.locale.to_s }[0]
  end

  private

  def habitats
    I18n.t('global.habitats')
  end
end
