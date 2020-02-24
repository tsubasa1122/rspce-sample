require 'rails_helper'

RSpec.describe "FoodEnquetes", type: :system do
  describe '正常' do
    context "アンケートに回答する" do
      it "回答出来ること" do
        enquete = FactoryBot.create(:food_enquete_tanaka)
        visit "/food_enquetes/new"
        fill_in 'お名前', with: enquete.name
        fill_in 'メールアドレス', with: enquete.mail
        fill_in '年齢', with: enquete.age
        select enquete.food_name, from: 'お召し上がりになった料理'
        choose "food_enquete_score_#{enquete.score}"
        fill_in 'ご意見・ご要望', with: enquete.request
        select enquete.present_name, from: 'ご希望のプレゼント'
        sleep 2
        click_button '登録する'

        expect(page).to have_content 'ご回答ありがとうございました'
        expect(page).to have_content 'お名前: 田中 太郎'
        expect(page).to have_content 'メールアドレス: taro.tanaka@example.com'
        expect(page).to have_content '年齢: 25'
        expect(page).to have_content 'お召し上がりになった料理: やきそば'
        expect(page).to have_content '満足度: 良い'
        expect(page).to have_content 'ご意見・ご要望: おいしかったです。'
        expect(page).to have_content 'ご希望のプレゼント: 【10名に当たる】ビール飲み放題'

        # 【補足】見た目をわかりやすくするために動作を5秒止めています。
        # 通常は自動テストが遅くなりますので不要な処理です。
        sleep 5
      end
    end
  end
  describe '異常' do
    context "必須項目が未入力" do
      it "エラーメッセージが表示され、回答できないこと" do
        # [Point.6-3-1]アンケートページにアクセスします。
        visit "/food_enquetes/new"

        # 【補足】見た目をわかりやすくするために動作を2秒止めています。
        # 通常は自動テストが遅くなりますので不要な処理です。
        sleep 2
        # [Point.6-3-2]「登録する」ボタンをクリックします。
        click_button '登録する'
        # [Point.6-3-3]回答完了時のメッセージが含まれないことを検証します。
        expect(page).not_to have_content 'ご回答ありがとうございました'
        # [Point.6-3-4]必須入力のメッセージが含まれることを検証します。
        expect(page).to have_content 'お名前を入力してください'
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_content '年齢を入力してください'
        expect(page).to have_content '満足度を入力してください'

        # 【補足】見た目をわかりやすくするために動作を5秒止めています。
        # 通常は自動テストが遅くなりますので不要な処理です。
        sleep 5
      end
    end
end