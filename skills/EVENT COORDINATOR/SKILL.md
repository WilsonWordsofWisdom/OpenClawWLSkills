# SKILL.md - Event Coordinator

**Name:** Event Coordinator Pro
**Description:** Professional event orchestration for Google Workspace with integrated conflict resolution, attendee verification, and stateful logistics tracking.

## 🛡️ Mandatory Security Guardrails
Before performing any action, the agent MUST adhere to these rules:
1. **Domain Verification**: Before adding any attendee to a calendar invite or sending an email, verify the email domain. If the domain is external to the organization, seek explicit user approval.
2. **Privacy Shield**: Never share "Private" or "Confidential" calendar entries with external attendees. Only share "Busy/Free" status unless specified otherwise.
3. **Least Privilege**: Use the most restrictive access level possible when sharing Drive folders for event materials (e.g., "Viewer" instead of "Editor" for general attendees).

## 🔄 Conflict Resolution & Deconfliction Engine
The agent MUST NOT perform a `+insert` without first executing the **Deconfliction Workflow**:

### Step 1: The Availability Scan
- Run `gws calendar +agenda --days [X]` for the requested date/time.
- Scan for overlapping entries. If a conflict exists, do NOT book.

### Step 2: The Triage Process
If a conflict is found, the agent must:
1. **Identify the Conflict**: Note the name and priority of the existing event.
2. **Propose Alternatives**: Find the next three available slots that work for all primary attendees.
3. **Present to User**: "A conflict exists ([Event Name]). Would you like to: (A) Overwrite the existing event, (B) Move to [Alternative Slot 1], or (C) Manual override?"

---

## ⚙️ Operational Workflows

### 1. Event Scheduling (The "Secure-Book" Flow)
- **Check**: Run `+agenda` $\rightarrow$ Resolve conflicts $\rightarrow$ Verify attendee domains.
- **Execute**: Use `gws calendar +insert` with a clear title, precise location, and verified attendee list.
- **Confirm**: Verify the event appears in the calendar before notifying attendees.

### 2. Logistics & Material Prep
- **Centralize**: Create a dedicated folder in Drive for the event.
- **Upload**: Use `gws drive +upload` for agendas, slide decks, and briefing docs.
- **Distribute**: Send a "Welcome/Prep" email via `gws gmail +send` containing the Drive links.

### 3. State-Aware RSVP Tracking
To avoid duplicate entries in Google Sheets:
- **Search First**: Use `gws sheets +find` to check if the attendee's email already exists in the RSVP sheet.
- **Conditional Action**:
    - If **NOT found**: Use `gws sheets +append` to add the new RSVP.
    - If **found**: Use `gws sheets +update` to refresh their status (e.g., changing "Maybe" to "Yes").

### 4. Communication & Updates
- **Announce**: Use `gws workflow +file-announce` in the relevant Chat space for real-time updates.
- **Digest**: Use `gws workflow +weekly-digest` to summarize upcoming events and pending RSVPs for the organizer.

---

## 💡 Pro Tips
- **Buffer Zones**: Always suggest a 15-minute "buffer" between back-to-back meetings.
- **Timezone Sync**: When booking across regions, explicitly state the time in both the organizer's and the attendee's local timezones.
- **Dedicated Calendars**: For recurring series, create a dedicated "Event Calendar" to avoid cluttering the primary personal calendar.