module ProportionProtectedHelper
  def global_proportion_protected_html(dataset)
    total_value = habitat_protection(dataset[:id])['total_value']

    t('shared.proportion_protected.card.percentage',
      percentage: habitat_protection(dataset[:id])['protected_percentage'],
      area: total_value_formatted(total_value),
      area_unrounded: number_with_delimiter(total_value, delimiter: ',')).html_safe
  end

  def country_proportion_protected_status_html(dataset)
    status = dataset_status(dataset)

    if absent_or_unknown(status)
      dataset_status_title(dataset)
    else
      country_proportion_protected_html(dataset)
    end
  end

  def country_proportion_protected_html(dataset)
    total_value = @country.protection_stats[dataset[:id]] ? @country.protection_stats[dataset[:id]]['total_value'] : 0

    t('shared.proportion_protected.card.percentage',
      percentage: protected_percentage(dataset),
      area: total_value_formatted(total_value),
      area_unrounded: number_with_delimiter(total_value, delimiter: ',')).html_safe
  end

  def proportion_protected_percentage(dataset)
    current_page?('/') ? habitat_protection(dataset[:id])['protected_percentage'] : protected_percentage(dataset)
  end

  def proportion_protected_icon_class(dataset)
    current_page?('/') ? "icon--#{dataset[:id]}" : icon_class(dataset)
  end

  def proportion_protected_card_modifier(dataset)
    current_page?('/') ? 'present' : dataset_status(dataset)
  end

  def total_value_formatted(value)
    if value.zero?
      0
    elsif value < 0.1
      format('%.2e', value)
    else
      number_with_delimiter(value.round(1), delimiter: ',')
    end
  end
end
