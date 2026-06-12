# Glass & Thorns

Static artist site for `glassandthorns.art`.

## Structure

- `index.html` - home page, release teaser, artist copy, and contact links
- `lyrics/index.html` - lyrics page for "My Body Isn't Home Anymore"
- `styles.css` - shared layout and visual styling
- `assets/images/` - logo, logo text, and cover artwork
- `CNAME` - GitHub Pages custom domain

## Local Preview

From the repo root:

```sh
python3 -m http.server 4174 --bind 127.0.0.1
```

Then open `http://127.0.0.1:4174/`.

## Verification

Run the static-site checks before committing:

```sh
sh scripts/verify-site.sh
```

GitHub Actions runs the same check on pull requests and pushes to `main`.

## Maintenance Notes

- Keep links real before publishing them. If a Spotify, Instagram, TikTok, YouTube, or Apple Music URL is not ready yet, leave it out rather than using `href="#"`.
- The cover art is a wide image, so preserve its natural aspect ratio instead of forcing it into a square crop.
- Use valid machine-readable dates only when exact release dates exist. For "Coming soon" or "TBA", use plain text instead of a `<time datetime="...">` value.
