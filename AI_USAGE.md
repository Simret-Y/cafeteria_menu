# AI Usage — Cafeteria App — Milestone 1

This file documents how each member used AI tools during Milestone 1.

---

## Member 1 — Simret Yitbarek

**AI tools used:** GitHub Copilot, ChatGPT

**What I used AI for:**
- Generating the initial `pubspec.yaml` dependency list for `flutter_riverpod`,
  `go_router`, and `freezed`.
- Drafting the go_router configuration (`app_router.dart`) and getting an example
  of a redirect guard based on auth state.
- Getting an explanation of `ProviderScope` placement in `main.dart`.

**What I did not use AI for:**
- Deciding the feature-first folder structure — this came from the instructor's requirement.
- Writing the `AppBottomNav` role-switching logic — written and debugged manually.
- Reviewing and merging teammates' pull requests.

**How I verified AI output:**
- Ran `flutter analyze` and `flutter test` after every AI-assisted edit to confirm
  there were no issues before committing.

---

## Member 2 — Meresiet Zekiros

**AI tools used:** GitHub Copilot, ChatGPT

**What I used AI for:**
- Scaffolding the `LoginScreen` and `RegisterScreen` form widgets with `TextFormField`
  and `GlobalKey<FormState>`.
- Getting examples of `SegmentedButton` usage for the role selector in the login form.
- Asking how to structure a `Notifier<T>` with derived state (for `CartState`).
- Generating placeholder stubs for teammate screens so the app could build end-to-end.

**What I did not use AI for:**
- Form validation logic in `FormValidators` — written from scratch.
- The `CustomerHomeScreen` category filter and search bar logic.
- Writing widget tests — test cases written manually; AI only consulted for
  `WidgetTester` API signatures.

**How I verified AI output:**
- Reviewed every generated snippet line by line before committing.
- All 20 widget and unit tests pass without modification from AI output.

---

## Member 3 — Tinsae Aysheshim

**AI tools used:** Antigravity (Google DeepMind), GitHub Copilot

**What I used AI for:**
- Generating the Freezed `Order` model and `OrderStatus` enum boilerplate.
- Asking for the correct `Notifier<List<Order>>` pattern in Riverpod 3.x.
- Scaffolding the `OrderTrackingScreen` layout (stepper, cards) — colours, animation,
  and QR `CustomPainter` logic customised manually afterwards.

**What I did not use AI for:**
- Designing the state flow between `CartNotifier` and `OrderNotifier`
  (`trackFromCheckout` via `addPostFrameCallback`) — reasoned through manually.
- Writing the 18 unit test cases — each assertion written from the specification.

**How I verified AI output:**
- `flutter analyze --fatal-infos`: No issues found.
- `flutter test test/order_tracking_test.dart`: 18/18 passed.
- Reviewed all generated code for correctness before committing.

---

## Member 4 — Yared Gebre

**AI tools used:** ChatGPT

**What I used AI for:**
- Getting starter code for the `StaffDashboardScreen`, `ManagerDashboardScreen`,
  `QrScannerScreen`, and `RecommendationsScreen` placeholder widgets.
- Asking how to use the shared `PlaceholderScreen` widget consistently across stubs.

**What I did not use AI for:**
- Deciding which screens are stubs vs. fully implemented — determined by the
  instructor's milestone guidance.
- Reviewing PR #4 (Tinsae's order tracking).

**How I verified AI output:**
- Confirmed all stub screens compile and are reachable via go_router by running
  `flutter test test/navigation_test.dart`.
