# Backend Integration Plan

This document outlines the plan for integrating the Svelte frontend with the backend API, replacing the current mock data with live data from backend services.

## 1. API Endpoint Definitions

The frontend will interact with the backend through the following RESTful API endpoints and a WebSocket connection:

*   **Projects:**
    *   `GET /api/projects`: Fetches a list of all available projects.
    *   **Example Response:**
        ```json
        [
          { "id": "proj_1", "name": "My Awesome Project", "color": "indigo" },
          { "id": "proj_2", "name": "E-commerce Platform", "color": "emerald" }
        ]
        ```

*   **Calls:**
    *   `GET /api/calls`: Fetches a list of all recent calls across all projects.
    *   `GET /api/calls?projectId={id}`: Fetches calls for a specific project.
    *   `GET /api/calls/{id}`: Fetches detailed information for a single call, including request/response headers and bodies.
    *   **Example List Response:**
        ```json
        [
          {
            "id": "call_1",
            "method": "POST",
            "path": "/webhooks/users",
            "time": "2025-07-08T12:34:56Z",
            "projectId": "proj_1",
          }
        ]
        ```

*   **Real-time Updates:**
    *   `ws://<host>/api/calls/ws`: A WebSocket endpoint that will push new calls to connected clients in real-time.

## 2. API Client Service

To centralize and simplify backend communication, a dedicated API client service will be created.

*   **File:** `Frontend/api.js`
*   **Responsibilities:**
    *   Export async functions for each API call (e.g., `getProjects()`, `getCalls(projectId)`).
    *   Use the native `fetch` API for all HTTP requests.
    *   Handle JSON parsing, error handling, and potential request/response transformations.
    *   Manage the WebSocket connection lifecycle (connect, disconnect, handle messages).

## 3. Svelte Store Modifications

The Svelte stores in `Frontend/stores.js` will be refactored to manage asynchronous data fetching from the new API service.

*   **Data Stores (`projects`, `calls`):**
    *   The stores will hold not just the data, but also the current state of the data (e.g., `loading`, `error`).
    *   Initial state will be an empty array.
*   **Fetching Functions:**
    *   Async functions like `fetchProjects()` and `fetchCalls(projectId)` will be created within the stores file. These functions will call the `api.js` service, update the store's data, and manage the `loading` and `error` states.
*   **Real-time Integration:**
    *   A function will be exposed to initialize the WebSocket connection via the `api.js` service.
    *   A callback will be passed to the service to handle incoming WebSocket messages, which will prepend new calls to the `calls` store.

## 4. Component Updates

The Svelte components will be updated to reflect the asynchronous nature of the data.

*   **Loading States:**
    *   `ProjectsList.svelte` and `EventsList.svelte` will display loading indicators (e.g., spinners or skeleton loaders) while data is being fetched.
*   **Error Handling:**
    *   If an API call fails, the components will display a user-friendly error message.
*   **Data Fetching Triggers:**
    *   Data fetching will be triggered in the `onMount` lifecycle hook of the relevant components.
    *   `EventsList.svelte` will re-fetch data whenever the `selectedProject` store changes.
*   **`EventDetail.svelte`:**
    *   When an event is selected from the list, this component will trigger a fetch for the full call details (`GET /api/calls/{id}`) if they haven't been fetched already.

## 5. Implementation Steps

1.  **Create `Frontend/api.js`:** Implement the API client with functions for fetching projects and calls, and for managing the WebSocket connection.
2.  **Refactor `stores.js`:**
    *   Update the `projects` and `calls` stores to include `loading` and `error` states.
    *   Implement the `fetchProjects` and `fetchCalls` functions that use the new API service.
    *   Add logic to handle WebSocket messages for real-time updates.
3.  **Update `ProjectsList.svelte`:**
    *   Call `fetchProjects` on component mount.
    *   Add UI elements for loading and error states.
4.  **Update `EventsList.svelte`:**
    *   Call `fetchCalls` on mount and whenever the selected project changes.
    *   Add UI elements for loading and error states.
5.  **Update `App.svelte`:**
    *   Initialize the WebSocket connection when the application starts.
6.  **Implement `RequestDetails.svelte` and `ResponseDetails.svelte`:**
    *   Create these components to display the detailed request and response information fetched for a selected call.

This plan provides a clear roadmap for transitioning the frontend from static mock data to a fully integrated, data-driven application.