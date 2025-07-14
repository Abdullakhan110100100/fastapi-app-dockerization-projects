Dockerized the fastapi app. Below are the changes and the desicions and considerations made while dockerizing this app.

# Setup instructions:
Install and run the docker desktop.
Clone this repository and enter the folder.
Start terminal, enter and run docker compose up --build 
After the success status is shown in terminal you can access the app at http://localhost:8000/items

# Changes made and design descisions
1. dockerfile
Used python-3.9-slim as the base image as slim is 40-50% smaller and only requires the minimal dependencies.
Ran apt-get installs for various system level or non python library dependencies.
Implemented a wait-for-it.sh file to ensure that database is ready before app is run.
Ran installs on requirements.txt using --no-cache-dir to durther reduce the size of the image making sure that no pip cache is stored.
The shell command is run first ensuring that db is available only after that is the main.py run.

2. wait-for-it.sh
Gets the first argument and extracts the host and the port.Uses netcat to check connection and loops until a successfull connection is made after which it executes the rest of the command.
It is efficient and uses basic shell features. It wont proceed until the db is ready and provides status messages to help debug

3. docker-compose.yml
Uses a postgreSQL 14 and pull credentials from the .exv file. It persists the data between starts in a volume and exposes port 5432 for access. 
Uses pg_isready utility of postgres for health checks. 
Starts the web app after the db container starts by using the service healthy condition in depends on. Exposes the fastapi app on port 8000

4. Other changes:
Changed the prefix in main.py for the app to be accessible by /items/
Added a dependency to requirements.txt that was throwing an error.

