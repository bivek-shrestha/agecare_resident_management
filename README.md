# AgeCare Resident Management System — Flutter Frontend v1.5

AgeCare is a cross-platform Flutter frontend for aged-care staff. The project follows the supplied AgeCare prototype structure while improving responsiveness, visual consistency, navigation, and the complex admission workflow required by the assessment rubric.


## Latest UI update (v1.5)

Notifications, Alerts, Residents and Messages now share a consistent rounded-card system with white surfaces, soft shadows and slim left-side status/unread indicators. Login and Menu wording has been reduced for a cleaner interface. Resident profiles now include a subtle **Discharge** action that removes a resident from active care and clears their linked open tasks and alerts after confirmation.


## Latest visual and usability update (v1.2)

The Home screen no longer contains the large Care dashboard banner. Resident cards now use clear status-based colour accents, and Notifications use visible colour-coded type labels for high/review/info alerts and urgent/care/routine tasks. Colour is always paired with text and icons for accessibility.

## Demo login

The app now starts on a staff login screen.

- **Email:** `staff@agecare.com.au`
- **Password:** `agecare123`

Authentication is intentionally simulated because this assessment is a frontend implementation. The form still includes validation, password visibility, remember-me UI and a password-reset information flow.

## Major implemented features

### 1. Resident management

- Dashboard resident search now works: type a name, room or resident ID and press the arrow/search action or keyboard Search.
- The search opens the Residents page with the query already applied.
- Residents page has been simplified as requested: the Total Residents / New Admission / High Priority / Discharge statistic boxes were removed from this page.
- Search supports resident name, room, ID, doctor and care level.
- Filters: All, Priority, New and Discharge.
- Resident cards open full profiles.
- Profiles include Overview, Medication and Care Plan tabs.
- Empty medication state is handled for newly admitted residents.
- Alerts and task details can link directly to the related resident profile.

### 2. New resident admission — complex four-step workflow

- Personal Information
- Care Information
- Emergency Contact
- Final Review
- Required-field validation and date picker
- The common dashboard/profile header was removed from the admission pages for a cleaner focused process.
- Final Review now has a separate **Edit** action for Personal, Care, and Contact sections.
- Edit takes the user directly back to the selected page.
- **Save changes & review** validates the edited page and returns to Final Review.
- The progress steps can also be used to return to completed sections.
- Saving creates a new in-memory resident and immediately shows the new resident in the Residents page.
- Success dialog displays resident ID, room and care level.

### 3. Login and logout flow

- Dedicated responsive AgeCare staff login page.
- Form validation and show/hide password.
- Logout confirmation in Menu.
- Confirming Logout returns to the login page.

### 4. Dashboard, care tasks and alerts

- Responsive care dashboard.
- Working resident search.
- Resident overview statistics.
- Care task cards and complete/reopen workflow.
- Task details include resident, due time, staff member, instructions and priority.
- Task detail can open the related resident profile.
- Alerts include High / Medium / Low severity styling.
- Alert items open the related resident profile.
- Notifications open their related task or resident information.
- Emergency guidance and shift-partner alert interactions.

### 5. Team messaging

- Searchable staff conversations.
- Unread indicators.
- Nepali and multicultural staff data.
- Working chat screen with message sending.

### 6. Menu and staff options

- Staff profile card.
- Schedule, Notifications, Privacy, Security and Help.
- Working settings switches.
- Logout returns to staff login.

## Additional realistic data

The project now contains **12 resident profiles**, including Nepali resident names such as:

- Laxmi Shrestha
- Ram Bahadur Gurung
- Maya Karki
- Krishna Prasad Adhikari
- Sita Rana
- Gopal Thapa
- Pabitra Rai

It also contains additional care tasks, alerts and staff conversations, including Nepali staff names.

## Responsive design improvements

- Mobile uses the five-item bottom navigation: Home, Residents, Add, Messages and Menu.
- Wider tablet/desktop layouts automatically use a NavigationRail.
- Main content has sensible maximum widths so cards and forms do not stretch excessively on large screens.
- Resident results use a responsive multi-column layout on wider screens.
- Login changes from a single-column mobile layout to a two-column desktop/tablet layout.
- Narrow layouts stack action buttons when required.

## Project structure

```text
lib/
  main.dart
  app.dart
  data/
    mock_data.dart
  models/
    resident.dart
    care_task.dart
    alert_item.dart
    message.dart
  state/
    app_state.dart
  theme/
    app_theme.dart
  widgets/
    app_shell.dart
    app_header.dart
    resident_card.dart
    section_header.dart
    stat_card.dart
    status_chip.dart
  screens/
    login_screen.dart
    dashboard_screen.dart
    residents_screen.dart
    resident_detail_screen.dart
    admission_screen.dart
    messages_screen.dart
    chat_screen.dart
    alerts_screen.dart
    tasks_screen.dart
    task_detail_screen.dart
    notifications_screen.dart
    menu_screen.dart
```

## Run the project

Open the extracted `agecare_resident_management` folder in VS Code or Android Studio.

If Android/iOS/Web host folders are not already generated for your local Flutter SDK, run:

```bash
flutter create . --platforms=android,ios,web
flutter pub get
flutter run
```

On Windows, you can also double-click:

```text
bootstrap_windows.bat
```

then run:

```bash
flutter run
```

## Recommended assessment demonstration

1. Start on Login and sign in with the demo credentials.
2. On Dashboard, search `Laxmi` and press the search arrow. Show that the Residents page opens filtered to Laxmi Shrestha.
3. Clear the search, choose Priority and open a resident profile.
4. Open Medication and Care Plan.
5. Open Add and enter a new admission through all four steps.
6. On Final Review, press Edit under Care Information, change a value, then press **Save changes & review**.
7. Save the resident and show the new profile in Residents.
8. Open a task, open its related resident, return and mark the task complete.
9. Open an alert and show that it opens the related resident profile.
10. Open Messages, search a staff member and send a message.
11. Open Menu, demonstrate settings and press Logout to return to Login.

## Assessment scope note

This project is a complete **frontend prototype using in-memory mock data**. It does not claim to provide a production authentication service, clinical database, emergency calling API or production privacy/security backend. Those integrations belong to a backend/production implementation rather than this frontend assessment.


## v1.3 interface refinement
The interface has been simplified for assessment usability: the Residents page no longer has a duplicate Add button, status and alert cards use white surfaces with focused colour indicators, and the dashboard no longer includes the Emergency services or Shift partner quick-action cards. This reduces visual clutter while retaining all major resident management, admission, task, alert, messaging, search and authentication functionality.

## v1.4 visual refinement
The Residents screen has been simplified for faster use during care workflows. It uses shorter search/filter wording and compact resident cards showing only the information needed for quick identification. Resident cards use 26 px rounded corners inspired by modern iOS card design, with a soft translucent left status rail while keeping the card itself white. The Alerts screen is also more concise, showing the alert title, resident, time and severity/type only. Global input, card and button corner radii were gently increased to keep the interface consistent and polished without adding decorative clutter.
