# Vendor Management System

A Rails API application for managing vendor services and contracts with automated reminder notifications.

## Features

- **Vendor Management** - Create and manage vendor information
- **Service Tracking** - Track vendor services with expiry and payment due dates
- **JWT Authentication** - Secure API access with JSON Web Tokens
- **Automated Reminders** - Daily email notifications for expiring services
- **RESTful API** - JSON API with pagination and versioning
- **Email Notifications** - HTML email templates with color-coded urgency levels

## Setup Instructions

### Prerequisites

- Ruby 3.4.5
- Rails 8.0.3
- PostgreSQL
- Node.js (for asset compilation)

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd vendor-management
   ```

2. **Install dependencies:**
   ```bash
   bundle install
   ```

3. **Setup database:**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Install cron jobs (optional):**
   ```bash
   bundle exec whenever --update-crontab
   ```

### Running the Application

```bash
# Start the Rails server
rails server

# The API will be available at http://localhost:3000
```

## API Documentation

### Base URL
```
http://localhost:3000/api/v1
```

### Authentication

All protected endpoints require JWT authentication via the `Authorization` header:
```
Authorization: <your-jwt-token>
```

### API Endpoints Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/auth/register` | Register a new user | No |
| POST | `/api/v1/auth/login` | Login user | No |
| GET | `/api/v1/vendors` | List all vendors | Yes |
| GET | `/api/v1/vendors/:id` | Get single vendor | Yes |
| POST | `/api/v1/vendors` | Create new vendor | Yes |
| PATCH | `/api/v1/vendors/:id` | Update vendor | Yes |
| DELETE | `/api/v1/vendors/:id` | Delete vendor | Yes |
| GET | `/api/v1/services/expiring_services` | Get expiring services | Yes |
| GET | `/api/v1/services/upcoming_payments` | Get upcoming payments | Yes |
| PATCH | `/api/v1/services/:id/update_status` | Update service status | Yes |
| GET | `/up` | Health check | No |

### Health Check

The application provides a health check endpoint for monitoring:

```http
GET /up
```

**Response:**
```
HTTP 200 OK
```

### Endpoints

#### 1. User Registration
```http
POST /api/v1/auth/register
Content-Type: application/json

{
  "user": {
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }
}
```

**Response:**
```json
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "name": "John Doe",
      "email": "john@example.com",
      "created_at": "2024-01-01T00:00:00.000Z",
      "updated_at": "2024-01-01T00:00:00.000Z"
    }
  },
  "meta": {
    "token": "eyJhbGciOiJIUzI1NiJ9..."
  }
}
```

