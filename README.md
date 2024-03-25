# periodic_table

1. Delete old gitpod repo
2. Open new gitpod from freecodecamp
3. Create a copy of the sql file.
4. Drop old db `psql -U postgres -c "DROP DATABASE IF EXISTS periodic_table;"`
5. Create new db `psql -U postgres -c "CREATE DATABASE periodic_table;"`
6. Populate new db `psql -U postgres -d periodic_table -f periodic_table.sql`
7. Connect `psql --username=freecodecamp --dbname=periodic_table`


