
# Intervene

**Autopilot for your desktop workflows**  
Intervene is an on-device autonomous desktop agent that takes over repetitive tasks—filling forms, renaming files, drafting emails, organizing tabs, and more.

Just like Tesla Autopilot, you stay in control: touching the mouse or keyboard instantly halts the agent and returns full manual control.

Built entirely on-device using Meta’s Llama Stack for fast, private, agentic task execution.

---

## Features

### Autonomous Mode
- Executes scripted or inferred actions based on desktop context
- Triggered by open tabs, folders, file names, etc.
- Executes actions when user is idle or confirms manually

### Manual Takeover
- Mouse or keyboard input immediately halts automation
- Re-enable Copilot Mode via hotkey or voice

### Memory and Personalization
- Remembers recurring workflows (e.g. weekly status reports)
- Adapts behavior per app (e.g. Slack, Figma, Finder)

### Safety and Privacy
- No cloud or API calls—runs entirely on-device
- Guardrails via Llama Safety API
- Manual confirmation required for any destructive action

### Reporting
- Tracks time saved per week from automated workflows

---

## Llama Stack Usage

- **Inference API**: parses commands, understands UI structure
- **Memory API**: tracks recurring behaviors and preferences
- **Safety API**: enforces local-only execution and redacts sensitive data

---

## Setup Instructions

### 1. Clone the Repo

```bash
git clone https://github.com/your-org/intervene.git
cd intervene
```

---

### 2. Run macOS Swift Agent

#### Requirements:
- macOS
- Xcode

#### Run:

```bash
cd macos-agent
open Intervene.xcodeproj
```

Then press `Cmd+R` in Xcode.  
Make sure to grant accessibility and automation permissions in System Settings.

---

### 3. Run Backend Server

#### Requirements:
- Node.js v18+
- Yarn or npm

```bash
cd backend
yarn install       # or npm install
yarn dev           # or npm run dev
```

---

### 4. Run Ollama (Llama 3) Locally

#### Install:

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

#### Run:

```bash
ollama run llama3
```

---

## Demo Tips

- Show side-by-side: manual vs. Copilot Mode
- Include natural voice command: “Hey Copilot, archive last month’s invoices”
- Add a visual overlay during automation mode (e.g. cursor color change)

---

## Authors

Daniel Gao  
Shubhayan Srivastava  
Vishnu Kadaba  

Built for the 8VC Llama Stack Hackathon
