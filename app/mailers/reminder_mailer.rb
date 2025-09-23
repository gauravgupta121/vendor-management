class ReminderMailer < ApplicationMailer
  def daily_reminder_summary(expiring_services, payment_due_services, recipient_email)
    @expiring_services = expiring_services
    @payment_due_services = payment_due_services
    mail(to: recipient_email, subject: "Daily Vendor Service Reminders")
  end

  private

  def urgency_level(date)
    days_left = (date - Date.current).to_i
    if days_left <= 3
      "urgent"
    elsif days_left <= 7
      "warning"
    elsif days_left <= 15
      "info"
    else
      "normal"
    end
  end

  helper_method :urgency_level
end
