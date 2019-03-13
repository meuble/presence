class Line < ApplicationRecord
  validates_presence_of :electricity_metric, :water_metric, :applies_on

  belongs_to :user
end
