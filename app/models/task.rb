class Task < ApplicationRecord
  belongs_to :user

  # DBには整数で保存し、Rails上ではステータス名で扱う
  enum status: {
    not_started: 0,
    in_progress: 1,
    completed: 2
  }

  # DBには整数で保存し、Rails上では優先度名で扱う
  enum priority: {
    low: 0,
    medium: 1,
    high: 2
  }

  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 500 }
  validates :status, presence: true
  validates :priority, presence: true

  # 新規作成時の初期ステータスを未着手にする
  after_initialize :set_default_status, if: :new_record?
  # 新規作成時の初期優先度を中にする
  after_initialize :set_default_priority, if: :new_record?

  def status_label
    {
      "not_started" => "未着手",
      "in_progress" => "進行中",
      "completed" => "完了"
    }[status]
  end

  def status_badge_class
    {
      "not_started" => "text-bg-secondary",
      "in_progress" => "text-bg-primary",
      "completed" => "text-bg-success"
    }[status]
  end

  def priority_label
    {
      "low" => "低",
      "medium" => "中",
      "high" => "高"
    }[priority]
  end

  def priority_badge_class
    {
      "low" => "text-bg-secondary",
      "medium" => "text-bg-warning",
      "high" => "text-bg-danger"
    }[priority]
  end

  def self.status_options
    statuses.keys.map { |status| [new(status: status).status_label, status] }
  end

  def self.priority_options
    priorities.keys.map { |priority| [new(priority: priority).priority_label, priority] }
  end

  private

  def set_default_status
    self.status ||= :not_started
  end

  def set_default_priority
    self.priority ||= :medium
  end
end
