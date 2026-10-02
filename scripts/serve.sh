
ROOT="${PROJECT_ROOT:-$PWD}"
PORT="${1:-8000}"

if [ ! -f "$ROOT/site/index.html" ]; then
  echo "no site/index.html under $ROOT" >&2
  exit 1
fi

echo "serving $ROOT/site on http://localhost:$PORT"
exec python3 -m http.server "$PORT" --directory "$ROOT/site" --bind 127.0.0.1
