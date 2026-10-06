ROOT="${PROJECT_ROOT:-$PWD}"
TARGET_SITE="$ROOT/../../../html"

rsync -av --delete "$ROOT"/media-src/ "$ROOT"/site/media
rsync -av --delete "$ROOT"/site/ "$TARGET_SITE"
