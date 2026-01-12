# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Load FactoryBot for seeds
require "factory_bot_rails"

# Clear existing data (optional - comment out if you want to preserve data)
puts "Clearing existing data..."
Event.destroy_all
Group.destroy_all
User.destroy_all

# Create demo user
puts "Creating demo user..."
demo_user = FactoryBot.create(:user,
  email: "demo@demo.com",
  password: "123456",
  password_confirmation: "123456"
)
puts "✓ Created user: #{demo_user.email}"

# Define groups with specific data
puts "\nCreating groups..."
groups_data = [
  {
    name: "Tech Enthusiasts",
    description: "A community for technology lovers, developers, and innovators to share ideas and collaborate on projects."
  },
  {
    name: "Book Club",
    description: "Monthly meetings to discuss classic and contemporary literature. All reading levels welcome!"
  },
  {
    name: "Fitness Warriors",
    description: "Get fit together! Join us for group workouts, running clubs, and healthy lifestyle discussions."
  },
  {
    name: "Photography Collective",
    description: "Capture the world through your lens. Share your work, learn new techniques, and join photo walks."
  },
  {
    name: "Board Game Night",
    description: "Weekly gatherings for board game enthusiasts. From strategy games to party games, we play them all!"
  }
]

created_groups = groups_data.map do |group_attrs|
  group = FactoryBot.create(:group, group_attrs)
  puts "✓ Created group: #{group.name}"
  group
end

# Define events data for each group
events_config = {
  "Tech Enthusiasts" => [
    { title: "Introduction to Ruby on Rails", description: "Learn the basics of Rails web development", starts_at: 2.days.from_now, public: true },
    { title: "AI and Machine Learning Workshop", description: "Hands-on workshop exploring AI concepts", starts_at: 5.days.from_now, public: true },
    { title: "Code Review Session", description: "Members-only code review and mentoring", starts_at: 8.days.from_now, public: false },
    { title: "Hackathon Planning Meeting", description: "Planning our annual hackathon event", starts_at: 11.days.from_now, public: true },
    { title: "Private Tech Talk: Security Best Practices", description: "Advanced security discussion for members", starts_at: 14.days.from_now, public: false }
  ],
  "Book Club" => [
    { title: "Discussion: 1984 by George Orwell", description: "Deep dive into dystopian literature", starts_at: 3.days.from_now, public: true },
    { title: "Author Meet & Greet", description: "Special guest appearance by local author", starts_at: 6.days.from_now, public: true },
    { title: "Member's Choice Meeting", description: "Members vote on next book selection", starts_at: 9.days.from_now, public: false },
    { title: "Annual Book Swap", description: "Members-only book exchange event", starts_at: 15.days.from_now, public: false }
  ],
  "Fitness Warriors" => [
    { title: "5K Community Run", description: "Morning run through the park", starts_at: 4.days.from_now, public: true },
    { title: "Yoga in the Park", description: "Outdoor yoga session for all levels", starts_at: 7.days.from_now, public: true },
    { title: "Nutrition and Wellness Seminar", description: "Learn about healthy eating habits", starts_at: 13.days.from_now, public: true },
    { title: "Personal Training Consultations", description: "One-on-one sessions for members", starts_at: 16.days.from_now, public: false }
  ],
  "Photography Collective" => [
    { title: "Sunset Photo Walk", description: "Capture golden hour at the waterfront", starts_at: 1.week.from_now, public: true },
    { title: "Portrait Photography Workshop", description: "Learn lighting and composition techniques", starts_at: 10.days.from_now, public: true },
    { title: "Advanced Post-Processing Session", description: "Lightroom and Photoshop techniques", starts_at: 20.days.from_now, public: false }
  ],
  "Board Game Night" => [
    { title: "Intro to Strategy Games", description: "Learn Catan, Ticket to Ride, and more", starts_at: 1.day.from_now, public: true },
    { title: "Member's Tournament Finals", description: "Championship round for regular members", starts_at: 1.week.from_now, public: false },
    { title: "New Games Night", description: "Try out the latest board game releases", starts_at: 10.days.from_now, public: true },
    { title: "Private Game Testing Session", description: "Help us review upcoming game purchases", starts_at: 2.weeks.from_now, public: false }
  ]
}

# Create events for each group
puts "\nCreating events..."
created_groups.each do |group|
  puts "\n  Events for #{group.name}:"

  events_config[group.name].each do |event_attrs|
    # Create event using factory with specific attributes
    event = FactoryBot.create(:event,
      group: group,
      creator: demo_user,
      title: event_attrs[:title],
      description: event_attrs[:description],
      starts_at: event_attrs[:starts_at],
      public: event_attrs[:public]
    )

    puts "    ✓ #{event.title} - #{event.starts_at.strftime('%b %d, %Y at %I:%M %p')}"
  end

  puts "\nCreating events for other users..."
  FactoryBot.create_list(:event, 2, group: group, creator: FactoryBot.create(:user))
end


puts "Seed data created successfully!"
puts "Demo User:"
puts "  Email: #{demo_user.email}"
puts "  Password: 123456"
puts "\nGroups created: #{Group.count}"
puts "Events created: #{Event.count}"
