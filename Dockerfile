FROM python:3.12-slim

WORKDIR /lichess-bot

RUN apt-get update && apt-get install -y --no-install-recommends curl unzip \
    && rm -rf /var/lib/apt/lists/*

# Install lichess-bot on stable Python 3.12
RUN curl -fL https://github.com/lichess-bot-devs/lichess-bot/archive/refs/heads/master.zip -o lb.zip \
    && unzip -q lb.zip \
    && mv lichess-bot-master/* . \
    && rm -rf lichess-bot-master lb.zip \
    && pip install --no-cache-dir -r requirements.txt

# Download your pre-compiled v8_linux binary
RUN python3 -c "import os, stat, urllib.request, zipfile; \
    os.makedirs('/lichess-bot/VeloCT', exist_ok=True); \
    urllib.request.urlretrieve('https://github.com/VibeDevGPT/VeloCT/releases/download/linux/v8_linux.zip', 'v8.zip'); \
    zipfile.ZipFile('v8.zip').extractall('/lichess-bot/VeloCT'); \
    os.remove('v8.zip'); \
    p = '/lichess-bot/VeloCT/v8_linux'; \
    os.chmod(p, os.stat(p).st_mode | stat.S_IEXEC)"

COPY run.py /lichess-bot/run.py

CMD ["python3", "-u", "run.py"]
