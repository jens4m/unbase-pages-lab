# unbase-pages-lab

Throwaway test site for Unbase's GitHub Pages adapter. Shaped like a plain-HTML customer site:
the Pages workflow copies the HTML into `_site`, fills `__API_URL__` from the repository variable
`API_URL` and `__SHA__` from the commit, and uploads `_site` only, so `secret.gs` is never published.
