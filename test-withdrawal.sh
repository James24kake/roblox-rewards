#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Base URL
API_URL="http://localhost:5000/api"

echo "🚀 Starting Withdrawal System Test"
echo "================================"

# 1. Register test user
echo -e "\n${GREEN}1. Registering test user...${NC}"
USER_RESPONSE=$(curl -s -X POST "$API_URL/users/register" \
  -H "Content-Type: application/json" \
  -d '{
    "robloxName": "TestUser123",
    "password": "test123456",
    "securityQuestion": "What is your favorite color?",
    "securityAnswer": "blue"
  }')

# Extract token from response
TOKEN=$(echo $USER_RESPONSE | grep -o '"token":"[^"]*' | grep -o '[^"]*$')

if [ -z "$TOKEN" ]; then
  echo -e "${RED}❌ Failed to register user${NC}"
  exit 1
fi
echo -e "${GREEN}✓ User registered successfully${NC}"

# 2. Update user tasks to earn points
echo -e "\n${GREEN}2. Completing tasks to earn points...${NC}"
curl -s -X PUT "$API_URL/users/tasks" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "taskType": "follow",
    "completed": true
  }'

curl -s -X PUT "$API_URL/users/tasks" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "taskType": "group",
    "completed": true
  }'

echo -e "${GREEN}✓ Tasks completed${NC}"

# 3. Create withdrawal request
echo -e "\n${GREEN}3. Creating withdrawal request...${NC}"
WITHDRAWAL_RESPONSE=$(curl -s -X POST "$API_URL/withdrawals" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 10
  }')

WITHDRAWAL_ID=$(echo $WITHDRAWAL_RESPONSE | grep -o '"_id":"[^"]*' | grep -o '[^"]*$')

if [ -z "$WITHDRAWAL_ID" ]; then
  echo -e "${RED}❌ Failed to create withdrawal request${NC}"
  exit 1
fi
echo -e "${GREEN}✓ Withdrawal request created${NC}"

# 4. Register admin user (24k_Ake)
echo -e "\n${GREEN}4. Registering admin user...${NC}"
ADMIN_RESPONSE=$(curl -s -X POST "$API_URL/users/register" \
  -H "Content-Type: application/json" \
  -d '{
    "robloxName": "24k_Ake",
    "password": "admin123456",
    "securityQuestion": "What is your favorite game?",
    "securityAnswer": "Roblox"
  }')

ADMIN_TOKEN=$(echo $ADMIN_RESPONSE | grep -o '"token":"[^"]*' | grep -o '[^"]*$')

if [ -z "$ADMIN_TOKEN" ]; then
  echo -e "${RED}❌ Failed to register admin${NC}"
  exit 1
fi
echo -e "${GREEN}✓ Admin registered successfully${NC}"

# 5. View all withdrawals as admin
echo -e "\n${GREEN}5. Viewing all withdrawals as admin...${NC}"
WITHDRAWALS=$(curl -s -X GET "$API_URL/withdrawals/all" \
  -H "Authorization: Bearer $ADMIN_TOKEN")

echo -e "${GREEN}✓ Retrieved all withdrawals${NC}"
echo "$WITHDRAWALS" | json_pp

# 6. Approve withdrawal as admin
echo -e "\n${GREEN}6. Approving withdrawal request...${NC}"
APPROVE_RESPONSE=$(curl -s -X PUT "$API_URL/withdrawals/$WITHDRAWAL_ID/approve" \
  -H "Authorization: Bearer $ADMIN_TOKEN")

echo -e "${GREEN}✓ Withdrawal approved${NC}"
echo "$APPROVE_RESPONSE" | json_pp

# 7. Check final user balance
echo -e "\n${GREEN}7. Checking final user balance...${NC}"
BALANCE=$(curl -s -X GET "$API_URL/users/profile" \
  -H "Authorization: Bearer $TOKEN")

echo -e "${GREEN}✓ Test completed${NC}"
echo "$BALANCE" | json_pp 