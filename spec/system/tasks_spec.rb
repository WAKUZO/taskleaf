require 'rails_helper'

describe 'タスク管理機能' , type: :system do
  # ユーザAとBを作る
  let(:user_a){create(:user, name: 'ユーザーA', email: 'a@example.com')}
  let(:user_b){create(:user, name: 'ユーザーB', email: 'b@example.com')}
  # ユーザAのタスクをlet!であらかじめ作る
  let!(:task_a){create(:task, name: 'タスクA', created_at: 1.hour.ago, user: user_a)}
  let!(:task_a_2){create(:task, name: 'タスクA_2', created_at: 1.day.ago, user: user_a)}

  # このbeforeはcontextが呼び出される前に実行される
  before do
    # ログイン処理
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログイン'
  end

  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    it {expect(page).to have_content 'タスクA'}
  end

  describe '一覧表示' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user){user_a}

      it_behaves_like 'ユーザーAが作成したタスクが表示される'

      it 'ユーザーAが作成したタスクが新しい順に並ぶ' do
        visit tasks_path
        expect(page.text).to match(/#{task_a.name}.*#{task_a_2.name}/)
      end
    end

    context 'ユーザーBがログインしているとき' do
      let(:login_user){user_b}

      it 'ユーザーAが作成したタスクが表示されない' do
        #ユーザーAが作成したタスクの名称が画面上に表示されていないことを確認
        expect(page).not_to have_content 'タスクA'
      end
    end
  end

  describe '詳細表示' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user){user_a}
      
      before do
        visit task_path(task_a)
      end

      it_behaves_like 'ユーザーAが作成したタスクが表示される'

    end
  end

  describe '新規作成' do
    let(:login_user){user_a}

    before do
      visit new_task_path
      fill_in 'Name', with: task_name
      click_button 'Create Task'
    end

    context '新規作成画面でNameを入力したとき' do
      let(:task_name){'新規作成のタスク'}
      
      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '新規作成のタスク'
      end
    end

    context '新規作成画面でNameを空入力したとき' do
      let(:task_name){''}
      
      it 'エラーになる' do
        within '#error_explanation' do
          expect(page).to have_content "Name can't be blank"
        end
      end
    end

    context '新規作成画面でNameにカンマを入力したとき' do
      let(:task_name){'タスク,'}
      
      it 'エラーになる' do
        within '#error_explanation' do
          expect(page).to have_content "Name にカンマを含めることはできません"
        end
      end
    end
  end

  describe '編集' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user){user_a}

      before do
        visit edit_task_path(task_a)
        fill_in 'Name', with: other_task
        click_button 'Update Task'
      end

      context 'フォームの入力値が正常' do
        let(:other_task){'他のタスクA'}

        it 'タスクが更新される' do
          expect(page).to have_selector '.alert-success', text: '他のタスクA'
        end
      end
    end
  end

  describe '削除' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user){user_a}

      before do
        # 詳細画面に遷移
        visit task_path(task_a)
      end

      it_behaves_like 'ユーザーAが作成したタスクが表示される'

      it 'タスクが削除される' do
        expect {
          click_link '削除'
          expect(page).to have_selector '.alert-success', text: 'タスクA'
        }.to change(Task, :count).by(-1)
      end
    end
  end
end