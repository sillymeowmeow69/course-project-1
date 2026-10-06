import os
import socket
import sys
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer


class NoCacheHandler(SimpleHTTPRequestHandler):
  def end_headers(self):
    self.send_header("Cache-Control", "no-store")
    super().end_headers()


def lan_ip():
  with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
    try:
      s.connect(("10.255.255.255", 1))
      return s.getsockname()[0]
    except OSError:
      return "127.0.0.1"


def main():
  port = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
  directory = os.path.abspath(sys.argv[2] if len(sys.argv) > 2 else "site")

  handler = partial(NoCacheHandler, directory=directory)
  server = ThreadingHTTPServer(("0.0.0.0", port), handler)

  print(f"serving {directory}", flush=True)
  print(f"  local   http://127.0.0.1:{port}", flush=True)
  print(f"  network http://{lan_ip()}:{port}", flush=True)

  try:
    server.serve_forever()
  except KeyboardInterrupt:
    print("\nstopping", flush=True)
  finally:
    server.server_close()


if __name__ == "__main__":
  main()
