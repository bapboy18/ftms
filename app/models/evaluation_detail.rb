class EvaluationDetail < ActiveRecord::Base
  belongs_to :evaluation
  belongs_to :evaluation_template

  validates_each :point do |record, attr, value|
    record.errors.add(attr, "Value out of range between min_point and max_point of template") if
      value < record.evaluation_template.min_point || value > record.evaluation_template.max_point
  end
end
