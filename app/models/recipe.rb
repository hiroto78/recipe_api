class Recipe < ApplicationRecord
  belongs_to :author
  has_many :ratings

  # Scope
  scope :by_alive, -> { where(deleted_at: nil) }

  IMPERIAL = {
    kg: {
      rate: 2.2,
      new_unit: 'lb'
    },
    g: {
      rate: 0.035,
      new_unit: 'ounce'
    }
  }.freeze

  METRICS = {
    lb: {
      rate: 0.49,
      new_unit: 'kg'
    },
    ounce: {
      rate: 28,
      new_unit: 'g'
    }
  }.freeze

  def specified_ingredient(request_unit)
    return ingredient if request_unit.nil?

    if request_unit == 'imperial'
      imperialized_ingredient
    else # metrics
      metricized_ingredient
    end
  end

  def imperialized_ingredient
    ingredient.map do |item|
      if IMPERIAL.keys.include?(item['unit'].to_sym)
        conf = IMPERIAL[item['unit'].to_sym]
        {
          item: item['item'],
          value: (BigDecimal(item['value'].to_s) * BigDecimal(conf[:rate].to_s)),
          unit: conf[:new_unit]
        }
      else
        item
      end
    end
  end

  def metricized_ingredient
    ingredient.map do |item|
      if METRICS.keys.include?(item['unit'].to_sym)
        conf = METRICS[item['unit'].to_sym]
        {
          item: item['item'],
          value: (BigDecimal(item['value'].to_s) * BigDecimal(conf[:rate].to_s)),
          unit: conf[:new_unit]
        }
      else
        item
      end
    end
  end
end
