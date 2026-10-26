# Ziqian Ding’s personal website

Academic website at [zding1016.github.io](https://zding1016.github.io), built with the supplied [al-folio v1 starter](https://github.com/alshedivat/al-folio).

The navigation contains **About** and **Research**. The existing paper detail page uses the same styling, and the PDF and Google verification file keep their original URLs. No profile photo is displayed.

## Edit the site

| Content                                               | Source                             |
| ----------------------------------------------------- | ---------------------------------- |
| Name, domain, feature switches, and unpublished files | `_config.yml`                      |
| About page                                            | `_pages/about.md`                  |
| Research page                                         | `_pages/research.md`               |
| Published papers                                      | `_bibliography/publications.bib`   |
| Working papers and expandable abstracts               | `_bibliography/working_papers.bib` |
| Existing paper detail page and citation metadata      | `dynamic-policy-evaluation.html`   |
| Paper PDF                                             | `dynamic-policy-evaluation.pdf`    |
| Social profile examples, currently commented out      | `_data/socials.yml`                |

For a published paper, add a BibTeX entry to `publications.bib`; for a working paper, use `working_papers.bib`. Research displays these in separate sections without large year headings (`scholar.group_by: none`). The native **Abs** control expands its `abstract`; **PDF** opens `pdf`; **HTML** opens `html`; **DOI** opens `doi`; and **Website** opens `website` (currently the SSRN page). Use full URLs for root-level HTML and PDF files: al-folio otherwise interprets those fields relative to its example asset directories.

The paper’s title, author order, year, and abstract also appear on its detail page; keep the two sources consistent when updating it. Keep its `citation_*` meta tags in the HTML head.

Keep **all authors**, including Ziqian Ding, in each BibTeX `author` field. Research uses the site-owned `research_bibliography` tag in `_plugins/research_bibliography.rb` to display every coauthor, in the original order, as “with Name, Name and Name”. It omits your name using the identity in `scholar.first_name` and `scholar.last_name`, without changing the citation data or adding an author expansion control.

Preserve these public URLs:

- `/dynamic-policy-evaluation.html`
- `/dynamic-policy-evaluation.pdf`
- `/google41bb5e02e922f801.html`

Jekyll generates `sitemap.xml` and `robots.txt` during the build. This is a root-domain GitHub Pages site, so `_config.yml` must keep `url: https://zding1016.github.io` and `baseurl: ""`. Upstream documentation’s `/al-folio` path applies to the template demonstration site.

## Preview and validate locally

Use the latest Ruby **3.3.x** patch, Bundler **4.0.6**, and Node **20** to match deployment. CI uses the pinned **Ubuntu 24.04** runner and `ruby-version: "3.3"` so it receives compatible Ruby patch updates without following `ubuntu-latest` OS changes. Install Ruby through your preferred version manager; macOS’s system Ruby is too old. Keep the supplied dependency lockfiles.

```bash
gem install bundler -v 4.0.6
bundle install
npm ci
bundle exec jekyll serve
```

Open [localhost:4000](http://localhost:4000/). For a production build and checks:

```bash
npm run lint:prettier
npm run lint:style-contract
bundle exec al-folio upgrade audit --no-fail
bundle exec al-folio upgrade overrides audit
JEKYLL_ENV=production bundle exec jekyll build
```

The generated site is in `_site/` and is ignored by Git. Check both color modes, the mobile navigation, abstract expansion, paper links, and the generated sitemap after content or configuration changes. The upstream visual suite targets the demonstration site and is retained as an inactive reference.

## Restore optional sections

The template’s source files and dependencies remain available. Unused pages, collections, and demo assets are excluded from the generated website rather than deleted. Comments in `_config.yml` identify the switches.

To restore a section:

1. Remove its page and relevant content/asset directories from `_config.yml`’s `exclude` list.
2. Set its collection’s `output` to `true` when it has a collection, and enable the relevant feature flags.
3. Set the page’s `nav` and `nav_order` as desired, then replace all example content before publishing.
4. Enable any homepage block separately in `_pages/about.md` if desired.

For a photo, replace `profile: false` in the About page with its commented profile settings and provide your image. Restore the image’s excluded path and responsive-image configuration only if needed. Social links can be restored by editing and uncommenting your own values in `_data/socials.yml` and enabling `social` on About.

The original sample bibliography remains separate from the active working-paper bibliography. The CV, blog, news, projects, teaching, books, repositories, and other examples stay inactive until explicitly enabled. External blog imports, archives, pagination, and search also have separate switches; enabling a menu item alone does not enable them.

Only `.github/workflows/deploy.yml` is active. Other workflows retain their contents with `.disabled` appended to the filename. Remove that suffix only after checking the workflow’s triggers, repository references, and required credentials for this personal site; some examples run scheduled updates or publish upstream releases.

For complete template guidance, see [customization](docs/CUSTOMIZE.md), [installation](docs/INSTALL.md), [architecture](docs/ARCHITECTURE.md), and the [upstream README](https://github.com/alshedivat/al-folio#readme). Codex should start with [AGENTS.md](AGENTS.md) and the bundled [Bootstrap skill](.agents/skills/al-folio-bootstrap/SKILL.md).

## GitHub Pages deployment

The active workflow builds pull requests without publishing. Every push to `main` builds and publishes `_site/` to `gh-pages`, including changes that only replace a PDF. Manual runs publish only when run from `main`.

Before the first deployment:

1. Enable GitHub Actions for the repository.
2. In **Settings → Actions → General → Workflow permissions**, allow **Read and write permissions**.
3. Push the reviewed migration to `main` and wait for **Build and deploy site** to finish.
4. In **Settings → Pages**, choose **Deploy from a branch**, branch **gh-pages**, folder **/(root)**.

The workflow creates `.nojekyll` in its output so GitHub serves the already-built site. Edit the source branch; `gh-pages` is generated output and is overwritten by deployment.

### Troubleshooting deployment

- **Ruby version unavailable:** keep the workflow on `ubuntu-24.04` with `ruby-version: "3.3"`. Newer runner images may not provide old patch releases such as 3.3.5. See [setup-ruby's supported platforms](https://github.com/ruby/setup-ruby#supported-platforms).
- **`actions/jekyll-build-pages` cannot find `al_folio_core`:** Pages is trying to build the source branch with GitHub's restricted Jekyll environment. First let **Build and deploy site** finish successfully and create `gh-pages`; then select **Deploy from a branch → gh-pages → /(root)** in [repository Pages settings](https://github.com/zding1016/zding1016.github.io/settings/pages). Do not select `main` or add `.nojekyll` to the source branch. See [GitHub's publishing-source documentation](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site#troubleshooting-publishing-from-a-branch).