#### 2. User Login
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "user": {
    "email": "john@example.com",
    "password": "password123"
  }
}
```

**Response:**
```json
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "name": "John Doe",
      "email": "john@example.com",
      "created_at": "2024-01-01T00:00:00.000Z",
      "updated_at": "2024-01-01T00:00:00.000Z"
    }
  },
  "meta": {
    "token": "eyJhbGciOiJIUzI1NiJ9..."
  }
}
```

#### 3. Get Vendors (Protected)
```http
GET /api/v1/vendors?page=1&per_page=10
Authorization: Bearer <token>
```

**Response:**
```json
{
  "data": [
    {
      "id": "1",
      "type": "vendor",
      "attributes": {
        "name": "Tech Solutions",
        "spoc": "John Smith",
        "email": "contact@techsolutions.com",
        "phone": "9876543210",
        "status": "active",
        "created_at": "2024-01-01T00:00:00.000Z",
        "updated_at": "2024-01-01T00:00:00.000Z"
      },
      "relationships": {
        "services": {
          "data": [
            {
              "id": "1",
              "type": "service"
            }
          ]
        }
      }
    }
  ],
  "included": [
    {
      "id": "1",
      "type": "service",
      "attributes": {
        "name": "Web Development",
        "start_date": "2024-01-01",
        "expiry_date": "2024-12-31",
        "payment_due_date": "2024-01-15",
        "amount": "5000.00",
        "vendor_id": 1,
        "vendor_name": "Tech Solutions",
        "is_active": true,
        "is_payment_due": false,
        "urgency_level": "normal",
        "color_code": "#6c757d",
        "days_until_expiry": 365,
        "days_until_payment_due": 14
      }
    }
  ],
  "meta": {
    "pagination": {
      "current_page": 1,
      "next_page": 2,
      "prev_page": null,
      "total_pages": 5,
      "total_count": 50,
      "per_page": 10
    }
  }
}
```

#### 4. Get Single Vendor (Protected)
```http
GET /api/v1/vendors/1
Authorization: Bearer <token>
```

**Response:**
```json
{
  "data": {
    "id": "1",
    "type": "vendor",
    "attributes": {
      "name": "Tech Solutions",
      "spoc": "John Smith",
      "email": "contact@techsolutions.com",
      "phone": "9876543210",
      "status": "active",
      "created_at": "2024-01-01T00:00:00.000Z",
      "updated_at": "2024-01-01T00:00:00.000Z"
    },
    "relationships": {
      "services": {
        "data": [
          {
            "id": "1",
            "type": "service"
          }
        ]
      }
    }
  },
  "included": [
    {
      "id": "1",
      "type": "service",
      "attributes": {
        "name": "Web Development",
        "start_date": "2024-01-01",
        "expiry_date": "2024-12-31",
        "payment_due_date": "2024-01-15",
        "amount": "5000.00",
        "status": "active",
        "vendor_id": 1,
        "vendor_name": "Tech Solutions",
        "is_active": true,
        "is_payment_due": false,
        "urgency_level": "normal",
        "color_code": "#6c757d",
        "days_until_expiry": 365,
        "days_until_payment_due": 14
      }
    }
  ]
}
```

#### 5. Create Vendor (Protected)
```http
POST /api/v1/vendors
Authorization: Bearer <token>
Content-Type: application/json

{
  "vendor": {
    "name": "New Tech Corp",
    "spoc": "Jane Doe",
    "email": "jane@newtech.com",
    "phone": "9876543210",
    "status": "active",
    "services_attributes": [
      {
        "name": "Mobile App Development",
        "start_date": "2024-02-01",
        "expiry_date": "2024-12-31",
        "payment_due_date": "2024-02-15",
        "amount": "8000.00"
      }
    ]
  }
}
```

**Response:**
```json
{
  "data": {
    "id": "2",
    "type": "vendor",
    "attributes": {
      "name": "New Tech Corp",
      "spoc": "Jane Doe",
      "email": "jane@newtech.com",
      "phone": "9876543210",
      "status": "active",
      "created_at": "2024-01-01T00:00:00.000Z",
      "updated_at": "2024-01-01T00:00:00.000Z"
    },
    "relationships": {
      "services": {
        "data": [
          {
            "id": "2",
            "type": "service"
          }
        ]
      }
    }
  },
  "included": [
    {
      "id": "2",
      "type": "service",
      "attributes": {
        "name": "Mobile App Development",
        "start_date": "2024-02-01",
        "expiry_date": "2024-12-31",
        "payment_due_date": "2024-02-15",
        "amount": "8000.00",
        "status": "active",
        "vendor_id": 2,
        "vendor_name": "New Tech Corp",
        "is_active": true,
        "is_payment_due": false,
        "urgency_level": "normal",
        "color_code": "#6c757d",
        "days_until_expiry": 365,
        "days_until_payment_due": 14
      }
    }
  ]
}
```

#### 6. Update Vendor (Protected)
```http
PATCH /api/v1/vendors/1
Authorization: Bearer <token>
Content-Type: application/json

