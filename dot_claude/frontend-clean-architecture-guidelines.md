# Frontend Clean Architecture

## Overview

Hexagonal Architecture (Ports & Adapters) for React/TypeScript. Dependencies flow **inward**: UI → Application → Domain.

**Reference**: [bespoyasov/frontend-clean-architecture](https://github.com/bespoyasov/frontend-clean-architecture), [Article](https://dev.to/bespoyasov/clean-architecture-on-frontend-4311)

## Layers

```
UI (React)     → Uses application hooks
  ↓
Application    → Defines ports (interfaces), implements use cases
  ↓
Services       → Adapters implementing ports (API, storage, etc.)
  ↓
Domain         → Pure business logic (zero dependencies)
```

## Directory Structure

```
src/
├── shared-kernel.d.ts     # Global types (Email, UniqueId, PriceCents)
├── domain/                # Pure entities + business logic
│   ├── user.ts
│   ├── order.ts
│   └── cart.ts
├── application/           # Use cases + port interfaces
│   ├── ports.ts          # Service contracts
│   ├── orderProducts.ts
│   └── addToCart.ts
├── services/              # Port implementations
│   ├── paymentAdapter.ts
│   ├── storageAdapter.ts
│   └── api.ts
├── ui/                    # Feature-based components
│   ├── Buy/
│   │   ├── Buy.tsx
│   │   ├── Buy.module.css
│   │   └── index.ts
│   └── Cart/
└── lib/                   # Shared utilities
```

## Domain Layer

**Pure business logic** - zero external dependencies, framework-agnostic.

```typescript
// domain/user.ts
export type User = {
  id: UniqueId;
  name: string;
  email: Email;
  preferences: Ingredient[];
};

// Pure functions only
export function hasAllergy(user: User, ingredient: Ingredient): boolean {
  return user.allergies.includes(ingredient);
}

// domain/cart.ts
export function addProduct(cart: Cart, product: Product): Cart {
  return { ...cart, products: [...cart.products, product] }; // Immutable
}
```

**Rules**: No React, no side effects, no imports from other layers, only pure functions.

## Application Layer

Orchestrates domain logic via **ports** (interfaces). Use cases implemented as React hooks.

```typescript
// application/ports.ts - Define contracts
export interface PaymentService {
  tryPay(amount: PriceCents): Promise<boolean>;
}

export interface NotificationService {
  notify(message: string): void;
}

// application/orderProducts.ts - Use case
import { createOrder } from "../domain/order";

export function useOrderProducts() {
  // Inject services via hooks (DI)
  const payment = usePayment();
  const notifier = useNotifier();
  const storage = useOrdersStorage();

  async function orderProducts(user: User, cart: Cart) {
    const order = createOrder(user, cart); // Domain logic

    const paid = await payment.tryPay(order.total); // Via port
    if (!paid) return notifier.notify("Payment failed");

    storage.updateOrders([...storage.orders, order]);
  }

  return { orderProducts };
}
```

## Services Layer

**Adapters** implementing ports. Can use external libraries/frameworks.

```typescript
// services/paymentAdapter.ts
import { PaymentService } from "../application/ports";

export function usePayment(): PaymentService {
  return {
    async tryPay(amount: PriceCents) {
      return fetch('/api/payment', {
        method: 'POST',
        body: JSON.stringify({ amount })
      }).then(r => r.ok);
    }
  };
}

// services/notificationAdapter.ts
export function useNotifier(): NotificationService {
  return { notify: (msg) => window.alert(msg) };
}
```

**Naming**: `*Adapter.ts` for files, `*Service` for interface names.

## UI Layer

Feature-based components. Only depend on application layer (use cases).

```typescript
// ui/Buy/Buy.tsx
import { useOrderProducts } from "../../application/orderProducts";

export function Buy() {
  const { orderProducts } = useOrderProducts(); // Use case
  const { user } = useUserStorage();
  const { cart } = useCartStorage();

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    await orderProducts(user, cart); // Call use case
  }

  return <form onSubmit={handleSubmit}>...</form>;
}
```

**Rules**: No direct service imports, no business logic, only UI concerns.

## React Patterns

### Hooks as DI Container

```typescript
// Application hook "injects" dependencies
export function useFeature() {
  const service1 = useService1(); // Injected
  const service2 = useService2();

  function doSomething() {
    service1.method();
  }

  return { doSomething };
}
```

### Testable Use Cases (Advanced)

```typescript
// Extract logic for easier testing
type Dependencies = { payment: PaymentService; notifier: NotificationService };

export async function orderProducts(
  user: User,
  cart: Cart,
  deps: Dependencies
) {
  // Pure logic - easily testable
}

// Hook becomes thin adapter
export function useOrderProducts() {
  return (user: User, cart: Cart) =>
    orderProducts(user, cart, {
      payment: usePayment(),
      notifier: useNotifier()
    });
}
```

## Best Practices

### ✅ Do
- **Immutability in domain**: Always return new objects
- **Pure domain functions**: No side effects, no I/O
- **Feature-based UI**: Group by feature (`ui/Auth/`), not by type (`ui/components/`)
- **Ports in application**: Define interfaces where they're used
- **Type safety**: Use branded types (`type Email = string`)

### ❌ Don't
- Domain depends on React/external libs
- UI calls services directly (bypass application layer)
- Business logic in components
- Mutation in domain functions
- Mixing concerns across layers

## Testing

```typescript
// Domain - test pure functions
expect(addProduct(cart, product).products).toHaveLength(2);

// Application - mock ports
const mockPayment = { tryPay: vi.fn().mockResolvedValue(true) };
await orderProducts(user, cart, { payment: mockPayment });

// UI - mock use cases
vi.mock("../../application/orderProducts");
render(<Buy />);
```

## Migration Strategy

1. **New project**: Start with domain entities → define ports → create use cases → build adapters → add UI
2. **Existing project**: Extract domain logic → identify service boundaries → wrap APIs as adapters → refactor components incrementally

## SOLID & DIP

Clean Architecture embodies **Dependency Inversion Principle** (see [frontend-guidelines.md](frontend-guidelines.md) for SOLID):
- High-level (application) doesn't depend on low-level (services)
- Both depend on abstractions (ports)
- Services implement ports defined in application layer

## Key Takeaways

- **4 layers**: Domain (pure) → Application (orchestration) → Services (adapters) → UI (presentation)
- **Ports & Adapters**: Interfaces in application, implementations in services
- **React integration**: Hooks as DI, use cases as hooks
- **Testing**: Pure domain = easy tests, mockable ports = testable use cases
- **Start simple**: Add layers as needed, don't over-engineer
