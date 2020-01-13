module CommonModule
  extend ActiveSupport::Concern

  TAX = 1.08        # 本体価格 + 消費税率
  SCORE_BAD = 1     # 満足度:悪い
  SCORE_NORMAL = 2  # 満足度:普通
  SCORE_GOOD = 3    # 満足度:良い

  included do
    
    validates :name, presence: true, length: { maximum: 16 }
    validates :mail, presence: true, length: { maximum: 64 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false}
    validates :age, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
    validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 3 }
    validates :request, length: { maximum: 150 }
  end

  def tax_included_price(price)
    (BigDecimal(price.to_s) * BigDecimal(TAX.to_s)).floor
  end

  def view_score
    case self.score
    when SCORE_BAD
      I18n.t('common.score.bad')
    when SCORE_NORMAL
      I18n.t('common.score.normal')
    when SCORE_GOOD
      I18n.t('common.score.good')
    else
      I18n.t('common.score.unknown')
    end
  end
end
