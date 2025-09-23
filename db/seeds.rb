# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data
User.destroy_all
Vendor.destroy_all
Service.destroy_all

puts "Cleared existing data"

# Create admin user
admin_user = User.create!(
  name: "Admin User",
  email: "admin@vendor-management.com",
  password: "password123",
  password_confirmation: "password123"
)

puts "Created admin user: #{admin_user.email}"

# Predefined service names to avoid uniqueness conflicts
service_names = [
  "Web Development", "Mobile App Development", "Cloud Hosting", "Database Management",
  "Security Services", "IT Support", "Network Infrastructure", "Software Maintenance",
  "Data Analytics", "Digital Marketing", "Content Management", "API Integration",
  "Backup Services", "Monitoring Services", "Consulting", "Training Services",
  "Hardware Maintenance", "Software Licensing", "Email Services", "Storage Solutions",
  "DevOps Services", "UI/UX Design", "Quality Assurance", "Project Management",
  "System Administration", "Network Security", "Cloud Migration", "Performance Optimization",
  "Code Review", "Technical Documentation", "User Training", "System Integration",
  "Disaster Recovery", "Load Balancing", "SSL Certificates", "Domain Management",
  "Email Marketing", "Social Media Management", "SEO Services", "Content Writing",
  "Graphic Design", "Video Production", "Photography", "Branding Services",
  "Legal Consulting", "Financial Consulting", "HR Services", "Office Supplies",
  "Equipment Rental", "Cleaning Services"
]

# Company name prefixes and suffixes for variety
company_prefixes = ["Tech", "Digital", "Cloud", "Data", "Smart", "Pro", "Elite", "Prime", "Global", "Advanced"]
company_suffixes = ["Solutions", "Systems", "Technologies", "Services", "Corp", "Ltd", "Inc", "Group", "Partners", "Works"]

# Create 50 vendors
vendors = []
50.times do |i|
  prefix = company_prefixes.sample
  suffix = company_suffixes.sample
  company_name = "#{prefix} #{suffix}"

  # Ensure unique company names
  counter = 1
  while Vendor.exists?(name: company_name)
    company_name = "#{prefix} #{suffix} #{counter}"
    counter += 1
  end

  vendor = Vendor.create!(
    name: company_name,
    spoc: "#{["John", "Jane", "Mike", "Sarah", "David", "Lisa", "Chris", "Amy", "Tom", "Emma"].sample} #{["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez"].sample}",
    email: "contact@#{company_name.downcase.gsub(/\s+/, "")}.com",
    phone: "#{rand(1000000000..9999999999)}",
    status: ["active", "inactive"].sample
  )

  vendors << vendor
  print "."
end

puts "\nCreated #{vendors.count} vendors"

# Create services for vendors (1-10 services per vendor, some with 0)
services_created = 0
vendors.each_with_index do |vendor, index|
  # 10% of vendors will have 0 services
  next if index < 5

  # Random number of services (1-10)
  service_count = rand(1..10)

  # Shuffle service names to get unique services for this vendor
  available_services = service_names.shuffle

  service_count.times do |service_index|
    # Use different service names to avoid duplicates per vendor
    service_name = available_services[service_index] || "Custom Service #{service_index + 1}"

    start_date = rand(1.year.ago..6.months.from_now)
    expiry_date = start_date + rand(30.days..2.years)
    payment_due_date = start_date + rand(0.days..30.days)

    Service.create!(
      vendor: vendor,
      name: service_name,
      start_date: start_date,
      expiry_date: expiry_date,
      payment_due_date: payment_due_date,
      amount: rand(100.0..50000.0).round(2)
    )

    services_created += 1
  end

  print "."
end

puts "\nCreated #{services_created} services"

# Summary statistics
active_vendors = Vendor.active.count
inactive_vendors = Vendor.inactive.count
vendors_with_services = Vendor.joins(:services).distinct.count
vendors_without_services = Vendor.left_joins(:services).where(services: { id: nil }).count

puts "\nSeed Data Summary:"
puts "   Total Users: #{User.count}"
puts "   Total Vendors: #{Vendor.count}"
puts "   Active Vendors: #{active_vendors}"
puts "   Inactive Vendors: #{inactive_vendors}"
puts "   Vendors with Services: #{vendors_with_services}"
puts "   Vendors without Services: #{vendors_without_services}"
puts "   Total Services: #{Service.count}"
puts "   Average Services per Vendor: #{(Service.count.to_f / vendors_with_services).round(2)}"

puts "\nSeed data creation completed!"
