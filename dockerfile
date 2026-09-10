FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    FLASK_APP=app.py \
    NEW_RELIC_CONFIG_FILE=/app/newrelic.ini

WORKDIR /app

RUN addgroup --system app && adduser --system --ingroup app app

COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

COPY --chown=app:app . .
USER app

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:5000/')" || exit 1

CMD ["sh", "-c", "if [ -f \"$NEW_RELIC_CONFIG_FILE\" ]; then exec newrelic-admin run-program gunicorn --bind 0.0.0.0:5000 --workers 2 --threads 4 app:app; else exec gunicorn --bind 0.0.0.0:5000 --workers 2 --threads 4 app:app; fi"]
