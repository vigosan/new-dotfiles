# Backend Development Guidelines

## Node.js 2025 Patterns

### Core Principles
- ESM as primary module system
- `node:` prefix for built-ins (prevents conflicts)
- Top-level await for init
- async/await with comprehensive error handling
- `Promise.all()` for parallel operations

### Performance & Tooling
- Worker Threads for CPU-intensive tasks
- Performance hooks for monitoring
- Web Streams for processing
- `--watch` mode for auto-reload
- `--env-file` for environment management
- Built-in test runner
- Dynamic imports for conditional loading

### Error Handling & Security
- Structured error classes with metadata (timestamp, context, status)
- Node.js permission model for access control
- Prefer built-in APIs over external deps

## JSON:API Standard

### Core Structure
**Success**: `{data: {id, type, attributes}, meta?: {}}`
**Collection**: `{data: [{id, type, attributes}], meta: {count, page, totalPages}}`
**Error**: `{errors: [{status, title, detail, source: {pointer}}]}`

### Implementation
```typescript
// JsonApiBuilder utility
export class JsonApiBuilder {
  static success<T>(data: T, meta?: Record<string, any>) {
    return { data, ...(meta && { meta }) };
  }
  static error(status: number, title: string, detail?: string) {
    return { errors: [{ status: status.toString(), title, detail }] };
  }
  static resource(id: string, type: string, attributes: Record<string, any>) {
    return { id, type, attributes };
  }
}
```

### Guidelines
- Consistent response structure (all endpoints)
- Resource-oriented (type, id, attributes)
- Kebab-case types ("espresso-shot", "user-profile")
- String IDs always
- Include metadata (pagination, timing, context)
- Source pointers for field-specific errors

### Benefits
Client predictability, error consistency, tooling support, self-documenting

## Repository Pattern

### Benefits
Independent development, rapid iterations, scenario simulation, predictable testing

### Guidelines
- Interface-first design (contracts before implementation)
- Consistent methods across implementations
- Mock parity with real API (including errors)
- Full TypeScript coverage
- Single responsibility (one repo per domain/entity)

### Testing Strategy
- Unit tests with mocks (predictable data)
- Integration tests (real API)
- Error scenarios (failures, edge cases)
- Performance testing (timeouts, slow responses)