# Frontend Implementation Plan

This document outlines the plan for implementing the frontend of the Webhook Inspector application using Svelte and Tailwind CSS, based on the provided `mockup.html`.

## 1. Project Overview

The goal is to create a user interface for inspecting webhook events. The UI will consist of a sidebar with a list of projects and a list of recent webhook events. The main content area will display the details of a selected event.

## 2. Technology Stack

- **Framework:** Svelte
- **Styling:** Tailwind CSS
- **Build Tool:** Vite

## 3. Component Breakdown

Based on the `mockup.html`, the application will be broken down into the following Svelte components:

-   **`App.svelte`**: The main application component that will orchestrate the other components.
-   **`Sidebar.svelte`**: The main sidebar container.
    -   **`ProjectsList.svelte`**: Displays the list of projects.
        -   **`ProjectItem.svelte`**: A single project item in the list.
    -   **`EventsList.svelte`**: Displays the list of recent webhook events.
        -   **`EventItem.svelte`**: A single event item in the list.
-   **`MainContent.svelte`**: The main content area.
    -   **`EventDetail.svelte`**: Displays the details of a selected webhook event.
        -   **`RequestDetails.svelte`**: Shows the request information (headers, payload).
        -   **`ResponseDetails.svelte`**: Shows the response information.
-   **`ThemeToggle.svelte`**: A component to toggle between light and dark modes.

## 4. Data Flow and State Management

-   **Projects Data**: A store will be created to hold the list of projects. `ProjectsList.svelte` will consume this store.
-   **Events Data**: A store will be created to hold the list of webhook events. `EventsList.svelte` will consume this store.
-   **Selected Project**: A store will hold the currently selected project. This will be used to filter the events shown in `EventsList.svelte`.
-   **Selected Event**: A store will hold the currently selected event. `EventDetail.svelte` will use this to display the event details.
-   **Theme**: A store will manage the current theme (light/dark).

## 5. Implementation Steps

1.  **Setup Svelte Environment**:
    -   Ensure Vite and the Svelte plugin are correctly configured.
    -   Clean up the existing `Public` directory and set up the main Svelte entry point.

2.  **Create Component Scaffolding**:
    -   Create empty files for all the components listed in the "Component Breakdown" section within a new `Frontend/Components` directory.

3.  **Implement Sidebar**:
    -   Develop the `Sidebar.svelte` component.
    -   Create the `ProjectsList.svelte` and `ProjectItem.svelte` components.
    -   Use dummy data to populate the projects list.
    -   Implement the selection logic for projects.

4.  **Implement Events List**:
    -   Create the `EventsList.svelte` and `EventItem.svelte` components.
    -   Use dummy data to populate the events list.
    -   Filter the events list based on the selected project.

5.  **Implement Main Content Area**:
    -   Develop the `MainContent.svelte` and `EventDetail.svelte` components.
    -   Display the details of the selected event.
    -   Create the `RequestDetails.svelte` and `ResponseDetails.svelte` tabs/sections.

6.  **Implement Theme Toggle**:
    -   Create the `ThemeToggle.svelte` component.
    -   Implement the logic to switch between light and dark themes by adding/removing the `dark` class on the `body` element.

7.  **Integrate with Backend (Future)**:
    -   Replace dummy data with API calls to the backend to fetch projects and events.
    -   Implement real-time updates for new events (e.g., using WebSockets).

## 6. Directory Structure

The frontend source code will be primarily located in the `Frontend/` directory and compiled to the `Public/assets` directory.

```
/
���── Frontend/
│   ├── Components/
│   │   ├── Sidebar/
│   │   │   ├── ProjectsList.svelte
│   │   │   ├── ProjectItem.svelte
│   │   │   ├── EventsList.svelte
│   │   │   └── EventItem.svelte
│   │   ├── MainContent/
│   │   │   ├── EventDetail.svelte
│   │   │   ├── RequestDetails.svelte
│   │   │   └── ResponseDetails.svelte
│   │   └── ThemeToggle.svelte
│   ├── stores.js       # Svelte stores for state management
│   ├── App.svelte      # Main application component
│   └── main.js         # Main entry point
└── Public/
    └── assets/         # Compiled assets
```

This plan provides a clear path forward for developing the frontend of the Webhook Inspector application.
