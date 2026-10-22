# Go

Things that fail in Go with no code added. Nothing else in the language is evidenced by construction.

- `http.Client{}` has no timeout, and the zero value is what gets written. Set one or use the client the repo configures.
- A response body or file opened on an added line leaks without its `defer` close. A ticker or timer started on an added line leaks without its stop.
- A goroutine started on an added line with no exit path leaks. When goroutines can fail, use `errgroup.Group` so the failure is observed. An unbounded `go` in a loop over request input exhausts resources.
- A mutex held across network or disk I/O, a channel send, or an external call stalls every other holder.
- Branching on errors by string comparison breaks on the first message change. Use `errors.Is` and `errors.As`.
- Wrap an error once, at the call that has a name: `fmt.Errorf("read config %s: %w", path, err)`. Not at every layer.
- A nil map write, a nil-receiver method call, or an out-of-range index panics. That panic is the detection. Add a check only where the absence is produced.
- `exec.Command("sh", "-c", ...)` with dynamic input is a shell injection on the line that writes it. Use `exec.Command(name, args...)`.
