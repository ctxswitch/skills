#!/usr/bin/env python3
"""Derive the cross-scope term graph from a .context.md hierarchy.

Reads every .context.md beneath a root and reports which scopes own which terms,
which scopes reference terms they do not own, and where ownership is divided or
absent. Nothing is written; the graph is recomputed on demand rather than stored,
so it cannot drift from the files it comes from.

    graph.py [root] [--json]
"""

import collections
import glob
import json
import os
import re
import sys

DEFINITION = re.compile(r"^\*\*([^*]+)\*\*:")
MENTION = re.compile(r"\*\*([^*]+)\*\*")
SKIP = ("/node_modules/", "/.git/", "/vendor/", "/dist/", "/build/")


def canon(text):
    """Lowercase a term or mention and drop trailing punctuation and possessives."""
    return re.sub(r"['’]s$", "", text.strip().lower().rstrip(".,;:!?"))


def surface_forms(term):
    """Every spelling a scope might reasonably use for a term it does not own.

    Blind stemming folds "References" to "referenc"; enumerating from the defined
    term instead means a mention only ever resolves to a term that exists.
    """
    base = canon(term)
    forms = {base, base + "s", base + "es", base + "'s"}
    if base.endswith("y"):
        forms.add(base[:-1] + "ies")
    if base.endswith("ies"):
        forms.add(base[:-3] + "y")
    if base.endswith("es"):
        forms.add(base[:-2])
    if base.endswith("s"):
        forms.add(base[:-1])
    return forms


def is_term(mention):
    """Example-dialogue speakers and prose emphasis are bold but are not terms."""
    return not mention.endswith(":") and any(c.isupper() for c in mention)


def load(root):
    """Return (scopes, owners, mentions)."""
    paths = [
        p
        for p in glob.glob(os.path.join(root, "**", ".context.md"), recursive=True)
        if not any(s in p for s in SKIP)
    ]
    scopes, owners, mentions = [], collections.defaultdict(list), {}

    for path in sorted(paths):
        scope = os.path.dirname(os.path.relpath(path, root)) or "."
        scopes.append(scope)
        defined, used, section = [], [], None
        for line in open(path, encoding="utf-8"):
            if line.startswith("## "):
                section = line[3:].strip()
            match = DEFINITION.match(line)
            if match:
                term = match.group(1).strip()
                defined.append(term)
                owners[term].append(scope)
                continue
            # a term named to steer away from is an anti-dependency, and dialogue
            # re-uses vocabulary to illustrate rather than to claim coupling
            if line.startswith("_Avoid_") or section == "Example dialogue":
                continue
            used.extend(m.strip() for m in MENTION.findall(line) if is_term(m.strip()))
        mentions[scope] = (defined, used)

    return scopes, dict(owners), mentions


def build(owners, mentions):
    """Resolve every mention to its owning scope and return the edge counter."""
    by_form = collections.defaultdict(set)
    claimed = collections.defaultdict(set)
    for term, scs in owners.items():
        for form in surface_forms(term):
            by_form[form].update(scs)
            claimed[form].add(term)

    edges, unowned = collections.Counter(), collections.Counter()
    for scope, (_, used) in mentions.items():
        for mention in used:
            key = canon(mention)
            if key not in by_form:
                unowned[mention] += 1
                continue
            for target in by_form[key]:
                if target != scope:
                    edges[(scope, target)] += 1

    collisions = {k: sorted(v) for k, v in claimed.items() if len(v) > 1}
    return edges, unowned, collisions


def relation(a, b):
    """How two owning scopes sit relative to each other in the tree."""
    if a == b:
        return "same"
    if a == "." or b == "." or a.startswith(b + "/") or b.startswith(a + "/"):
        return "lineal"
    if os.path.dirname(a) == os.path.dirname(b):
        return "sibling"
    return "cross-tree"


def analyse(root):
    scopes, owners, mentions = load(root)
    edges, unowned, collisions = build(owners, mentions)

    fan_in, fan_out = collections.Counter(), collections.Counter()
    for source, target in edges:
        fan_out[source] += 1
        fan_in[target] += 1

    mutual, seen = [], set()
    for source, target in edges:
        if (target, source) in edges and (target, source) not in seen:
            seen.add((source, target))
            mutual.append([source, target])

    divided = []
    for term, scs in owners.items():
        if len(scs) < 2:
            continue
        kinds = {relation(a, b) for a in scs for b in scs if a != b}
        divided.append(
            {
                "term": term,
                "scopes": sorted(set(scs)),
                # cross-tree ownership is the class review's placement checks miss
                "relation": "cross-tree" if "cross-tree" in kinds else sorted(kinds)[0],
            }
        )

    counts = {s: len(mentions[s][0]) for s in scopes}
    connected = set(fan_in) | set(fan_out)

    return {
        "root": root,
        "scopes": len(scopes),
        "terms": len(owners),
        "edges": [
            {"from": s, "to": t, "weight": n} for (s, t), n in sorted(edges.items())
        ],
        "fan_in": fan_in.most_common(),
        "fan_out": fan_out.most_common(),
        "mutual": sorted(mutual),
        "divided": sorted(divided, key=lambda d: d["term"]),
        "unowned": [{"term": t, "used_by": n} for t, n in unowned.most_common()],
        "terms_per_scope": sorted(counts.items(), key=lambda kv: -kv[1]),
        "isolated": sorted(s for s in scopes if s not in connected),
        "normalization_collisions": collisions,
    }


def report(g):
    def section(title, rows):
        print(f"\n=== {title} ===")
        for row in rows or ["  (none)"]:
            print(row)

    counts = [n for _, n in g["terms_per_scope"]]
    median = sorted(counts)[len(counts) // 2] if counts else 0
    print(
        f"{g['scopes']} scopes, {g['terms']} terms, {len(g['edges'])} cross-scope edges"
        f" (median {median} terms/scope)"
    )

    section(
        "divided ownership — one term, several scopes",
        [
            f"  {d['relation']:10s}  {d['term']}\n              {', '.join(d['scopes'])}"
            for d in g["divided"]
        ],
    )
    section(
        "unowned vocabulary — referenced, defined nowhere",
        [f"  {u['used_by']:3d}  {u['term']}" for u in g["unowned"]],
    )
    section(
        "fan-in — scopes others must change around",
        [f"  {n:3d}  {s}" for s, n in g["fan_in"][:10]],
    )
    section(
        "fan-out — scopes reaching into others",
        [f"  {n:3d}  {s}" for s, n in g["fan_out"][:10]],
    )
    section("mutual — neither scope changes alone", [f"  {a}  <->  {b}" for a, b in g["mutual"]])
    section(
        "concentration — terms per scope",
        [f"  {n:3d}  {s}" for s, n in g["terms_per_scope"][:10]],
    )
    section("isolated — no inbound or outbound reference", [f"  {s}" for s in g["isolated"]])

    if g["normalization_collisions"]:
        section(
            "normalization collisions — distinct terms folding together",
            [f"  {k}: {', '.join(v)}" for k, v in g["normalization_collisions"].items()],
        )


if __name__ == "__main__":
    argv = [a for a in sys.argv[1:] if a != "--json"]
    graph = analyse(os.path.abspath(argv[0] if argv else "."))
    if "--json" in sys.argv[1:]:
        print(json.dumps(graph, indent=2))
    else:
        report(graph)
