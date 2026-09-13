# AgeCare Resident Management System — Flutter 

AgeCare is a cross-platform Flutter frontend for aged-care staff. The project follows the supplied AgeCare prototype structure while improving responsiveness, visual consistency, navigation.

## Latest UI update 

Notifications, Alerts, Residents and Messages now share a consistent rounded-card system with white surfaces, soft shadows and slim left-side status/unread indicators. Login and Menu wording has been reduced for a cleaner interface. Resident profiles now include a subtle **Discharge** action that removes a resident from active care and clears their linked open tasks and alerts after confirmation.


## Latest visual and usability update 

Resident cards use clear status-based colour accents, and Notifications use visible colour-coded type labels for high/review/info alerts and urgent/care/routine tasks. Colour is always paired with text and icons for accessibility.

## Demo login

The app now starts on a staff login screen.

- **Email:** `20036498.bivek@agecarekoi.com.au`
- **Password:** `agecare123`

Authentication is intentionally simulated because this assessment is a frontend implementation. The form still includes validation, password visibility, remember-me UI and a password-reset information flow.

## Major implemented features

### 1. Resident management

- Dashboard resident search: type a name, room or resident ID and press the arrow/search action or keyboard Search.
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
- Working chat screen with message sending.

### 6. Menu and staff options

- Staff profile card.
- Schedule, Notifications, Privacy, Security and Help.
- Working settings switches.
- Logout returns to staff login.

It also contains additional care tasks, alerts and staff conversations, including Nepali staff names.

## Responsive design improvements

- Mobile uses the five-item bottom navigation: Home, Residents, Add, Messages and Menu.
- Wider tablet/desktop layouts automatically use a NavigationRail.
- Main content has sensible maximum widths so cards and forms do not stretch excessively on large screens.
- Resident results use a responsive multi-column layout on wider screens.
- Login changes from a single-column mobile layout to a two-column desktop/tablet layout.
- Narrow layouts stack action buttons when required.


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
