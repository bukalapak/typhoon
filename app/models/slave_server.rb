# frozen_string_literal: true

class SlaveServer < ApplicationRecord
  validates :host, :username, :password, :port, :slave_type, :slave_status, presence: true
end