{
  "vendor": {
    "name": "Updated Tech Solutions",
    "spoc": "Updated John Smith",
    "email": "updated@techsolutions.com",
    "phone": "9876543210",
    "status": "active"
  }
}
```

**Response:**
```json
{
  "data": {
    "id": "1",
    "type": "vendor",
    "attributes": {
      "name": "Updated Tech Solutions",
      "spoc": "Updated John Smith",
      "email": "updated@techsolutions.com",
      "phone": "9876543210",
      "status": "active",
      "created_at": "2024-01-01T00:00:00.000Z",
      "updated_at": "2024-01-01T12:00:00.000Z"
    },
    "relationships": {
      "services": {
        "data": []
      }
    }
  }
}
```

#### 7. Delete Vendor (Protected)
```http
DELETE /api/v1/vendors/1
Authorization: Bearer <token>
```

**Response:**
```
HTTP 204 No Content
```

#### 8. Get Expiring Services (Protected)
```http
GET /api/v1/services/expiring_services?page=1&per_page=10
Authorization: Bearer <token>
```

**Response:**
```json
{
  "data": [
    {
      "id": "1",
      "type": "service",
      "attributes": {
        "name": "Web Development",
        "start_date": "2024-01-01",
        "expiry_date": "2024-01-15",
        "payment_due_date": "2024-01-10",
        "amount": "5000.00",
        "status": "active",
        "vendor_id": 1,
        "vendor_name": "Tech Solutions",
        "is_active": true,
        "is_payment_due": true,
        "urgency_level": "urgent",
        "color_code": "#dc3545",
        "days_until_expiry": 3,
        "days_until_payment_due": -2
      }
    }
  ],
  "meta": {
    "pagination": {
      "current_page": 1,
      "next_page": null,
      "prev_page": null,
      "total_pages": 1,
      "total_count": 1,
      "per_page": 10
    }
  }
}
```

#### 9. Get Upcoming Payments (Protected)
```http
GET /api/v1/services/upcoming_payments?page=1&per_page=10
Authorization: Bearer <token>
```

**Response:**
```json
{
  "data": [
    {
      "id": "2",
      "type": "service",
      "attributes": {
        "name": "Mobile App Development",
        "start_date": "2024-01-01",
        "expiry_date": "2024-12-31",
        "payment_due_date": "2024-01-20",
        "amount": "8000.00",
        "status": "active",
        "vendor_id": 2,
        "vendor_name": "New Tech Corp",
        "is_active": true,
        "is_payment_due": false,
        "urgency_level": "warning",
        "color_code": "#ffc107",
        "days_until_expiry": 365,
        "days_until_payment_due": 5
      }
    }
  ],
  "meta": {
    "pagination": {
      "current_page": 1,
      "next_page": null,
      "prev_page": null,
      "total_pages": 1,
      "total_count": 1,
      "per_page": 10
    }
  }
}
```

#### 10. Update Service Status (Protected)
```http
PATCH /api/v1/services/1/update_status
Authorization: Bearer <token>
Content-Type: application/json

