// Frontend/api.js

const BASE_URL = '/api';

export async function getProjects() {
  try {
    const response = await fetch(`${BASE_URL}/projects`);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.error("Failed to fetch projects:", error);
    throw error;
  }
}

export async function createProject(project) {
  try {
    const response = await fetch(`${BASE_URL}/projects`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(project),
    });
    if (response.status !== 201 && !response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.error("Failed to create project:", error);
    throw error;
  }
}

export async function updateProject(project) {
  try {
    const response = await fetch(`${BASE_URL}/projects/${project.id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(project),
    });
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.error(`Failed to update project ${project.id}:`, error);
    throw error;
  }
}

export async function deleteProject(projectId) {
  try {
    const response = await fetch(`${BASE_URL}/projects/${projectId}`, {
      method: 'DELETE',
    });
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
  } catch (error) {
    console.error(`Failed to delete project ${projectId}:`, error);
    throw error;
  }
}

export async function getCalls(projectId = null) {
  try {
    const url = projectId ? `${BASE_URL}/calls?projectId=${projectId}` : `${BASE_URL}/calls`;
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.error(`Failed to fetch calls for project ${projectId}:`, error);
    throw error;
  }
}

export async function getCallDetails(callId) {
    try {
        const response = await fetch(`${BASE_URL}/calls/${callId}`);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return await response.json();
    } catch (error) {
        console.error(`Failed to fetch call details for call ${callId}:`, error);
        throw error;
    }
}


let socket;

export function connectWebSocket(onMessage) {
  const wsProtocol = window.location.protocol === 'https' ? 'wss' : 'ws';
  const wsUrl = `${wsProtocol}://${window.location.host}/api/calls/ws`;

  socket = new WebSocket(wsUrl);

  socket.onopen = () => {
    console.log("WebSocket connection established");
  };

  socket.onmessage = (event) => {
    const newCall = JSON.parse(event.data);
    onMessage(newCall);
  };

  socket.onclose = () => {
    console.log("WebSocket connection closed");
  };

  socket.onerror = (error) => {
    console.error("WebSocket error:", error);
  };
}

export function disconnectWebSocket() {
  if (socket) {
    socket.close();
  }
}
