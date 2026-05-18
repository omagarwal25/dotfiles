#!/usr/bin/env bash
# Update sketchybar-app-font (font + icon_map.sh) from upstream.
# Local mappings in __icon_map_local() are preserved; only the block between
# ### START-OF-ICON-MAP and ### END-OF-ICON-MAP gets replaced.
#
# Usage: ./update-icons.sh [--no-restart]
set -euo pipefail

REPO="kvndrsslr/sketchybar-app-font"
ICON_MAP="$HOME/.config/sketchybar/plugins/icon_map.sh"
FONT_PATH="$HOME/Library/Fonts/sketchybar-app-font.ttf"

# Guardrail: bail if the local file doesn't have the override scaffolding.
# Without it, splicing would clobber any local additions.
if ! grep -q '__icon_map_local' "$ICON_MAP"; then
	echo "error: $ICON_MAP is missing __icon_map_local() scaffolding." >&2
	echo "       refusing to overwrite — set up the wrapper first." >&2
	exit 1
fi

tag=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
	| sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1)
[ -n "$tag" ] || { echo "error: could not detect latest release tag" >&2; exit 1; }

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

echo "Fetching sketchybar-app-font $tag..."
curl -fsSL -o "$tmpdir/icon_map.sh" "https://github.com/$REPO/releases/download/$tag/icon_map.sh"
curl -fsSL -o "$tmpdir/font.ttf"    "https://github.com/$REPO/releases/download/$tag/sketchybar-app-font.ttf"

before=$(grep -c '^[[:space:]]*"' "$ICON_MAP" || true)

# Splice: keep everything outside ### START/END markers (local overrides + dispatch),
# replace the block between them with the upstream version.
{
	awk '/### START-OF-ICON-MAP/{exit} {print}' "$ICON_MAP"
	awk '/### START-OF-ICON-MAP/,/### END-OF-ICON-MAP/'  "$tmpdir/icon_map.sh"
	awk 'flag; /### END-OF-ICON-MAP/{flag=1}'           "$ICON_MAP"
} > "$tmpdir/merged.sh"

mv "$tmpdir/merged.sh" "$ICON_MAP"
chmod +x "$ICON_MAP"

after=$(grep -c '^[[:space:]]*"' "$ICON_MAP" || true)
echo "Icon mappings: $before -> $after"

# Font: only restart if the binary actually changed (font cache needs refresh).
# Icon-map-only changes can be picked up with sketchybar --update.
font_changed=0
if ! cmp -s "$tmpdir/font.ttf" "$FONT_PATH" 2>/dev/null; then
	cp "$tmpdir/font.ttf" "$FONT_PATH"
	font_changed=1
fi

if [ "${1:-}" = "--no-restart" ]; then
	echo "Updated to $tag. (skipped restart)"
	[ "$font_changed" = "1" ] && echo "Run 'brew services restart sketchybar' to load the new font."
elif [ "$font_changed" = "1" ]; then
	echo "Font changed — restarting sketchybar..."
	brew services restart sketchybar > /dev/null
	echo "Updated to $tag."
else
	echo "Font unchanged — refreshing items..."
	sketchybar --update > /dev/null
	echo "Updated to $tag."
fi
