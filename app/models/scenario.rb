class Scenario < ApplicationRecord
    has_many :outcomes, dependent: :destroy
end
