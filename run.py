import http.server
import os
import subprocess
import sys
import threading
import yaml

# 1. Keep-alive HTTP server for Render's required web port
port = int(os.environ.get("PORT", 10000))

class PingHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"VeloCT is alive!")

    def log_message(self, *args):
        pass

threading.Thread(
    target=lambda: http.server.HTTPServer(("0.0.0.0", port), PingHandler).serve_forever(),
    daemon=True,
).start()

# 2. Write config to /tmp/config.yml
config_path = "/tmp/config.yml"
config = {
    "token": os.environ["LICHESS_TOKEN"].strip(),
    "url": "https://lichess.org/",
    "engine": {
        "dir": "/lichess-bot/VeloCT/",
        "name": "v8_linux",
        "working_dir": "/lichess-bot/VeloCT/",
        "protocol": "uci",
        "ponder": False,
        "online_moves": {
            "online_egtb": {
                "enabled": True,
                "min_time": 20,
                "max_pieces": 7,
                "source": "lichess",
            }
        },
        "uci_options": {
            "Threads": 1,
            "Hash": 64,
        },
    },
    "abort_time": 30,
    "move_overhead": 2000,
    "challenge": {
        "concurrency": 1,
        "sort_by": "best",
        "accept_bot": True,
        "only_bot": False,
        "max_increment": 20,
        "min_increment": 0,
        "max_base": 1800,
        "min_base": 30,
        "variants": ["standard"],
        "time_controls": ["bullet", "blitz", "rapid"],
        "modes": ["casual", "rated"],
    },
    "greeting": {
        "hello": "Hi {opponent}! I'm VeloCT (V8). Good luck!",
        "goodbye": "Good game!",
    },
    "pgn_directory": "",
}

with open(config_path, "w") as f:
    yaml.safe_dump(config, f)

# 3. Launch lichess-bot using /tmp/config.yml
subprocess.check_call([
    sys.executable, "lichess-bot.py",
    "--config", config_path,
    "-v", "--disable_auto_logging",
])
