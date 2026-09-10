# AI Usage Log

## Logging rules

- Record meaningful AI interactions affecting requirements, architecture, design, implementation, debugging, testing, or documentation. Omit trivial exchanges.
- Preserve the actual prompt and meaningful follow-ups, and summarize what the AI returned.
- Record **Accepted**, **Edited**, or **Rejected**, with the reason. For mixed decisions, explain the disposition of each relevant part and describe edits.
- Record actual decisions only. Use **Pending review** until a decision is made, then update it.
- Use the actual interaction timestamp with timezone offset; do not backdate entries.
- Update this file throughout development and commit each entry with the related work whenever possible. Commit rejected proposals separately if no code changes result.
- Preserve earlier entries; append dated corrections when decisions change. Git history provides commit timestamps for comparison with this log.
- Never log credentials or private data; explicitly mark any necessary redaction.

## Entry template

Copy this template under Entries and replace the placeholders. This template is not an interaction entry.

```markdown
### AI-001 - <topic>

- Date/time: <YYYY-MM-DDTHH:mm:ss+HH:mm>
- Tool/model: <actual tool and model; unknown if unavailable>
- Context: <task or problem>

#### Prompt

> <Exact meaningful prompt, preserving multiline content and meaningful follow-ups.>

#### AI response summary

<What the AI returned: relevant suggestions, code, or findings.>

#### Decision

- Outcome: <Accepted | Edited | Rejected; Pending review until reviewed>
- Reason: <Why; describe changes if edited.>
- Validation: <Checks actually performed and results, or not yet verified.>
- Related work: <Files, task, or commit reference when available.>
```

## Entries

No entries yet.
