# Exchange

A currency exchange rate calculator built with UIKit for learning purposes.

## Features

- Convert USDc to other currencies and vice versa
- Two input fields with real-time bidirectional conversion
- Currency picker via bottom sheet
- Swap currencies with one tap
- Offline fallback with cached/mock rates
- Loading and error states

## Tech Stack

- UIKit (programmatic UI, no storyboards)
- MVVM architecture
- Swift 5
- async/await for networking
- URLSession-based network layer

## Architecture

App/                → AppDelegate, SceneDelegate (entry point)
Features/
├── Exchange/       → Main screen (ViewController, ViewModel, ViewState, CardView)
└── CurrencyPicker/ → Bottom sheet (ViewController, Cell)
Models/             → Currency, ExchangeRate
Services/           → NetworkClient, ExchangeService, TickerResponse
Helpers/            → CurrencyFormatter
Extensions/         → UIFont, UITextField, UIViewController helpers



### Data Flow

User Input → ViewController → ViewModel → updates state → ViewController updates UI
↓
ExchangeService (API / cache / mock)



### Key Decisions

- **Closure-based binding** over Combine/delegates — simpler for this scope, easy to understand
- **ActiveField tracking** to prevent recursive UI updates when both fields can trigger conversion
- **Three-level fallback** (API → cache → mock) so the app never shows an empty screen
- **CurrencyCardView with isSelectable** — one reusable component for both cards, swap just toggles the flag
- **Programmatic UI** — no storyboards, full control over layout

## Trade-offs

- No Combine/RxSwift — would scale better for complex reactive flows
- No Coordinator pattern — navigation is simple enough to live in ViewController
- No persistent cache — rates reset on app restart
- Currency list is hardcoded — API for available currencies is unavailable
- EURc rate is mocked — not returned by the API

## What Could Be Improved

- Add Combine for reactive bindings
- Implement persistent caching (UserDefaults or CoreData)
- Add pull-to-refresh for rate updates
- Add rate update timestamp
- Localize currency formatting based on user locale
- Add UI tests
- Add Coordinator for navigation
- Support dark mode

## API

Exchange rates: `GET https://api.dolarapp.dev/v1/tickers?currencies=MXN,ARS`

Currency list API (`/v1/tickers-currencies`) is currently unavailable — handled with hardcoded fallback.

## Edge Cases Handled

- Empty input — shows empty fields
- Zero input — treated as empty
- Non-numeric input — parsed as 0, fields stay empty
- Large numbers — input limited to 15 characters
- Network failure — falls back to cached or mock rates
- Missing currency rate (EURc) — supplemented from mock data

## Requirements

- iOS 15.6+
- Xcode 15+

## Getting Started

1. Clone the repository
2. Open `Exhange.xcodeproj` in Xcode
3. Build and run (⌘R)
4. Run tests (⌘U)
