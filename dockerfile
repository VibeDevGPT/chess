FROM lichessbotdevs/lichess-bot:latest

WORKDIR /lichess-bot

# Download your pre-compiled v8_linux binary from GitHub Releases
RUN python3 -c "import os, stat, urllib.request, zipfile; \
    os.makedirs('/lichess-bot/VeloCT', exist_ok=True); \
    urllib.request.urlretrieve('https://github.com/VibeDevGPT/VeloCT/releases/download/linux/v8_linux.zip', 'v8.zip'); \
    zipfile.ZipFile('v8.zip').extractall('/lichess-bot/VeloCT'); \
    os.remove('v8.zip'); \
    p = '/lichess-bot/VeloCT/v8_linux'; \
    os.chmod(p, os.stat(p).st_mode | stat.S_IEXEC)"

COPY run.py /lichess-bot/run.py

CMD ["python3", "run.py"]
