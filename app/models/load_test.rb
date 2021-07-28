# frozen_string_literal: true

class LoadTest < ApplicationRecord
  include Notification

  has_one_attached :jmx_script
  has_one_attached :csv
  has_one_attached :artifact

  validates :jmx_id, :squad, :threshold, presence: true
  validates :csv, attached: { message: "The file you choose need CSV" },
    file: { ext: ".csv", message: "The file extension need to be .csv" },
    if: :csv_needed?
  validate :csv_matched?, :csv_rows_less?
  before_save :insert_name, :insert_params, :capitalize_squad, :attach_jmx_script

  self.per_page = 10

  def insert_name
    self.jmx_name = Jmx.find(self.jmx_id).name
  end

  def capitalize_squad
    self.squad.upcase!
  end

  def csv_needed?
    Jmx.find(self.jmx_id).script.download.include? "CSV" if self.jmx_id?
  end

  def csv_matched?
    csv = self.csv
    return unless csv_needed? && csv.attached?
    errors[:csv] << "CSV file not matched" unless csv.download.split.first.split(/;|,/).size == Jmx.find(self.jmx_id).script.download.match(/variableNames\">(.+)</)[1].split(",").size
  end

  def csv_rows_less?
    csv = self.csv
    return unless csv_needed? && csv.attached?
    raw_csv_size = self.csv.download.split(/\r\n|\n/).size
    csv_on_jmx = Jmx.find(self.jmx_id).script.download.match(/variableNames\">(.+)</)[1].split(",")
    uploading_csv = self.csv.download.split.first.split(/;|,/)
    if csv_on_jmx == uploading_csv
      @csv_rows = raw_csv_size-1
    else
      @csv_rows = raw_csv_size
    end
    @csv_rows
    errors[:csv] << "CSV: Minimum Rows are 10" if @csv_rows < 10
  end

  def insert_params
    self.threads = 10
    self.ramp = 1
    self.duration = 60
    self.timeouts = 10000
  end

  def attach_jmx_script
    self.jmx_script.attach(io: StringIO.new(Jmx.find(self.jmx_id).script.download), filename: self.jmx_name)
  end

  def notif_error
    notif_load_test_error(self.telegram_id)
  end
end
