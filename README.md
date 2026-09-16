# Seeded indexation test

Static test page for measuring whether Google preserves invisible-Unicode payloads
as searchable tokens. Answer key is kept **outside** this repo.

## Setup

    ./setup.sh <github-username> <repo-name>
    git init && git add -A && git commit -m "field notes"
    git branch -M main
    git remote add origin git@github.com:<username>/<repo>.git
    git push -u origin main

Then: repo **Settings -> Pages -> Source: Deploy from a branch -> main / (root)**.
Wait for the green check on the Pages deployment.

## Verify before requesting indexing

    ./verify.sh https://<username>.github.io/<repo>/sourdough-starters-never-die.html

Must report 96 invisible characters and no `X-Robots-Tag`. If it does not, stop:
a null search result would be uninterpretable.

## Index

1. Search Console -> Add property -> **URL prefix** -> `https://<username>.github.io/<repo>/`
2. Verify via the **HTML file** method - commit the `google*.html` file they give you to
   the repo root and push. (The meta-tag method only verifies the page it is on.)
3. URL Inspection -> post URL -> **Request Indexing**
4. Sitemaps -> submit `sitemap.xml`

## Read results

- Query the CONTROL token first. No hit = not indexed yet; nothing else is interpretable.
- Then each pair from `search_queries_v2.txt`.
- After crawl: URL Inspection -> **View Crawled Page -> HTML** shows the exact bytes
  Googlebot received. Payloads present there + no search hits = the loss is at
  tokenisation, not transport.
- Re-run the full set at day 3 and day 7 before concluding anything.

`.nojekyll` is present to stop GitHub's Jekyll pipeline from touching the files.
