module Disburse

  class Fee

    def self.range(amount)
      case amount.to_f
      when 0...50
        0.01
      when 50..300
        0.0095
      else
        0.0085
      end
    end

    def self.order_fee(amount)
      (amount.to_f * range(amount)).round(2)
    end

    def self.amount_after_fee(amount, fee)
      (amount.to_f - fee).round(2)
    end
  end

end
