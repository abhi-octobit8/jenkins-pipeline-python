# Use an official Python runtime as the base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt /app/

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

# Copy the rest of the application code to the container
COPY . /app/

# Expose a port if your Django app listens on a specific port
# EXPOSE 8000

# Collect static files (if needed)
# RUN python manage.py collectstatic --noinput

# Run Gunicorn with your Django application
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "your_app_name.wsgi:application"]
