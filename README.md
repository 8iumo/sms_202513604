[README.md](https://github.com/user-attachments/files/34468109/README.md)
# Soldier Management System (SMS) - PostgreSQL Database

A relational database project developed for the Soldier Management SQL Quiz at Kigali Independent University (ULK).

---

## 📋 Project Information

* **Course:** Database Management Systems
* **Institution:** Kigali Independent University (ULK)
* **Instructor:** Eric Maniraguha
* **Database System:** PostgreSQL

### 👥 Group Members & Student Numbers
* **Student 1:** `202513604` (Primary)
* **Student 2:** `202512587`
* **Student 3:** `202512664`

---

## ⚙️ Calculated Personal Variables

Based on the primary student number (`202513604`), the specific exam variables are calculated as follows:

| Variable | Formula / Logic | Calculated Value |
| :--- | :--- | :---: |
| **P** | Last digit of student number (`4`) | **`4`** |
| **U** | Remainder of ($04 \div 6$) $+ 1$ | **`5`** |
| **M** | Remainder of ($4 \div 5$) $+ 1$ | **`5`** |

---

## 🗂️ Database Schema Overview

The database consists of five tables enforcing relational integrity, custom constraints, and foreign key relationships:

1. **`ranks`**: Stores military rank levels ($1$ to $6$).
2. **`units`**: Stores military unit names and locations.
3. **`missions`**: Tracks ongoing and completed deployments.
4. **`soldiers`**: Contains soldier profiles, enlistment dates, service numbers, and assigned ranks/units.
5. **`soldier_missions`**: Junction table mapping soldiers to specific mission roles.

---

## 🚀 Setup & Execution Instructions

1. **Connect to PostgreSQL:**
   ```bash
   psql -U postgres
   ```

2. **Create & Connect to Database:**
   ```sql
   CREATE DATABASE sms_202513604;
   \c sms_202513604
   ```

3. **Run the Script:**
   ```sql
   \i sms_202513604.sql
   ```

---

## 📊 File Structure

* `sms_202513604.sql` - Main SQL file containing table creation, data seed, queries (C1–C10), indexing, and view creation.
* `README.md` - Documentation file.
