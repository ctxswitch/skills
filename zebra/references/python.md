# Python

Things that fail in Python with no code added. Nothing else in the language is evidenced by construction.

- An HTTP call or `subprocess.run` without `timeout=` hangs the worker. The reflex is to omit it.
- A file, lock, session, transaction, or subprocess opened outside `with` or `finally` leaks on the error path.
- `asyncio.create_task(...)` with a dropped reference fails silently or outlives its owner. Await it, or use `TaskGroup` on 3.11+.
- Calling an async function does not run it. Await it.
- Blocking I/O inside an async function stalls the loop. Use an async client or an executor.
- A mutable default argument shares state across calls. Default to `None` and construct inside.
- `except:` or `except Exception:` that logs and continues is silent failure. Catch the narrowest exception you can handle, or do not catch.
- Swallowing `asyncio.CancelledError`, `KeyboardInterrupt`, or `SystemExit` hangs shutdown. Clean up in `finally` and let them propagate.
- Re-raise across a boundary once, with context: `raise ConfigError(f"failed to read {path}") from exc`. Bare `raise` keeps the traceback. Not at every layer.
- JSON and API payloads arrive as `dict[str, Any]`. Validate into a typed shape at the single parse point, then trust it inward.
- `shell=True` with dynamic input is a shell injection on the line that writes it. Use an argument list.
