
# Smart Integrated Cafeteria Menu and Order Management System

## 1. Title and one-sentence description

**Smart Integrated Cafeteria Menu and Order Management System**

An app that helps café customers browse daily menus, place orders in advance, and check estimated waiting times so that they can enjoy a faster and more convenient dining experience while helping café staff manage orders efficiently.

## 2. Group

| Name | Role |
|---|---|
| Simret Yitbarek | Team lead and application integration |
| Meresiet Zekiros | UI/UX and frontend development |
| Tinsae Aysheshim | Backend and database development |
| Yared Gebre | Testing, AI and device feature integration |

Roles represent initial responsibilities. All members will contribute to coding, integration, and testing across the application layers.

## 3. The problem

Customers visiting cafés and cafeterias often experience difficulties accessing updated menu information, knowing which meals are available, and estimating how long they will have to wait for their orders. During busy hours, customers may spend considerable time waiting in queues just to place an order and receive their food. They may also discover that a meal is unavailable only after reaching the counter.

Café staff, on the other hand, often manage incoming orders manually, making it difficult to organize multiple orders, monitor preparation progress, and communicate order status to customers. These manual processes can result in delays, confusion, and inefficient service, particularly during peak business hours.

Our proposed application addresses these problems by providing a digital menu, advance ordering, order tracking, and estimated waiting-time information. A mobile application is suitable because customers can access café services using their smartphones before arriving, while staff can manage orders and update their progress directly through the application.

To better understand the problem from both the customer and business perspectives, we identified two potential stakeholders: Henok, a café customer, and Abebe, a café owner. Henok represents customers who may benefit from easier access to updated menus, advance ordering, and reduced waiting times. Abebe represents café owners who need a more organized way to manage incoming orders, update menu availability, and monitor food preparation. Their perspectives highlight the importance of addressing both customer convenience and café operational efficiency. We intend to gather further feedback from both individuals during development to validate the proposed features and ensure that the application meets their needs.

## 4. Users

1. **Customers:** Browse available meals, view prices and descriptions, place orders in advance, track order progress, and receive meal suggestions. They may use the application whenever they visit the café.

2. **Café staff:** View incoming customer orders, manage preparation status, and verify completed orders through QR-code scanning. They will use the application throughout operating hours.

3. **Café managers:** Add, update, and remove menu items, manage meal availability, and monitor orders and café operations. They will use the application whenever operational information needs to be updated or monitored.

## 5. User stories

1. As a customer, I want to register and log in so that I can access the application's ordering services. (**must**)

2. As a customer, I want to browse the daily menu with meal descriptions, prices, images, and availability so that I can choose what I want to eat. (**must**)

3. As a customer, I want to add meals to my cart and place an order in advance so that I can reduce the time spent waiting at the café. (**must**)

4. As a customer, I want to track my order status and estimated waiting time so that I know when my food will be ready. (**must**)

5. As café staff, I want to view incoming orders and update their preparation status so that I can organize and process customer orders efficiently. (**must**)

6. As café staff, I want to scan customers' order QR codes so that I can verify and confirm food collection. (**should**)

7. As a customer, I want to receive AI-powered meal recommendations based on my preferences and available menu items so that I can discover meals that suit my interests. (**should**)

8. As a café manager, I want to add, edit, and remove menu items so that customers always see updated menu information. (**should**)

## 6. Screens

| Screen | Purpose | User stories |
|---|---|---|
| Login and Registration | Customer and staff authentication | 1 |
| Customer Home | Display menu highlights and navigation | 2, 7 |
| Menu Details | Show meal images, descriptions, prices, and availability | 2 |
| Cart and Checkout | Review selected meals and submit orders | 3 |
| Order Tracking | Display order status, estimated waiting time, and QR code | 4, 6 |
| Staff Dashboard | Display incoming orders and allow status updates | 5 |
| QR Scanner | Scan and verify customer pickup codes | 6 |
| AI Recommendations | Display personalized meal suggestions | 7 |
| Manager Dashboard | Manage menu items and their availability | 8 |

### Four main screen sketches

**1. Customer Home / Menu**

```text
+-----------------------------+
|          CAFE APP           |
|-----------------------------|
| Welcome, Customer!          |
|                             |
|       TODAY'S MENU          |
|                             |
| [Meal Image]                |
| Chicken Sandwich            |
| Price: 150 ETB              |
| Available                   |
|        [View Details]       |
|                             |
| [Meal Image]                |
| Pasta                       |
| Price: 180 ETB              |
|        [View Details]       |
|                             |
| [Home] [Orders] [Profile]   |
+-----------------------------+
```

**2. Cart and Checkout**

```text
+-----------------------------+
|          MY CART            |
|-----------------------------|
| Chicken Sandwich            |
| 150 ETB       [-] 1 [+]     |
|                             |
| Pasta                       |
| 180 ETB       [-] 1 [+]     |
|-----------------------------|
| Total: 330 ETB              |
|                             |
|       [PLACE ORDER]         |
+-----------------------------+
```

**3. Order Tracking**

```text
+-----------------------------+
|        ORDER TRACKING       |
|-----------------------------|
| Order #102                  |
|                             |
| Status: Preparing           |
|                             |
| Estimated Wait: 15 minutes  |
|                             |
| Order Progress              |
| [✓] Received                |
| [✓] Confirmed               |
| [ ] Preparing               |
| [ ] Ready for Pickup        |
|                             |
|       PICKUP QR CODE        |
|         [ QR CODE ]         |
+-----------------------------+
```

**4. Staff Dashboard**

