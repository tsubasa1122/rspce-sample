require 'rails_helper'

RSpec.describe FoodEnquete, type: :model do
  describe '正常系の機能' do
    context '回答する' do
      it '正しく登録できること　料理: 焼きそば food_id:2, 満足度:良い score: 3, 希望するプレゼント: ビール飲み放題 present_id: 1' do
        enquete = FoodEnquete.new(
          name: '田中 太郎',
          mail: 'taro.tanaka@example.com',
          age: 25,
          food_id: 2,
          score: 3,
          request: 'おいしかったです。',
          present_id: 1
        )

        expect(enquete).to be_valid
        enquete.save

        answerd_enquete = FoodEnquete.find(1)
        expect(answerd_enquete.name).to eq('田中 太郎')
        expect(answerd_enquete.mail).to eq('taro.tanaka@example.com')
        expect(answerd_enquete.age).to eq(25)
        expect(answerd_enquete.food_id).to eq(2)
        expect(answerd_enquete.request).to eq('おいしかったです。')
        expect(answerd_enquete.present_id).to eq(1)
      end
    end
  end
end
