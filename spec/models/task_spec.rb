require "rails_helper"

RSpec.describe Task, type: :model do
  describe "バリデーション" do
    it "タイトル、内容、ユーザーがあれば有効である" do
      task = build(:task)

      expect(task).to be_valid
    end

    it "タイトルが空の場合は無効である" do
      task = build(:task, title: "")

      expect(task).not_to be_valid
    end

    it "内容が空の場合は無効である" do
      task = build(:task, content: "")

      expect(task).not_to be_valid
    end

    it "タイトルが50文字を超える場合は無効である" do
      task = build(:task, title: "a" * 51)

      expect(task).not_to be_valid
    end

    it "内容が500文字を超える場合は無効である" do
      task = build(:task, content: "a" * 501)

      expect(task).not_to be_valid
    end

    it "ステータスが空の場合は無効である" do
      task = build(:task, status: nil)

      expect(task).not_to be_valid
    end

    it "優先度が空の場合は無効である" do
      task = build(:task, priority: nil)

      expect(task).not_to be_valid
    end

    it "ユーザーが紐付いていない場合は無効である" do
      task = build(:task, user: nil)

      expect(task).not_to be_valid
    end
  end

  describe "初期値" do
    it "ステータスの初期値は未着手である" do
      task = Task.new

      expect(task.status).to eq "not_started"
    end

    it "優先度の初期値は中である" do
      task = Task.new

      expect(task.priority).to eq "medium"
    end
  end

  describe "表示用ラベル" do
    it "ステータスを日本語で表示できる" do
      task = build(:task, status: :completed)

      expect(task.status_label).to eq "完了"
    end

    it "優先度を日本語で表示できる" do
      task = build(:task, priority: :high)

      expect(task.priority_label).to eq "高"
    end
  end
end
