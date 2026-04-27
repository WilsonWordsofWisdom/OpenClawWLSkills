---
name: CSV
description: Securely parse and generate RFC 4180 compliant CSVs with protections against Formula Injection and Resource Exhaustion.
metadata: {"clawdbot":{"emoji":"📊","os":["linux","darwin","win32"]}}
---

## 🛡️ Security Guardrails (Mandatory)

### 1. Formula Injection Prevention (CSV Injection)
- **The Risk:** Fields starting with `=`, `+`, `-`, or `@` can be executed as formulas by spreadsheet software (Excel, Google Sheets), potentially leading to remote code execution (RCE) or data exfiltration.
- **The Control:** 
  - **Generation:** All fields must be sanitized. If a field starts with a sensitive character (`=`, `+`, `-`, `@`), it MUST be prefixed with a single quote (`'`) or a tab character to force the spreadsheet to treat it as literal text.
  - **Parsing:** Treat all parsed values as untrusted strings. Never pass CSV content directly into a function that evaluates expressions.

### 2. Resource Exhaustion (DoS) Protection
- **The Risk:** "CSV Bombs" (extremely large files or deeply nested quotes) can crash the parser or exhaust system RAM.
- **The Control:**
  - **Row/Col Limits:** Enforce a maximum row count (e.g., 10k) and maximum column count (e.g., 100) before processing.
  - **Field Size Limit:** Limit the maximum characters allowed per single field.
  - **Streaming:** For files larger than 5MB, use streaming parsers instead of loading the entire file into memory.

### 3. Encoding & Sanitization
- **The Risk:** Maliciously crafted encodings can bypass filters or cause "character set" attacks.
- **The Control:**
  - **Strict UTF-8:** Force UTF-8 encoding. Detect and strip unexpected null bytes (`\0`).
  - **BOM Handling:** Handle UTF-8 BOM (0xEF 0xBB 0xBF) explicitly to prevent parsing offsets.

---

## ⚙️ Technical Specifications (RFC 4180)

### Quoting & Escaping
- **Wrapping:** Fields containing commas, double quotes, or newlines MUST be wrapped in double quotes.
- **Escaping:** Double quotes inside quoted fields MUST be escaped as `""` (two double quotes).
- **Preservation:** Quote fields with leading/trailing whitespace to prevent automatic trimming by downstream tools.

### Delimiters & Detection
- **Detection:** Sniff for `,`, `;` (European), `\t` (TSV), or `|`. 
- **Validation:** Verify that the delimiter is consistent across the first 10 rows. If inconsistent, halt and alert the user.

### Data Integrity
- **Column Consistency:** Every row MUST have the same number of columns as the header. If a mismatch is detected, log a warning and treat the row as malformed.
- **EOF Handling:** Strip trailing newlines at the end of the file to avoid creating phantom empty rows.

---

## 📅 Data Formatting

### Numbers & Dates
- **Localization:** Standardize all numeric output to `.` for decimals and no thousands separator to avoid locale-based parsing errors.
- **Date Format:** Use **ISO 8601** (`YYYY-MM-DD`) exclusively for unambiguous interpretation.
- **Leading Zeros:** Quote numeric fields with leading zeros (e.g., `"007"`) to prevent them from being cast as integers.

### Excel Precision
- **Precision Loss:** Fields with >15 digits must be quoted and prefixed with `'` to prevent Excel from converting them to scientific notation or losing precision.