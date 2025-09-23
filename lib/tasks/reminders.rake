namespace :reminders do
  desc "Check and send daily reminder emails for expiring services and payment due dates"
  task daily: :environment do
    puts "Starting daily reminder check at #{Time.current}"

    begin
      # Get services expiring in next 15 days
      expiring_services = Service.includes(:vendor)
                                .where(expiry_date: Date.current..15.days.from_now)
                                .order(:expiry_date)

      # Get services with payments due in next 15 days
      payment_due_services = Service.includes(:vendor)
                                   .where(payment_due_date: Date.current..15.days.from_now)
                                   .order(:payment_due_date)

      # Send emails only if there are services that need attention
      if expiring_services.any? || payment_due_services.any?
        # Send to each vendor with their specific services
        send_vendor_reminders(expiring_services, payment_due_services)
      else
        puts "No services expiring or payments due in the next 15 days"
      end

      puts "Daily reminder check completed successfully at #{Time.current}"
    rescue StandardError => e
      puts "Error during daily reminder check: #{e.message}"
      puts e.backtrace.join("\n")
    end
  end

  private

  def send_vendor_reminders(expiring_services, payment_due_services)
    # Group by vendor
    vendor_services = {}

    expiring_services.each do |service|
      vendor_services[service.vendor] ||= { expiring: [], payment_due: [] }
      vendor_services[service.vendor][:expiring] << service
    end

    payment_due_services.each do |service|
      vendor_services[service.vendor] ||= { expiring: [], payment_due: [] }
      vendor_services[service.vendor][:payment_due] << service
    end

    # Send emails to each vendor
    vendor_services.each do |vendor, services|
      if services[:expiring].any? || services[:payment_due].any?
        ReminderMailer.daily_reminder_summary(
          services[:expiring],
          services[:payment_due],
          vendor.email
        ).deliver_now
        puts "Reminder email sent to vendor: #{vendor.name} (#{vendor.email})"
      end
    end
  end
end
