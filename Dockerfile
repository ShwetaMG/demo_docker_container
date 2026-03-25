# 1. Use an official Python image as the base
FROM python:3.12-slim

# 2. Set the directory inside the container where our code will live
WORKDIR /app

# 3. Copy the requirements file from your laptop into the container
COPY requirements.txt .

# 4. Install the libraries listed in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy the rest of your Django project code into the container
COPY . .

# 6. Tell Docker that the container will listen on port 8000
EXPOSE 8000

# 7. The command to start your Django app when the container launches
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]