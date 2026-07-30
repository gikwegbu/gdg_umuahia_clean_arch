# Flutter Banking App - Feature Development Specification

This document outlines the design requirements and modular implementation prompts for the GDG Umuahia Clean Architecture mobile banking application.

---

## Completed Implementations ✅

### 1. Splash Screen Routing Checks
- Checks secure storage session tokens.
- Checks Hive cache for onboarding flags.
- Redirects to onboarding walkthrough, login screen, or home dashboard.
- Includes a debugging toggle boolean flag to force show/hide onboarding.

### 2. Swipeable Onboarding Screen
- 3 page PageView layout with sliding indicator.
- Skip button hidden on the final page.
- Semantic labels and flexible layouts preventing text scale overflows.

### 3. Authentication Interface
- Form fields for username/email and passwords.
- Visibility togglers for passwords.
- Rate-limiting security lockout restricting logins for 30s after 5 consecutive failures.

### 4. Forgot Password Screen
- Single email input verifying syntax.
- Mock delays simulating network calls.
- Persistent success confirmation cards replacing transient alerts.

### 5. Signup Registration Screen
- Form fields for First Name, Last Name, Email, Username, Password, and Confirm Password.
- Regex validations matching secure password criteria (uppercase, lowercase, alphanumeric, min 6 characters).
- Live validation status disabling the submit button until all rules are met.

---

## Remaining Open Source Tasks ☑️

### 6. Home Page Greetings & Notifications
- Dynamic greetings based on system clock (Good Morning / Good Afternoon / Good Evening).
- Notification bell navigation.
- Notification screen displaying transfer and withdrawal updates with empty state.

### 7. Balance Cards Horizontal Carousel
- Horizontally slidable balance summaries showing:
  - Personal Balance
  - Total Spent this month
  - Limit left to spend

### 8. Apex Card Banner & Transaction Shortcuts
- Custom Card container detailing bank name, account number, and account name.
- Balance display with eye-revealer toggle.
- Add money (Deposit) and Withdrawal chip buttons.

### 9. Recent Activity Log
- Activity summary list displaying the 5 most recent transactions with leading icons and amounts.
- "See all" text button navigating to transaction history logs.

### 10. Horizontal Investment Carousel
- Horizontally slidable boxes showcasing investment types (VC Startups, Real Estate, Farm Investments, Humanoid Robots).
- Quick redirects to investment portfolios.

### 11. Interactive Withdrawal Flow
- Withdrawal bottom sheet with centered transparent currency input (`₦` prefix).
- Reactive validation warning in red if the input amount exceeds available balances.
- Post-submit congrats screen with confetti, transaction IDs, share receipt image feature, and redirect links.

### 12. Add Money Flow
- Deposit bottom sheet supporting up to a max of ₦5,000,000.
- Redirects to success receipt states.

### 13. Profile Page Dashboard
- Circle initials avatar card.
- Compact configuration settings list tiles (Terms, Privacy, FAQs, Help).
- Installed app version number and logout buttons.

### 14. Edit Profile Form
- Reusable form layout loaded dynamically inside a sliding bottom sheet.
