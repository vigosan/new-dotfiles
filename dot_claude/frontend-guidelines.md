# Frontend Development Guidelines

## React 2025 Patterns

### Optimistic UI with useOptimistic
- Assume success, update UI immediately
- Combine with startTransition
- Pure update functions (no side effects)
- Visual feedback for optimistic items
- Handle failures with fallback

### Dependency Inversion & Testing
- High-level ≠ depend on low-level (both depend on abstractions)
- Decouple data fetching from rendering
- Inject through props/context (avoid direct imports)
- Design for testability

### Component Composition

#### Patterns
- **Compound Components**: Share state via context
- **Context-Based**: Granular contexts + custom hooks
- **Render Props**: Inversion of control
- **Component Injection**: Polymorphic via props
- **Layered Architecture**: Tokens → Primitives → Shared → Product-specific → Specialized

#### Guidelines
- Single responsibility
- Inversion of control
- Context for coordination
- Hooks for reusability
- Flexible APIs with sensible defaults

## Preferred Stack

### Testing
- **Runner**: Vitest (not Jest)
- **Library**: React Testing Library + @testing-library/jest-dom
- **Interactions**: @testing-library/user-event
- **Utils**: Custom renderWithProviders wrapper
- **Mocking**: vi.mock()

### Styling
- **Framework**: Tailwind CSS v4+
- **Plugin**: @tailwindcss/vite
- **Utilities**: tailwind-merge

### Data & Routing
- **Data**: TanStack Query v5 (not fetch)
- **Router**: TanStack Router (not React Router) - type-safe
- **State**: Domain-specific contexts + custom hooks

### Architecture
```
src/
├── components/  # Reusable UI
├── contexts/    # Providers
├── hooks/       # Data fetching, logic
├── services/    # API clients
├── types/       # TypeScript
├── utils/       # Pure functions
├── pages/       # Page components
├── test/        # Test utils
└── locales/     # i18n
```

## SOLID Principles

### Single Responsibility (SRP)
**Rule**: One reason to change per component

**Violation signals**: "and" in description, multiple change reasons, large prop interfaces, mixed concerns

**Pattern**: Layered architecture
```typescript
// Data Layer (hooks)
const useBooks = () => { /* fetch logic */ };

// Presentation (pure)
const BookList = ({ books, onBookClick }) => { /* render only */ };

// Container (orchestration)
const BookListContainer = () => {
  const { books } = useBooks();
  return <BookList books={books} onBookClick={handleClick} />;
};
```

### Open-Closed Principle (OCP)
**Rule**: Open for extension, closed for modification

```typescript
// ❌ VIOLATES: Modifying for new types
const Book = ({ type, onClickFree, onClickPremium }) => {
  return <div>{type === "Premium" && <button onClick={onClickPremium}>...</button>}</div>;
};

// ✅ FOLLOWS: Extensible via composition
const Book = ({ title, image, children }) => (
  <div><img src={image} /><h3>{title}</h3>{children}</div>
);

// Extend without modifying
const PremiumBook = ({ title, image, onAddToCart }) => (
  <Book title={title} image={image}>
    <button onClick={onAddToCart}>Add to cart</button>
  </Book>
);
```

**Strategies**: children prop, render props, HOCs, compound components

### Liskov Substitution (LSP)
**Rule**: Child components substitutable for parent

```typescript
interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode;
}

const Button = ({ children, className = "", ...props }: ButtonProps) => (
  <button className={`btn ${className}`} {...props}>{children}</button>
);

// ✅ LSP COMPLIANT: DangerButton can substitute Button
const DangerButton = ({ children, className = "", ...props }: ButtonProps) => (
  <button className={`btn btn-danger ${className}`} {...props}>{children}</button>
);
```

**Guidelines**: Same interface, preserve behavior, extend don't restrict

### Interface Segregation (ISP)
**Rule**: Components shouldn't depend on unused interfaces

```typescript
// ❌ VIOLATES: Fat interface
interface BookCardProps {
  book: Book;
  onEdit: () => void;    // Not always used
  onDelete: () => void;  // Not always used
  showActions: boolean;  // Not always needed
}

// ✅ FOLLOWS: Minimal interfaces
const BookTitle = ({ title }: { title: string }) => <h3>{title}</h3>;
const BookImage = ({ src, alt }: { src: string; alt: string }) => <img src={src} alt={alt} />;

const BookCard = ({ title, image, actions }: {
  title: string;
  image: string;
  actions?: ReactNode;
}) => (
  <div>
    <BookImage src={image} alt={title} />
    <BookTitle title={title} />
    {actions}
  </div>
);
```

**Strategies**: Pass specific props (not entire objects), split fat interfaces, use composition

### Dependency Inversion (DIP)
**Rule**: Depend on abstractions, not implementations

```typescript
// ❌ VIOLATES: Direct coupling
const UserList = () => {
  const [users, setUsers] = useState([]);
  useEffect(() => {
    fetch('/api/users').then(res => res.json()).then(setUsers);
  }, []);
  return <div>{users.map(u => <UserCard key={u.id} user={u} />)}</div>;
};

// ✅ FOLLOWS: Abstraction layer
interface UserRepository {
  getUsers(): Promise<User[]>;
}

const useUsers = (repository: UserRepository) => {
  const [users, setUsers] = useState<User[]>([]);
  useEffect(() => { repository.getUsers().then(setUsers); }, [repository]);
  return users;
};

const UserList = ({ userRepository }: { userRepository: UserRepository }) => {
  const users = useUsers(userRepository);
  return <div>{users.map(u => <UserCard key={u.id} user={u} />)}</div>;
};

// Implementations
class ApiUserRepository implements UserRepository {
  async getUsers() { return fetch('/api/users').then(r => r.json()); }
}
class MockUserRepository implements UserRepository {
  async getUsers() { return [{ id: 1, name: 'Test' }]; }
}
```

**Patterns**: Inject via props, context for global deps, repository pattern

## SOLID Benefits
- **Maintainability**: Easy to understand/modify, safe replacements, minimal dependencies
- **Testability**: Isolated concerns, mock dependencies, focused tests
- **Reusability**: Composable components, flexible interfaces, pluggable implementations
