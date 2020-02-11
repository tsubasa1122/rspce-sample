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

    context '任意入力であること' do
      it 'ご意見・ご要望が任意であること' do
        new_enquete = FoodEnquete.new
        expect(new_enquete).not_to be_valid
        expect(new_enquete.errors[:request]).not_to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe 'アンケート回答時の条件' do
    context '年齢を確認すること' do
      it '未成年はビール飲み放題を選択できないこと' do
        enquete_sato = FoodEnquete.new(
          name: '佐藤 仁美',
          mail: 'hitomi.sato@example.com',
          age: 19,
          food_id: 2,
          score: 3,
          request: 'おいしかったです。',
          present_id: 1
        )
  
        expect(enquete_sato).not_to be_valid
        expect(enquete_sato.errors[:present_id]).to include(I18n.t('activerecord.errors.models.food_enquete.attributes.present_id.cannot_present_to_minor'))
      end

      it '成人はビール飲み放題を選択できないこと' do
        enquete_sato = FoodEnquete.new(
          name: '佐藤 仁美',
          mail: 'hitomi.sato@example.com',
          age: 20,
          food_id: 2,
          score: 3,
          request: 'おいしかったです。',
          present_id: 1
        )
        expect(enquete_sato).to be_valid
      end
    end
  end

  describe '#adult?' do
    it '20歳未満は成人ではないこと' do
      foodEnquete = FoodEnquete.new
      expect(foodEnquete.send(:adult?, 19)).to be_falsey
    end

    it '20歳以上は成人であること' do
      foodEnquete = FoodEnquete.new
      expect(foodEnquete.send(:adult?, 20)).to be_truthy
    end
  end

  describe 'アンケートの回答時の条件' do
    context 'メールアドレスを確認すること' do
      it '同じメールアドレスで再び回答できないこと' do
        enquete_tanaka = FoodEnquete.new(
          name: '田中 太郎',
          mail: 'taro.tanaka@example.com',
          age: 25,
          food_id: 2,
          score: 3,
          request: 'おいしかったです。',
          present_id: 1
        )
        enquete_tanaka.save

        re_enquete_tanaka = FoodEnquete.new(
          name: '田中 太郎',
          mail: 'taro.tanaka@example.com',
          age: 25,
          food_id: 2,
          score: 3,
          request: 'おいしかったです。',
          present_id: 0
        )
        expect(re_enquete_tanaka).not_to be_valid

        expect(re_enquete_tanaka.errors[:mail]).to include(I18n.t('errors.messages.taken'))
        expect(re_enquete_tanaka.save).to be_falsey
        expect(FoodEnquete.all.size).to eq 1
      end
    end
  end
end
