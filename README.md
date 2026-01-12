# CommunityConnect

A Rails 8.1 community management application for organizing groups and events. Built with modern Rails conventions including Hotwire (Turbo + Stimulus), Tailwind CSS, and PostgreSQL.

## Demo Accounts

For reviewers and testers, the application includes pre-seeded demo accounts and data:

### Demo User Credentials

**Primary Demo Account:**
- Email: `demo@demo.com`
- Password: `123456`

**Secondary Demo Account:**
- Email: `other@user.com`
- Password: `123456`

### Pre-seeded Demo Data

The seed file includes ready-to-explore content:

**5 Demo Groups:**
- Tech Enthusiasts - Technology community for developers and innovators
- Book Club - Monthly literary discussions
- Fitness Warriors - Group workouts and wellness activities
- Photography Collective - Photo walks and workshops
- Board Game Night - Weekly gaming sessions

**Multiple Events per Group:**
- Mix of public and private events
- Events scheduled at various upcoming dates
- Diverse event types for each group theme

Run `bin/rails db:seed` to populate your database with this demo data.

## Quick Start

### Prerequisites

- Ruby 3.4.7 (see `.ruby-version`)
- PostgreSQL
- Node.js (for JavaScript dependencies)

### Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   bin/setup
   ```
3. Set up environment variables:
   ```bash
   cp .env.example .env
   ```
4. Prepare the database:
   ```bash
   bin/rails db:prepare
   bin/rails db:seed
   ```
5. Start the development server:
   ```bash
   bin/dev
   ```
6. Visit http://localhost:3000 and log in with the demo credentials above

## Key Technologies

- **Framework**: Rails 8.1.1
- **Database**: SQLite
- **Authentication**: Devise
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS
- **UI Components**: ViewComponent
- **Testing**: RSpec with FactoryBot, Shoulda Matchers
- **Deployment**: Fly.io

## Development

### Running the Application

```bash
bin/dev                    # Start Rails server and Tailwind watcher
bin/rails server           # Rails server only
bin/rails tailwindcss:watch # Tailwind watcher only
```

### Testing

```bash
bundle exec rspec                     # Run all tests
bundle exec rspec spec/models         # Run model tests
bundle exec rspec --format documentation # Detailed output
```

### Code Quality

```bash
bin/rubocop              # Run linter
bin/rubocop -a           # Auto-correct issues
bin/ci                   # Run full CI suite
```

### Database

```bash
bin/rails db:migrate     # Run migrations
bin/rails db:seed        # Load demo data
bin/rails console        # Rails console
```

## Configuration

### Environment Variables

```bash
# Copy the sample environment file
cp .env.sample .env
```

## Deployment

Configured for Fly.io deployment:

```bash
fly launch              # Initial setup
fly deploy              # Deploy application
fly secrets set KEY=value # Set environment variables
```