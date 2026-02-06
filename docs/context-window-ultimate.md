# Ultimate Context Window Management System

> 2026년 2월 기준 SOTA(State-of-the-Art) 메모리 시스템 통합

## Architecture

```
Layer 4: Hindsight     (★1,324) - Learning Memory
Layer 3: Mem0 MCP      (★644)   - Persistent Memory
Layer 2: QMD           (★6.4k)  - Local Semantic Search
Layer 1: MEMORY.md              - Session Index (< 200 lines)
Layer 0: Topic Files            - Full Documentation (never reduced)
```

## Key Sources

| Project | Stars | Purpose |
|---------|-------|---------|
| [vectorize-io/hindsight](https://github.com/vectorize-io/hindsight) | ★1,324 | Memory that learns (LongMemEval SOTA 92.3%) |
| [coleam00/mcp-mem0](https://github.com/coleam00/mcp-mem0) | ★644 | MCP server for Claude + Mem0 |
| [FareedKhan-dev/optimize-ai-agent-memory](https://github.com/FareedKhan-dev/optimize-ai-agent-memory) | ★213 | 9 optimization techniques |
| [tobi/qmd](https://github.com/tobi/qmd) | ★6.4k | Local BM25 + Vector search |

## Quick Setup

### 1. Hindsight (Docker)

```bash
export OPENAI_API_KEY=your-key

docker run --rm -it --pull always -p 8888:8888 -p 9999:9999 \
  -e HINDSIGHT_API_LLM_API_KEY=$OPENAI_API_KEY \
  -e HINDSIGHT_API_LLM_MODEL=gpt-5-mini \
  -v $HOME/.hindsight:/home/hindsight/.pg0 \
  ghcr.io/vectorize-io/hindsight:latest
```

### 2. Mem0 MCP

```bash
git clone https://github.com/coleam00/mcp-mem0.git
cd mcp-mem0
docker build -t mcp/mem0 --build-arg PORT=8050 .
docker run --env-file .env -p 8050:8050 mcp/mem0
```

### 3. Claude Code MCP Config

```json
// ~/.claude/claude_code_config.json
{
  "mcpServers": {
    "mem0": {
      "transport": "sse",
      "url": "http://localhost:8050/sse"
    },
    "qmd": {
      "command": "qmd",
      "args": ["mcp"]
    }
  }
}
```

### 4. QMD

```bash
bun install -g https://github.com/tobi/qmd
qmd collection add ~/Obsidian/Vault --name vault
qmd update && qmd embed
```

## 9 Optimization Techniques

| # | Technique | Token Savings |
|---|-----------|---------------|
| 1 | Sliding Window | 70% |
| 2 | Summarization | 80% |
| 3 | Retrieval-based | 90% |
| 4 | Hierarchical | 60% |
| 5 | Graph-based | 85% |
| 6 | Compression | 50% |
| 7 | Memory-Augmented | 75% |
| 8 | Selective Retention | 65% |
| 9 | OS-like Management | 95% |

## Hindsight API

```python
from hindsight_client import Hindsight

client = Hindsight(base_url="http://localhost:8888")

# Store with learning
client.retain(bank_id="my-memory", content="Important pattern")

# Semantic search
client.recall(bank_id="my-memory", query="find patterns")

# Generate response with learned knowledge
client.reflect(bank_id="my-memory", query="What did I learn?")
```

## Mem0 MCP Tools

| Tool | Description |
|------|-------------|
| `save_memory` | Store information |
| `get_all_memories` | Retrieve all |
| `search_memories` | Semantic search |

## Health Check

```bash
#!/bin/bash
echo -n "Hindsight: "; curl -sf localhost:8888/health && echo "✅" || echo "❌"
echo -n "Mem0: "; curl -sf localhost:8050/health && echo "✅" || echo "❌"
echo -n "QMD: "; qmd status > /dev/null 2>&1 && echo "✅" || echo "❌"
```

## Token Savings

| Before | After | Savings |
|--------|-------|---------|
| 500K (full vault) | 50K (on-demand) | 90% |
| 10K (agent) | 500 (CLI) | 95% |

---

*SOTA as of February 2026*
