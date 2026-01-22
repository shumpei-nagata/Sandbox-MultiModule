---
name: list-ios-simulators
description: List available iOS simulators. Use when the user wants to check available simulators, find simulators by name or OS version, or get simulator device information.
context: fork
---

# List iOS Simulators

List available iOS simulators using `xcrun simctl`.

## Workflow

1. Execute `xcrun simctl list devices available` to get the list of available simulators
2. If the user specifies filter conditions (simulator name, OS version, etc.), filter the results accordingly
3. Return the filtered results or all results if no conditions are specified

## Filter Conditions

Common filter conditions:

- **Simulator name**: e.g., "iPhone 15", "iPad Pro"
- **OS version**: e.g., "iOS 17", "iOS 18.2"
- **Device type**: e.g., "iPhone", "iPad", "Apple Watch", "Apple TV"

## Example Usage

### List all simulators

```bash
xcrun simctl list devices available
```

### Filter by name (grep)

```bash
xcrun simctl list devices available | grep -i "iPhone 15"
```

### Filter by OS version

```bash
xcrun simctl list devices available | grep -A 100 "iOS 18"
```

## Output Format

Present results in a clear, readable format. Include:

- Device name
- UDID (if relevant)
- OS version (from section header)
