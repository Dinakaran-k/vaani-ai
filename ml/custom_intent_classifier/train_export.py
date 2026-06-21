"""Train and export a lightweight on-device intent model for Vaani AI.

This script builds a multinomial Naive Bayes classifier from curated phrases
that reflect the merchant commands used throughout the app. The exported JSON
can be loaded by the Flutter runtime to classify voice transcripts entirely on
device.
"""

from __future__ import annotations

import json
import math
import re
from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path


OUTPUT_DIR = Path(__file__).resolve().parent
MODEL_PATH = OUTPUT_DIR / "custom_intent_model.json"

ALPHA = 1.0


@dataclass(frozen=True)
class Example:
    label: str
    text: str


EXAMPLES: list[Example] = [
    # add_inventory
    Example("add_inventory", "Add 20 rice bags"),
    Example("add_inventory", "Add 12 kg atta"),
    Example("add_inventory", "Restock 15 soap bars"),
    Example("add_inventory", "Put 8 boxes of tea"),
    Example("add_inventory", "Add 24 bottles of water"),
    Example("add_inventory", "20 bags rice add karo"),
    Example("add_inventory", "10 kg chawal dalo"),
    Example("add_inventory", "25 packet biscuits badhao"),
    Example("add_inventory", "5 crates cold drink add"),
    Example("add_inventory", "Increase 30 pens"),
    # sales_today
    Example("sales_today", "Show today's sales"),
    Example("sales_today", "How much did we sell today"),
    Example("sales_today", "Aaj ki sales dikhao"),
    Example("sales_today", "today sales report"),
    Example("sales_today", "sales today summary"),
    Example("sales_today", "show today's revenue"),
    Example("sales_today", "aaj ka sale batao"),
    Example("sales_today", "today turnover"),
    Example("sales_today", "how are sales today"),
    Example("sales_today", "sales report for today"),
    # low_stock
    Example("low_stock", "Show low stock items"),
    Example("low_stock", "Which products are running low"),
    Example("low_stock", "kam stock items dikhao"),
    Example("low_stock", "low inventory alert"),
    Example("low_stock", "what is low stock now"),
    Example("low_stock", "list items with low stock"),
    Example("low_stock", "stock kam hai"),
    Example("low_stock", "items almost finished"),
    Example("low_stock", "products below threshold"),
    Example("low_stock", "show low inventory"),
    # pending_payments
    Example("pending_payments", "Show pending payments"),
    Example("pending_payments", "Who has unpaid dues"),
    Example("pending_payments", "Udhaar reminders"),
    Example("pending_payments", "payment due list"),
    Example("pending_payments", "pending dues dikhao"),
    Example("pending_payments", "who still has to pay"),
    Example("pending_payments", "unpaid invoices"),
    Example("pending_payments", "payment reminder list"),
    Example("pending_payments", "dues pending today"),
    Example("pending_payments", "customer balance due"),
]


def tokenize(text: str) -> list[str]:
    normalized = text.lower()
    normalized = re.sub(r"[^a-z0-9\s.]+", " ", normalized)
    tokens = re.findall(r"[a-z0-9.]+", normalized)
    expanded: list[str] = []
    for token in tokens:
      if token.isdigit():
        expanded.append(f"num_{token}")
      else:
        expanded.append(token)
    return expanded


def train(examples: list[Example]) -> dict[str, object]:
    label_docs: dict[str, list[list[str]]] = defaultdict(list)
    vocab: set[str] = set()

    for example in examples:
        tokens = tokenize(example.text)
        label_docs[example.label].append(tokens)
        vocab.update(tokens)

    model_classes: dict[str, dict[str, object]] = {}
    total_docs = len(examples)
    label_count = len(label_docs)

    for label, docs in sorted(label_docs.items()):
        token_counts: Counter[str] = Counter()
        for tokens in docs:
            token_counts.update(tokens)
        total_tokens = sum(token_counts.values())
        model_classes[label] = {
            "prior": len(docs) / total_docs,
            "totalTokens": total_tokens,
            "tokenCounts": dict(sorted(token_counts.items())),
        }

    return {
        "version": 1,
        "algorithm": "multinomial_naive_bayes",
        "alpha": ALPHA,
        "vocabSize": len(vocab),
        "labelCount": label_count,
        "classes": model_classes,
        "examples": [
            {"label": example.label, "text": example.text}
            for example in examples
        ],
    }


def main() -> None:
    model = train(EXAMPLES)
    MODEL_PATH.write_text(json.dumps(model, indent=2, sort_keys=True), encoding="utf-8")
    print(f"Wrote {MODEL_PATH}")


if __name__ == "__main__":
    main()
