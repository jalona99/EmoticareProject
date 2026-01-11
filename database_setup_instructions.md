# How to Run the Database Schema Script

Since `psql` is not in your system path, you can run the script using **pgAdmin** (which usually comes with PostgreSQL) or by locating the `psql` executable.

## Option 1: Using pgAdmin (Recommended)

### Step 1: Initialize Database and User
1.  Open **pgAdmin** and connect to your server (usually connects as `postgres` superuser).
2.  Right-click on the server (e.g., "PostgreSQL 15") and select **Query Tool**.
3.  Open the initialization file: `f:\Documents\GitHub\EmoticareProject\src\main\resources\init_db.sql`
4.  Click **Execute** (Play icon).
    *   *Note: If it says "database already exists", you can ignore that error.*

### Step 2: Create Tables
1.  In the browser tree on the left, right-click on the newly created **`emoticare_db`** (you might need to right-click server -> Refresh to see it).
2.  Select **Query Tool** (ensure you are querying `emoticare_db`, not `postgres`).
3.  Open the schema file: `f:\Documents\GitHub\EmoticareProject\src\main\resources\schema.sql`
4.  Click **Execute** (Play icon).
5.  Check "Messages" to ensure tables like `modules`, `quizzes`, etc. were created.

## Option 2: Command Line (Alternative)
If you have `psql` in your path:
```powershell
# 1. Init DB
psql -U postgres -f "f:\Documents\GitHub\EmoticareProject\src\main\resources\init_db.sql"
# 2. Create Schema
psql -U emoticare_user -d emoticare_db -f "f:\Documents\GitHub\EmoticareProject\src\main\resources\schema.sql"
```

## Notes
- **Database Name**: `emoticare_db`
- **User**: `emoticare_user`
- **Password**: `SecurePassword123!`
