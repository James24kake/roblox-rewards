# Roblox Rewards Backend

A Node.js backend service for the Roblox Rewards platform, handling user authentication, rewards management, and withdrawal requests.

## Features

- User Authentication (Register/Login)
- JWT-based Authorization
- Rate Limiting for Security
- MongoDB Database Integration
- Withdrawal Request Management
- CORS Support for Frontend Integration

## Prerequisites

- Node.js (v14 or higher)
- MongoDB Atlas Account
- npm or yarn package manager

## Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd roblox-rewards/backend
```

2. Install dependencies:
```bash
npm install
```

3. Create a `.env` file in the root directory with the following content:
```
NODE_ENV=development
PORT=5000
MONGODB_URI=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret
JWT_EXPIRE=30d
```

4. Update the MongoDB connection string in `.env` with your database credentials.

## Running the Application

Development mode:
```bash
npm run dev
```

Production mode:
```bash
npm start
```

## API Endpoints

### Authentication
- POST `/api/users/register` - Register a new user
- POST `/api/users/login` - Login user

### Withdrawals
- POST `/api/withdrawals/request` - Create withdrawal request
- GET `/api/withdrawals/history` - Get withdrawal history

## Security

- Rate limiting implemented for API endpoints
- JWT authentication for protected routes
- CORS configuration for frontend access
- Environment variables for sensitive data

## Deployment

1. Set up your production environment
2. Configure environment variables
3. Install dependencies: `npm install --production`
4. Start the server: `npm start`

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License. 