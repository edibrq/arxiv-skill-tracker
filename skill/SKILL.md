# arXiv Skill Evolution Tracker

Track and collect research papers from arXiv related to skill evolution in AI agents.

## Purpose

This skill is triggered daily via OpenClaw cron to:
1. Search arXiv for papers on "skill evolution", "skill learning", "self-evolving agents" published **today only**
2. Extract paper metadata (title, authors, abstract, arXiv ID)
3. Create/update daily markdown file in the tracker repository
4. **Only create PR if there are new papers** — skip if nothing found

## Repository Location

`/home/eduard/.openclaw/workspace/arxiv-skill-tracker`

## Search Queries

Use these search terms with `freshness: "day"` filter:
- `skill evolution AI agents arxiv`
- `skill learning LLM arxiv`
- `self-evolving agents arxiv`
- `skill-augmented reinforcement learning arxiv`

## Important Rules

### Only Fresh Papers
- Use `freshness: "day"` to get only papers from the last 24 hours
- Do NOT include older papers that were already collected
- Check if papers file already exists for today before searching

### Skip If Empty
- If no new papers found → do nothing (no branch, no commit, no PR)
- Only create PR when there are actual new papers to report

## Output Format

Create markdown files in `papers/YYYY-MM-DD.md` with:

```markdown
# arXiv Skill Evolution Papers - YYYY-MM-DD

> X papers found

---

## 1. Paper Title

**arXiv:** [ID](https://arxiv.org/abs/ID)  
**Published:** DATE  
**Authors:** ...

### Abstract
...

---
```

## Git Workflow

After updating papers (only if new papers exist):
1. `git checkout main && git pull`
2. `git checkout -b papers/YYYY-MM-DD`
3. `git add .`
4. `git commit -m "docs: add arXiv papers for YYYY-MM-DD"`
5. `git push -u origin papers/YYYY-MM-DD`
6. `gh pr create --title "arXiv Papers: YYYY-MM-DD" --body "..."`
7. `git checkout main`

## Cron Schedule

Run daily at 08:00 Moscow time (Europe/Moscow, GMT+3).

---

*This skill is triggered by OpenClaw cron jobs.*