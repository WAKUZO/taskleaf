FactoryBot.define do
  factory :task do
    name {'テストタスク'}
    description {'タスクの内容'}
    # userのファクトリをTaskモデルに定義されたuserという名前の関連を生成するのに利用する
    # taskオブジェクトを生成する際に同時にuserのファクトリを利用して作られたUserオブジェクトがuser関連に入った状態を作ってくれる
    user
  end
end