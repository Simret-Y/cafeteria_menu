# Milestone 1 — Cafeteria App

## What is done and what is not

### Done
- **All screens reachable**: Login, Register, Customer Home (menu browse), Menu Details, Cart,
  Checkout, Order Tracking, Staff Dashboard, QR Scanner, Manager Dashboard,
  Recommendations — all wired through go_router with role-based redirect guards.
- **Feature-first structure**: `lib/core/` (router, theme, validators, widgets) and
  `lib/features/<feature>/{domain,data,presentation}` for auth, cart, menu, orders,
  manager, staff, qr_scanner, and recommendations.
- **State in providers, not widgets**: Every mutable state lives in Riverpod `Notifier` /
  `Provider`. Widgets only call `ref.watch` / `ref.read`.
- **Freezed models**: `MenuItem`, `CartItem`, `CheckoutOrder`, `CartState`, `Order` are all
  immutable Freezed entities behind abstract repository interfaces.
- **In-memory repositories**: `InMemoryMenuRepository`, `InMemoryCartRepository`,
  `InMemoryOrderRepository` — no server or persistence for Milestone 1.
- **Prototype authentication + role selection**: `AuthNotifier` (Riverpod) tracks the
  selected role; go_router redirect guard sends unauthenticated users to `/login`;
  Login screen exposes one-tap demo buttons for all three roles.
- **Full navigation**: `AppBottomNav` (role-aware) shows customer, staff, or manager
  destinations; go_router routes all 11 screens with named routes.
- **Order tracking**: `OrderNotifier` converts `CheckoutOrder` to `Order`, tracks status
  (`placed -> preparing -> ready -> completed`). `OrderTrackingScreen` shows an animated
  status stepper, estimated wait time, order summary, and QR placeholder.
- **Tests**: 43 unit and widget tests (18 order tests — Tinsae; login-validation and
  menu-display tests — Meresiet; navigation test — Simret; 5 staff widget tests — Yared).
- **Analyzer**: `flutter analyze --fatal-infos` — No issues found.
- **`project.yaml`**: All four members listed with student IDs, emails, and GitHub usernames.

### Not done / deferred to Milestone 2
- Real authentication (Firebase Auth) — using in-memory role selection.
- Real-time order status push from staff to customer — simulated with in-memory state.
- Gemini API recommendations — placeholder screen only.
- QR code scanning with camera — placeholder screen with custom-painted QR pattern.
- Payment gateway integration — "Pay at Counter" only.
- Complete menu CRUD in Manager Dashboard — interface shown, write operations deferred.

---

## Pull requests authored and reviewed

### Simret Yitbarek
- **Authored**: PR #1 (project scaffold, go_router, ProviderScope, core navigation),
  PR #2 (architecture refactor — feature-first folder structure)
- **Reviewed**: PR #3 (Meresiet's customer interface), PR #4 (Tinsae's order tracking)

### Meresiet Zekiros
- **Authored**: PR #3 (login/register screens, customer home, menu details, cart, checkout,
  Riverpod providers, 20 widget/unit tests, auth integration stubs for Tinsae)
- **Reviewed**: PR #1, PR #2

### Tinsae Aysheshim
- **Authored**: PR #4 (Order Freezed model, OrderStatus enum, OrderRepository interface,
  InMemoryOrderRepository, OrderNotifier providers, Order Tracking screen full UI,
  18 unit tests, MILESTONE.md)
- **Reviewed**: PR #3

### Yared Gebre
- **Authored**: PR #5 (Staff Dashboard with order status management, Manager Dashboard
  with menu controls prototype, 5 staff widget/unit tests)
- **Reviewed**: PR #4 (Tinsae's order tracking)

---

## Self-score

| Criterion | Points | Evidence |
|-----------|--------|----------|
| All proposed screens present and navigable | 3/3 | All 11 screens reachable via go_router; bottom nav switches by role; `/menu-details` detail route with item parameter. |
| Feature-first structure; state in providers, not widgets | 2/2 | `lib/features/<feature>/{domain,data,presentation}` enforced across all features. No `setState` for app state; all state in Riverpod Notifiers. |
| Tests present; analyzer and tests clean | 1/1 | `flutter analyze --fatal-infos`: No issues. `flutter test`: 43/43 pass. Output pasted below. |
| Repository hygiene | 1/1 | 5 feature branches merged via 5 pull requests; conventional commit messages; `project.yaml` lists all 4 members; `proposal` tag present. |
| Individual oral check | -/3 | Assessed in lab session. |
| **Total (self-assessed)** | **7/7** | (oral check excluded from self-score) |

---

## Analyzer and test output (tagged commit `m1`)

```
$ flutter analyze --fatal-infos
Analyzing cafeteria_menu_repo...
No issues found! (ran in 14.8s)

$ flutter test
00:00 +1: InMemoryOrderRepository getAllOrders returns empty list initially
00:00 +2: InMemoryOrderRepository addOrder persists an order and returns it
00:00 +3: InMemoryOrderRepository addOrder ignores duplicate orderId
00:00 +4: InMemoryOrderRepository getOrderById returns correct order
00:00 +5: InMemoryOrderRepository getOrderById returns null for unknown id
00:00 +6: InMemoryOrderRepository updateStatus changes status and returns updated order
00:00 +7: InMemoryOrderRepository updateStatus throws ArgumentError for unknown id
00:00 +8: OrderStatus extension label returns human-readable string for each status
00:00 +9: OrderStatus extension stepIndex is ascending for active statuses
00:00 +10: OrderStatus extension stepIndex is -1 for cancelled
00:00 +11: OrderStatus extension isActive is true for placed, preparing, ready
00:00 +12: OrderStatus extension isActive is false for completed and cancelled
00:00 +13: OrderNotifier (Riverpod) initial state is empty
00:00 +14: OrderNotifier (Riverpod) trackFromCheckout adds an order derived from CheckoutOrder
00:00 +15: OrderNotifier (Riverpod) trackFromCheckout is idempotent for the same orderId
00:00 +16: OrderNotifier (Riverpod) updateStatus changes status in Riverpod state
00:00 +17: OrderNotifier (Riverpod) latestOrderProvider returns most-recently added order
00:00 +18: OrderNotifier (Riverpod) activeOrdersProvider excludes completed orders
00:01 +19: StaffDashboardScreen widget tests shows empty-state message when there are no orders
00:01 +20: StaffDashboardScreen widget tests shows order card when an order is tracked
00:01 +21: StaffDashboardScreen widget tests ManagerDashboardScreen renders menu management section
00:01 +22: StaffDashboardScreen widget tests OrderStatus.placed.isActive is true
00:01 +23: StaffDashboardScreen widget tests OrderStatus.completed.isActive is false
00:06 +43: All tests passed!
```

---

## One thing we will change before Milestone 2

We will replace the in-memory `InMemoryOrderRepository` with a **Firebase Firestore**
implementation so that order status updates made by staff on the Staff Dashboard
propagate to the customer's Order Tracking screen in real time — across devices, not
just within the same running app instance.
