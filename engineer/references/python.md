# Python

Each row is code you would type by reflex. The reflex is wrong; write the third column instead.

| Reflex | Why it is wrong | Instead |
|---|---|---|
| `except Exception: log; continue` | Silent failure | The narrowest exception you can handle, or no catch. A top-level handler reports and exits. |
| `except X: raise Y(...)` without `from` | Loses the cause | `raise Y(...) from exc`; bare `raise` to rethrow |
| `except asyncio.CancelledError: pass` | Shutdown hangs | Clean up in `finally`, re-raise |
| `def f(x=[])` | State shared across calls | `x=None`, construct inside |
| `requests.get(url)`, `subprocess.run(cmd)` with no `timeout=` | Hangs the worker | `timeout=` |
| `subprocess.run(cmd, shell=True)` | Shell injection | Argument list, `check=True` |
| `random.choice` for a token or code | Predictable | `secrets` |
| `pickle.loads`, `yaml.load(s)`, `eval` on external data | Code execution | `json`, `yaml.safe_load`, an explicit parser |
| `verify=False` | Disables TLS | Remove it |
| `asyncio.create_task(coro)` with the handle dropped | Fails silently or outlives its owner | Await it, or `TaskGroup` on 3.11+ |
| A blocking call inside `async def` | Stalls the loop | An async client, or `run_in_executor` |
| `async def` because the framework allows it | Complexity nobody asked for | Synchronous unless the caller or framework requires async |
| `f = open(...)`, `conn = connect(...)` without `with` | Leaks on the error path | Context manager |
| Network, filesystem, or `basicConfig()` at import time | Import side effects; a library hijacks the app's logging | Behind a function or startup; `logging.getLogger(__name__)` only |
| `class FooProtocol(Protocol)` mirroring one class, for tests | An interface with one implementation | The concrete type |
| `cast(T, x)` to silence the checker | Hides a design problem | Fix it at the boundary; `cast` only with runtime evidence |
| `total: int = 0` on locals; `strict = true` added in a feature change | Noise; scope creep | Annotate boundaries only |
| `utils.py`, `helpers.py`, `common.py` | SKILL rule, no exception for repos that have one | Put it with its owner |
| A docstring on every new public function in a module with none | Density rule | Where the module already has them |
| `@pytest.fixture(autouse=True)` | Hidden global behavior | Explicit fixtures |
| `mock.patch("pkg.thing")` where it is defined | Patch does not take | Patch where the name is looked up; `autospec=True` |
| Adding ruff, black, mypy, or a formatter in a feature change | Tool churn | A separate change |
| Hand-editing `uv.lock`, `poetry.lock`, `requirements.txt` | Regenerated over | The repo's tool |
