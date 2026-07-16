require "rails_helper"

RSpec.describe "Tasks", type: :request do
  let(:user) { create(:user) }

  describe "ログインしていない場合" do
    it "タスク一覧を開くとログイン画面へリダイレクトする" do
      get tasks_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "ログインしている場合" do
    before do
      sign_in user
    end

    describe "GET /tasks" do
      it "自分のタスクだけを表示する" do
        own_task = create(:task, user: user, title: "自分のタスク")
        other_task = create(:task, title: "他のユーザーのタスク")

        get tasks_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(own_task.title)
        expect(response.body).not_to include(other_task.title)
      end

      it "キーワードに一致するタスクを表示する" do
        matched_task = create(:task, user: user, title: "Railsを勉強する")
        unmatched_task = create(:task, user: user, title: "買い物をする")

        get tasks_path, params: { q: "Rails" }

        expect(response.body).to include(matched_task.title)
        expect(response.body).not_to include(unmatched_task.title)
      end

      it "指定した並び順でタスクを表示する" do
        old_task = create(:task, user: user, title: "古いタスク", created_at: 2.days.ago)
        new_task = create(:task, user: user, title: "新しいタスク", created_at: 1.day.ago)

        get tasks_path, params: { sort: "oldest" }

        expect(response.body.index(old_task.title)).to be < response.body.index(new_task.title)
      end
    end

    describe "GET /tasks/:id" do
      it "タスク詳細を表示する" do
        task = create(:task, user: user)

        get task_path(task)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(task.title)
      end

      it "他のユーザーのタスクは表示しない" do
        other_task = create(:task)

        get task_path(other_task)

        expect(response).to have_http_status(:not_found)
      end
    end

    describe "GET /tasks/new" do
      it "新規作成画面を表示する" do
        get new_task_path

        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /tasks" do
      it "ログイン中のユーザーにタスクを作成する" do
        task_params = {
          title: "リクエストスペックを書く",
          content: "TasksControllerをテストする",
          status: "in_progress",
          priority: "high",
          deadline: "2026-07-31"
        }

        expect do
          post tasks_path, params: { task: task_params }
        end.to change(user.tasks, :count).by(1)

        expect(response).to redirect_to(tasks_path)
        expect(user.tasks.last.title).to eq "リクエストスペックを書く"
      end

      it "入力が不正な場合はタスクを作成しない" do
        expect do
          post tasks_path, params: { task: { title: "", content: "" } }
        end.not_to change(user.tasks, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    describe "GET /tasks/:id/edit" do
      it "編集画面を表示する" do
        task = create(:task, user: user)

        get edit_task_path(task)

        expect(response).to have_http_status(:ok)
      end
    end

    describe "PATCH /tasks/:id" do
      it "タスクを更新する" do
        task = create(:task, user: user)

        patch task_path(task), params: { task: { title: "更新後のタイトル" } }

        expect(response).to redirect_to(tasks_path)
        expect(task.reload.title).to eq "更新後のタイトル"
      end

      it "入力が不正な場合はタスクを更新しない" do
        task = create(:task, user: user)

        patch task_path(task), params: { task: { title: "" } }

        expect(response).to have_http_status(:unprocessable_content)
        expect(task.reload.title).to eq "RSpecの勉強"
      end
    end

    describe "DELETE /tasks/:id" do
      it "タスクを削除する" do
        task = create(:task, user: user)

        expect do
          delete task_path(task)
        end.to change(user.tasks, :count).by(-1)

        expect(response).to redirect_to(tasks_path)
      end
    end
  end
end
