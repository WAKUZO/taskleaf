class Task < ApplicationRecord
  validates :name, presence: true, length: {maximum: 30}
  validate :validate_name_not_including_comma

  belongs_to :user
  has_one_attached :image

  # タスクを新しい順に並べる
  scope :recent, -> {order(created_at: :desc)}

  # ransackでnameとcreated_atのみしか検索できないようにする
  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # csv機能
  def self.csv_attributes
    ["name", "description", "created_at"]
  end

  # csv出力
  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |task|
        csv << csv_attributes.map{ |attr| task.send(attr)}
      end
    end
  end

  # csv入力
  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      task = new
      task.attributes = row.to_hash.slice(*csv_attributes)
      task.save!
    end
  end

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end
