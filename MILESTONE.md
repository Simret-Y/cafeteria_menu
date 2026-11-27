# Milestone 1 — Cafeteria App

## What is done and what is not

### Done
- **All screens reachable**: Login, Register, Customer Home (menu browse), Menu Details, Cart,
  Checkout, Order Tracking, Staff Dashboard, QR Scanner, Manager Dashboard,
  Recommendations — all wired through go_router with role-based redirect guards.
- **Feature-first structure**: `lib/core/` (router, theme, validators, widgets) and
  `lib/features/<feature>/{domain,data,presentation}` for auth, cart, menu, orders,
  manager, staff, qr_scanner, and recommendations.
- **State in providers**: Every mutable state lives in Riverpod `Notifier` / `Provider`.
  Widgets observe but never own state.
- **Freezed models**: `MenuItem`, `CartItem`, `CheckoutOrder`, `CartState`, `Order` are all
  immutable Freezed entities behind abstract repository interfaces.
- **In-memory repositories**: `InMemoryMenuRepository`, `InMemoryCartRepository`,
  `InMemoryOrderRepository` — no server or persistence for Milestone 1.
- **Order tracking**: `OrderNotifier` converts `CheckoutOrder` → `Order`, tracks status
  (`placed → preparing → ready → completed`). `OrderTrackingScreen` shows an animated
  status stepper, estimated wait time, order summary, and QR placeholder.
- **Tests**: 38 unit and widget tests (18 new order tests by Tinsae, plus existing tests
  by Meresiet and Simret).
- **Analyzer**: `flutter analyze --fatal-infos` — No issues found.

### Not done / deferred to Milestone 2
- Real authentication (Firebase Auth) — using in-memory role selection.
- Real-time order status push from staff to customer — simulated with in-memory state.
- Gemini API recommendations — placeholder screen only.
- QR code scanning — placeholder screen with custom-painted QR pattern.
- Payment gateway integration — "Pay at Counter" only.

---

## Pull requests authored and reviewed

### Simret Yemane
- **Authored**: PR #1 (project scaffold, go_router, core navigation), PR #2 (architecture refactor)
- **Reviewed**: PR #3 (Meresiet's customer interface)

### Meresiet Zekiros
- **Authored**: PR #3 (login/register screens, customer home, menu details, cart, checkout,
  Riverpod providers, 20 widget/unit tests)
- **Reviewed**: PR #1, PR #2

### Tinsae Aysheshim
- **Authored**: PR #4 (Order model + repository, OrderNotifier, Order Tracking screen, 18 unit tests)
- **Reviewed**: PR #3

### Yared Gebre
- Stub screens (staff dashboard, QR scanner, manager dashboard, recommendations) included via PR #3.

---

## Self-score

| Criterion | Points | Evidence |
|-----------|--------|----------|
| All proposed screens present and navigable | 3/3 | All 11 screens reachable via go_router; bottom nav switches by role; detail routes with parameters (`/menu-details`). |
| Feature-first structure; state in providers, not widgets | 2/2 | `lib/features/<feature>/{domain,data,presentation}` enforced. Widgets only call `ref.watch`/`ref.read`. |
| Tests present; analyzer and tests clean | 1/1 | `flutter analyze --fatal-infos`: No issues. `flutter test`: 38/38 pass. Output pasted below. |
| Repository hygiene | 1/1 | 4 feature branches, 4 pull requests, readable conventional-commit messages, `project.yaml` up to date. |
| Individual oral check | —/3 | Assessed in lab. |
| **Total (self-assessed)** | **7/7** | (oral check excluded) |

---

## Analyzer and test output (tagged commit)

```
$ flutter analyze --fatal-infos
Analyzing cafeteria_menu_repo...
No issues found! (ran in 14.8s)

$ flutter test
00:06 +38: All tests passed!
```

---

## One thing we will change before Milestone 2

We will replace the in-memory `InMemoryOrderRepository` with a **Firebase Firestore**
implementation so that order status updates from staff propagate to the customer's
Order Tracking screen in real time, without needing both users on the same device.
