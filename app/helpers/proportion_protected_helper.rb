module ProportionProtectedHelper
  def global_proportion_protected_html(dataset)
    t('shared.proportion_protected.card.percentage',
      percentage: habitat_protection(dataset[:id])['protected_percentage'],
      area: number_with_delimiter(
        habitat_protection(dataset[:id])['total_value'], 
        delimiter: ','
      )
    ).html_safe
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
    t('shared.proportion_protected.card.percentage',
      percentage: protected_percentage(dataset),
      area: number_with_delimiter(total_value(dataset), delimiter: ',')
    ).html_safe
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
end