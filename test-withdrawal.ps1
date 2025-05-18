# Base URL
$apiUrl = "http://localhost:5000/api"

Write-Host "`n🚀 Starting Withdrawal System Test" -ForegroundColor Cyan
Write-Host "================================`n"

# 1. Register test user
Write-Host "1. Registering test user..." -ForegroundColor Green
$userBody = @{
    robloxName = "TestUser123"
    password = "test123456"
    securityQuestion = "What is your favorite color?"
    securityAnswer = "blue"
} | ConvertTo-Json

try {
    $userResponse = Invoke-RestMethod -Method Post -Uri "$apiUrl/users/register" -ContentType "application/json" -Body $userBody
    $token = $userResponse.token
    Write-Host "✓ User registered successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to register user: $_" -ForegroundColor Red
    exit
}

# 2. Complete tasks to earn points
Write-Host "`n2. Completing tasks to earn points..." -ForegroundColor Green
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

$taskBody = @{
    taskType = "follow"
    completed = $true
} | ConvertTo-Json

try {
    Invoke-RestMethod -Method Put -Uri "$apiUrl/users/tasks" -Headers $headers -Body $taskBody
    Write-Host "✓ Follow task completed" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to complete task: $_" -ForegroundColor Red
}

$taskBody = @{
    taskType = "group"
    completed = $true
} | ConvertTo-Json

try {
    Invoke-RestMethod -Method Put -Uri "$apiUrl/users/tasks" -Headers $headers -Body $taskBody
    Write-Host "✓ Group task completed" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to complete task: $_" -ForegroundColor Red
}

# 3. Create withdrawal request
Write-Host "`n3. Creating withdrawal request..." -ForegroundColor Green
$withdrawalBody = @{
    amount = 10
} | ConvertTo-Json

try {
    $withdrawalResponse = Invoke-RestMethod -Method Post -Uri "$apiUrl/withdrawals" -Headers $headers -Body $withdrawalBody
    $withdrawalId = $withdrawalResponse._id
    Write-Host "✓ Withdrawal request created" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to create withdrawal: $_" -ForegroundColor Red
    exit
}

# 4. Register admin user
Write-Host "`n4. Registering admin user..." -ForegroundColor Green
$adminBody = @{
    robloxName = "24k_Ake"
    password = "admin123456"
    securityQuestion = "What is your favorite game?"
    securityAnswer = "Roblox"
} | ConvertTo-Json

try {
    $adminResponse = Invoke-RestMethod -Method Post -Uri "$apiUrl/users/register" -ContentType "application/json" -Body $adminBody
    $adminToken = $adminResponse.token
    Write-Host "✓ Admin registered successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to register admin: $_" -ForegroundColor Red
    exit
}

# 5. View all withdrawals as admin
Write-Host "`n5. Viewing all withdrawals as admin..." -ForegroundColor Green
$adminHeaders = @{
    "Authorization" = "Bearer $adminToken"
    "Content-Type" = "application/json"
}

try {
    $withdrawals = Invoke-RestMethod -Method Get -Uri "$apiUrl/withdrawals/all" -Headers $adminHeaders
    Write-Host "✓ Retrieved all withdrawals" -ForegroundColor Green
    $withdrawals | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Failed to get withdrawals: $_" -ForegroundColor Red
}

# 6. Approve withdrawal as admin
Write-Host "`n6. Approving withdrawal request..." -ForegroundColor Green
try {
    $approveResponse = Invoke-RestMethod -Method Put -Uri "$apiUrl/withdrawals/$withdrawalId/approve" -Headers $adminHeaders
    Write-Host "✓ Withdrawal approved" -ForegroundColor Green
    $approveResponse | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Failed to approve withdrawal: $_" -ForegroundColor Red
}

# 7. Check final user balance
Write-Host "`n7. Checking final user balance..." -ForegroundColor Green
try {
    $balance = Invoke-RestMethod -Method Get -Uri "$apiUrl/users/profile" -Headers $headers
    Write-Host "✓ Test completed" -ForegroundColor Green
    $balance | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Failed to get balance: $_" -ForegroundColor Red
}

Write-Host "`n✨ Test sequence completed!" -ForegroundColor Cyan 