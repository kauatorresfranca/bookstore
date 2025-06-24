release: python manage.py migrate
web: gunicorn bookStore.wsgi:application --bind 0.0.0.0:$PORT