# Go

Each row is code you would type by reflex. The reflex is wrong; write the third column instead.

| Reflex | Why it is wrong | Instead |
|---|---|---|
| `http.Client{}`, `http.Get(url)` | No timeout. A stalled upstream hangs the worker. | The client the repo configures, or `http.Client{Timeout: ...}` plus a context deadline |
| `math/rand` for a token, key, nonce, salt, or session ID | Predictable | `crypto/rand` |
| `a == b` on a secret or token | Leaks timing | `subtle.ConstantTimeCompare` |
| `exec.Command("sh", "-c", s)` with dynamic input | Shell injection | `exec.Command(name, args...)` |
| `fmt.Sprintf("SELECT ... %s", v)` | SQL injection | Parameters |
| `tls.Config{InsecureSkipVerify: true}` | Disables verification in a production path | Fix the certificate chain |
| `strings.Contains(err.Error(), "...")` | Breaks on the first message change | `errors.Is`, `errors.As` |
| `var ErrFoo = errors.New(...)` for every failure | Callers never branch on it | A sentinel only where a caller does `errors.Is` |
| `fmt.Errorf("...: %w", err)` at every layer | Redundant context | Wrap once, at the call that has a name: `fmt.Errorf("read config %s: %w", path, err)` |
| `go func() { ... }()` with no context or done channel | Leaks on shutdown | An exit path through context or a channel, and bounded fan-out |
| `for { ...; retry }` | Spins forever | Bound by count and by context |
| `mu.Lock()` then a network or disk call | Blocks every other holder | Release before I/O |
| `resp, err := c.Do(req)` with no `Close` | File descriptor leak | `defer resp.Body.Close()` |
| `time.NewTicker` or `time.AfterFunc` with no `Stop` | Leak | `defer t.Stop()` |
| `type Fooer interface { ... }` with one implementation, to cross a package | An abstraction with one implementation | Pass the concrete type that owns the behavior |
| An API that starts its own goroutine | Caller cannot control or cancel it | Synchronous API; the caller adds concurrency |
| `interface{}` in new code | Old spelling | `any` |
| `*SomeInterface` | Pointer to interface | The interface |
| `// Foo does foo.` on a new export in a file with no doc comments | Density rule | Doc comments where the file already has them |
| `testify` in a new package of a repo that tests with `testing` | Mixes assertion styles | The repo's existing framework |
| `errgroup` added to a repo that does not import `x/sync` | Dependency for one call | `sync.WaitGroup` plus an error channel, or whatever the repo already does |
| Editing `*.pb.go` or a `gen/` file | Regenerated over | Regenerate from source |
