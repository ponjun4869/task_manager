class Task < ApplicationRecord
  belongs_to :user

  # DBには整数で保存し、Rails上ではステータス名で扱う
  enum status: {
    not_started: 0,
    in_progress: 1,
    completed: 2
  }

  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 500 }
  validates :status, presence: true

  # 新規作成時の初期ステータスを未着手にする
  after_initialize :set_default_status, if: :new_record?

  def status_label
    {
      "not_started" => "未着手",
      "in_progress" => "進行中",
      "completed" => "完了"
    }[status]
  end

  def self.status_options
    statuses.keys.map { |status| [new(status: status).status_label, status] }
  end

  private

  def set_default_status
    self.status ||= :not_started
  end
end
