# Pioneer Scheduling App
Timesheets app to help employee manage hours worked/week and tasks completed/day and send PDF to employer.

#### Testflight link:
https://testflight.apple.com/join/qrb95hKU

## Overview

iOS application functionality:
- Create/Login user (email or Apple Sign-In)
- Create/delete/update timesheets
- Create/delete/update workdays
- For each workday: pick date, start/end times; enter multiple task descriptions.
- Automatically compute per‑day and total hours
- Generate a clean PDF containing timesheet title, date(s), list of workdays with tasks and durations, and Total Time.
- Share PDF summary.
- On‑device data persistence so timesheets/workdays persist between launches.
- Light/dark mode; reasonable accessibility defaults; friendly error messages.

### App screenshots
| Login View | List View | Timesheet View |
| ---------- | --------- | -------------- |

|<img width="230" height="460" alt="loginView" src="https://github.com/user-attachments/assets/d5b7eb57-fa7b-45f7-859a-879d70b23c36" /> | <img width="225" height="460" alt="listView" src="https://github.com/user-attachments/assets/0c8fdcba-f06b-4c5b-9cdf-53c5cd4c59b7" /> | <img width="220" height="457" alt="timesheetView" src="https://github.com/user-attachments/assets/2541ac37-7f67-4210-a3c2-aeb93e62247d" /> |



### Example generated PDF
[timesheet.pdf](https://github.com/user-attachments/files/22016932/timesheet.pdf)

### Tech stack
- Language: Swift
- UI: SwiftUI
- Architectural pattern: MVVM
- Dependency manager: Swift Package Manager (SPM)
- Other Key Libraries: Supabase, AuthenticationServices, Swift Concurrency
- Dev Tools: Xcode, Git, GitHub
- Target platform: iPhone (iOS 17+)