{
  "service": {
    "status": "completed"
  }
}
```

**Response:**
```json
{
  "data": {
    "id": "1",
    "type": "service",
    "attributes": {
      "name": "Web Development",
      "start_date": "2024-01-01",
      "expiry_date": "2024-12-31",
      "payment_due_date": "2024-01-15",
      "amount": "5000.00",
      "status": "completed",
      "vendor_id": 1,
      "vendor_name": "Tech Solutions",
      "is_active": false,
      "is_payment_due": false,
      "urgency_level": "normal",
      "color_code": "#6c757d",
      "days_until_expiry": 365,
      "days_until_payment_due": 14
    }
  }
}
```

### Error Responses

All endpoints return consistent error responses following the JSON API specification:

#### 400 Bad Request
```json
{
  "errors": [
    {
      "status": "400",
      "title": "Bad Request",
      "detail": "Invalid request parameters"
    }
  ]
}
```

#### 401 Unauthorized
```json
{
  "errors": [
    {
      "status": "401",
      "title": "Unauthorized",
      "detail": "Invalid token"
    }
  ]
}
```

#### 404 Not Found
```json
{
  "errors": [
    {
      "status": "404",
      "title": "Error",
      "detail": "Vendor not found"
    }
  ]
}
```

#### 422 Unprocessable Entity (Validation Errors)
```json
{
  "errors": [
    {
      "status": "422",
      "title": "Validation Error",
      "detail": "Name can't be blank",
      "source": {
        "pointer": "/data/attributes/name"
      }
    },
    {
      "status": "422",
      "title": "Validation Error",
      "detail": "Email is invalid",
      "source": {
        "pointer": "/data/attributes/email"
      }
    }
  ]
}
```

#### 500 Internal Server Error
```json
{
  "errors": [
    {
      "status": "500",
      "title": "Error",
      "detail": "Something went wrong"
    }
  ]
}
```

### Query Parameters

#### Pagination
All list endpoints support pagination:
- `page` - Page number (default: 1)
- `per_page` - Items per page (default: 25, max: 100)

#### Vendor List Filters
- `active_services` - Filter services by status (true/false)

### Service Status Values

Services can have the following status values:
- `active` - Service is currently active
- `expired` - Service has expired
- `payment_pending` - Payment is due
- `completed` - Service is completed

### Vendor Status Values

Vendors can have the following status values:
- `active` - Vendor is active
- `inactive` - Vendor is inactive

## Design Choices

### Database Schema

#### Vendors Table
```sql
CREATE TABLE vendors (
  id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  spoc VARCHAR NOT NULL,
  email VARCHAR NOT NULL UNIQUE,
  phone VARCHAR NOT NULL,
  status VARCHAR NOT NULL DEFAULT 'active',
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Indexes
CREATE INDEX index_vendors_on_email ON vendors(email);
CREATE INDEX index_vendors_on_status ON vendors(status);
```

#### Services Table
```sql
CREATE TABLE services (
  id SERIAL PRIMARY KEY,
  vendor_id INTEGER NOT NULL REFERENCES vendors(id),
  name VARCHAR NOT NULL,
  start_date DATE NOT NULL,
  expiry_date DATE NOT NULL,
  payment_due_date DATE NOT NULL,
  amount DECIMAL(10,2),
  status VARCHAR NOT NULL DEFAULT 'active',
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Indexes
CREATE INDEX index_services_on_vendor_id ON services(vendor_id);
CREATE INDEX index_services_on_expiry_date ON services(expiry_date);
CREATE INDEX index_services_on_payment_due_date ON services(payment_due_date);
CREATE INDEX index_services_on_status ON services(status);
CREATE INDEX index_services_on_vendor_name ON services(vendor_id, name);
```

#### Users Table
```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  email VARCHAR NOT NULL UNIQUE,
  password_digest VARCHAR NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Indexes
CREATE INDEX index_users_on_email ON users(email);
```

### Libraries and Gems

#### Core Gems
- **Rails 8.0.3** - Web framework
- **PostgreSQL** - Database
- **Puma** - Web server

#### API Gems
- **jsonapi-serializer** - JSON API specification compliance
- **kaminari** - Pagination
- **rack-cors** - Cross-origin resource sharing

#### Authentication
- **jwt** - JSON Web Token implementation
- **bcrypt** - Password hashing

#### Email & Scheduling
- **letter_opener** - Email preview in development
- **whenever** - Cron job management

### Assumptions

1. **Vendor Management**
   - Each vendor has a single point of contact (SPOC)
   - Phone numbers are exactly 10 digits
   - Email addresses are unique per vendor
   - Status can only be 'active' or 'inactive'

2. **Service Tracking**
   - Services belong to exactly one vendor
   - Service names must be unique per vendor
   - Expiry date must be after start date
   - Payment due date must be after start date
   - Amount is optional (can be null)

3. **Authentication**
   - JWT tokens expire after 24 hours
   - All API endpoints except auth require authentication
   - Passwords must be at least 6 characters

4. **Email Notifications**
   - Reminders are sent for services expiring within 15 days
   - Urgency levels: urgent (≤3 days), warning (≤7 days), info (≤15 days)
   - Color coding: red (urgent), yellow (warning), blue (info), gray (normal)

5. **API Design**
   - Follows JSON API specification
   - All responses include proper error handling
   - Pagination is available on list endpoints
   - Versioned API (v1)

### Cron Job Configuration

The application uses the `whenever` gem for cron job management:

```ruby
# config/schedule.rb
every 1.day, at: "9:00 am" do
  rake "reminders:expiring_and_due_services"
end
```

This runs the daily reminder check at 9:00 AM IST, automatically handling timezone conversion.

## Development

### Running Tests
```bash
# Run the test suite
rails test

# Run with coverage
COVERAGE=true rails test
```

### Code Quality
```bash
# Run RuboCop
bundle exec rubocop

# Run Brakeman (security)
bundle exec brakeman
```

### Database Management
```bash
# Reset database
rails db:drop db:create db:migrate db:seed

# Create migration
rails generate migration CreateTableName

# Run migrations
rails db:migrate

# Rollback migration
rails db:rollback
```

## License

This project is licensed under the MIT License.