```text
+-----------------------------+
|        STAFF DASHBOARD      |
|-----------------------------|
|       INCOMING ORDERS       |
|                             |
| Order #102                  |
| Chicken Sandwich x1         |
|       [Start Preparing]     |
|                             |
| Order #103                  |
| Pasta x2                    |
|       [Mark Ready]          |
|                             |
|       [SCAN PICKUP QR]      |
+-----------------------------+
```

## 7. Data model

The application will use the following main entities:

```yaml
User:
  id, name, email, role, createdAt

MenuItem:
  id, name, description, price,
  imageUrl, category, isAvailable

Order:
  id, userId, status, totalPrice,
  estimatedWaitMinutes, createdAt, pickupToken

OrderItem:
  id, orderId, menuItemId,
  quantity, unitPrice

PickupVerification:
  id, orderId, staffId, verifiedAt

MealPreference:
  userId, preferredCategories,
  excludedIngredients
```

**Relationships:**

- One customer can place multiple orders.
- Each order belongs to one customer.
- One order can contain multiple order items.
- Each order item references one menu item.
- A staff member can verify multiple pickups.
- Each customer can have saved meal preferences.

## 8. Data sources

The application will use local persistence, a REST web service, and Firebase for different responsibilities.

**Local persistence – shared_preferences:**

- Store temporary cart contents so that customers do not lose their selections when they close the application.
- Cache recently retrieved menu information for faster access.
- Store non-sensitive application preferences.

**REST web service – Custom FastAPI backend:**

- Retrieve menu items, prices, and availability.
- Submit and process customer orders.
- Calculate estimated waiting times using active orders and estimated preparation durations.
- Validate QR-code pickup tokens.
- Provide a protected endpoint for AI meal recommendations.

**Firebase:**

- **Firebase Authentication:** Handle customer and staff registration and login.
- **Cloud Firestore:** Store user profiles and synchronize order-status updates in real time.

The REST backend will handle menu and order operations, while Firebase will provide authentication and real-time order-status synchronization. Both services will be integrated into the Flutter application.

## 9. Device feature and AI feature

### Device feature: Camera-based QR-code scanning

The application will use the device camera to scan the QR code displayed on the customer's order confirmation screen. Café staff will scan the code to verify the order and confirm that the correct order is being collected.

- Related user story: Story 6.
- Required permission: Camera access.
- Implementation: A Flutter QR/barcode scanning package.
- Security: The backend will validate pickup tokens and prevent an order from being collected more than once.

### AI feature: Personalized meal recommendations

The application will use the Google Gemini API to generate meal recommendations based on customer-selected food preferences and available menu items. For example, customers can select preferred food categories, a budget range, or ingredients they wish to exclude.

- Related user story: Story 7.
- Data sent: Available menu item names, descriptions, prices, and customer-selected preferences.
- Recipient: Google Gemini API, accessed through our backend.
- Privacy: Passwords, authentication tokens, and unnecessary personal information will not be sent to the AI service.
- Fallback: If the AI service is unavailable, customers can still browse menus and place orders normally.

## 10. Risks

| Risk | Likelihood | Plan |
|---|---|---|
| REST API or internet connectivity problems | Medium | Implement error handling and local menu caching. |
| Gemini API limits or service unavailability | Medium | Keep AI recommendations optional and maintain normal menu browsing. |
| Firebase configuration or integration difficulties | Medium | Configure and test Firebase authentication and Firestore early. |
| Camera permission or QR-scanning problems | Medium | Test on physical devices early and handle denied permissions. |
| Unequal workload or examination conflicts | Medium | Divide initial responsibilities, use GitHub issues, and maintain regular progress updates. |

## 11. Milestone plan

### Milestone 1 – Week 6: Interface and navigation prototype

- Implement all nine screens and their navigation.
- Develop customer, staff, and manager interface flows.
- Use in-memory sample data to demonstrate menus, carts, orders, and dashboards.
- Implement basic form validation and application state management.
- Demonstrate all eight user stories through the appropriate screens, including prototype interfaces for optional features.

### Milestone 2 – Week 10: Real data and core functionality

- Integrate Firebase Authentication and Cloud Firestore.
- Develop and connect the FastAPI REST backend.
- Implement local persistence using shared_preferences.
- Enable real menu retrieval, order submission, and menu availability updates.
- Implement order management and estimated waiting-time calculations.
- Enable real-time order-status synchronization.
- Complete the functionality of all must user stories.

### Final submission – Week 14: Complete application

- Implement camera-based QR-code pickup verification.
- Integrate AI-powered meal recommendations using Gemini API.
- Complete menu management and remaining should user stories.
- Perform integration, usability, and automated testing.
- Fix identified bugs and improve application reliability.
- Prepare technical documentation and the final project demonstration.

## 12. AI-use plan

The group intends to use AI tools responsibly during development:

- **Learning:** Use ChatGPT to understand Flutter, Dart, REST APIs, Firebase, and unfamiliar programming concepts.
- **Boilerplate generation:** Use AI assistance to generate initial code structures and repetitive components, which will be reviewed and understood by group members.
- **Code review:** Use AI tools to identify possible bugs, improve readability, and suggest security improvements.
- **Testing:** Use AI assistance to suggest test cases for authentication, order processing, queue calculations, and QR-code verification.
- **Documentation:** Use AI assistance to improve technical documentation and clarify explanations.

All AI-generated code will be reviewed, tested, and understood by the group before integration. The group will follow the course AI-use policy and will not submit unverified AI-generated work as its own.
