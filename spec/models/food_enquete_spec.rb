require 'rails_helper'

RSpec.describe FoodEnquete, type: :model do
  describe '正常系機能' do
    context '回答する' do
      it '正しく登録すること　料理:やきそば food_id: 2, 満足度:良い score: 3, 希望するプレゼント:ビール飲み放題 present_id: 1' do
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
        answered_enquete = FoodEnquete.find(1);

        expect(answered_enquete.name).to eq('田中 太郎')
        expect(answered_enquete.mail).to eq('taro.tanaka@example.com')
        expect(answered_enquete.age).to eq(25)
        expect(answered_enquete.food_id).to eq(2)
        expect(answered_enquete.score).to eq(3)
        expect(answered_enquete.request).to eq('おいしかったです。')
        expect(answered_enquete.present_id).to eq(1)
      end
    end
  end

  describe '入力項目の有無' do
    context '必須入力であること' do
      it 'お名前が必須であること' do
        new_enquete = FoodEnquete.new
        expect(new_enquete).not_to be_valid
        expect(new_enquete.errors[:name]).to include(I18n.t('errors.messages.blank'))
      end

      it 'メールアドレスが必須である事' do
        new_enquete = FoodEnquete.new
        expect(new_enquete).not_to be_valid
        expect(new_enquete.errors[:mail]).to include(I18n.t('errors.messages.blank'))
      end

      it '登録出来ないこと' do
        new_enquete = FoodEnquete.new
        expect(new_enquete.save).to be_falsey
      end
    end
  end
end
