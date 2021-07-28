# frozen_string_literal: true

module Notification
  extend ActiveSupport::Concern

  require "telegram/bot"

  def send_telegram_notification(message, chat_id)
    if Rails.env.production?
      Telegram::Bot::Client.run(MasterConfiguration.last.telegram_credential) do |bot|
        # Notification via Telegram bot
        bot.api.send_message(chat_id: chat_id, text: message) rescue $ERROR_INFO
      end
    else
      puts message
    end
  end

  # :reek:FeatureEnvy
  def notif_start(jmeter)
    message = "Hi folks, Typhoon is running. The script used is #{jmeter.jmx_name}, with the following config:"
    message += "\n\nLoads: #{jmeter.threads / jmeter.ramp} rps"
    message += "\nDuration: #{jmeter.duration} s"
    message += "\n\nPlease check all related metrics"
    send_telegram_notification(message, MasterConfiguration.last.telegram_perf_group_id) unless self.load_test?
  end

  def notif_stop
    message = "Oops, Typhoon is stopped. The running script would be halt"
    send_telegram_notification(message, MasterConfiguration.last.telegram_perf_group_id)
  end

  def notif_finish(jmeter)
    message = "Yay, the running script #{jmeter.jmx_name} has finished, "
    message += "don't forget to share the reports here, Thank you"
    send_telegram_notification(message, MasterConfiguration.last.telegram_perf_group_id) unless self.load_test?
  end

  def notif_load_test_error(telegram_id)
    message = "Your load test result is error with the following detail:"
    message += "\nScript: #{self.jmx_name}"
    message += "\nPlease check the detail on Typhoon Load Test"
    send_telegram_notification(message, telegram_id)
  end
end
