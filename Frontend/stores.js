import { writable, get } from 'svelte/store';
import { getProjects, getCalls, connectWebSocket } from './api';

function createProjectsStore() {
  const { subscribe, set, update } = writable({
    data: [],
    loading: true,
    error: null,
  });

  async function fetchProjects() {
    update(store => ({ ...store, loading: true, error: null }));
    try {
      const projects = await getProjects();
      set({ data: projects, loading: false, error: null });
    } catch (error) {
      set({ data: [], loading: false, error: 'Failed to fetch projects.' });
    }
  }

  return {
    subscribe,
    fetchProjects,
    update,
    set,
  };
}

export const projects = createProjectsStore();

function createCallsStore() {
  const { subscribe, set, update } = writable({
    data: [],
    loading: true,
    error: null,
  });

  async function fetchCalls(projectId) {
    update(store => ({ ...store, loading: true, error: null }));
    try {
      const calls = await getCalls(projectId);
      set({ data: calls, loading: false, error: null });
      if (calls.length > 0) {
        selectedCall.set(calls[0]);
      }
    } catch (error) {
      set({ data: [], loading: false, error: 'Failed to fetch calls.' });
    }
  }

  function prependCall(call) {
    update(store => {
      return {
        ...store,
        data: [call, ...store.data],
      };
    });
  }

  return {
    subscribe,
    fetchCalls,
    prependCall,
  };
}

export const calls = createCallsStore();

export function initializeRealtime() {
  connectWebSocket(newCall => {
    calls.prependCall(newCall);
  });
}

function createSelectedProjectStore() {
  const getProjectIdFromHash = () => {
    if (typeof window === 'undefined') return null;
    const hash = window.location.hash.substring(1);
    if (hash.startsWith('project=')) {
      return hash.substring('project='.length);
    }
    return null;
  };

  const store = writable(null);
  let initialProjectId = getProjectIdFromHash();

  projects.subscribe(p => {
    if (p.data.length > 0 && initialProjectId) {
      const projectFromHash = p.data.find(proj => proj.id === initialProjectId);
      if (projectFromHash) {
        store.set(projectFromHash);
        initialProjectId = null; // Clear after setting
      }
    }
  });

  store.subscribe(value => {
    if (typeof window !== 'undefined') {
      if (value) {
        const currentHash = `#project=${value.id}`;
        if (window.location.hash !== currentHash) {
          window.history.pushState(null, '', currentHash);
        }
      } else {
        if (window.location.hash) {
          window.history.pushState(null, '', window.location.pathname + window.location.search);
        }
      }
    }
  });

  if (typeof window !== 'undefined') {
    window.addEventListener('hashchange', () => {
      const projectId = getProjectIdFromHash();
      const currentProjects = get(projects).data;
      if (projectId) {
        const projectFromHash = currentProjects.find(p => p.id === projectId);
        if (projectFromHash) {
          store.set(projectFromHash);
        }
      } else {
        store.set(null);
      }
    });
  }

  return store;
}


const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

export const selectedProject = createSelectedProjectStore();
export const selectedCall = writable(null);
export const theme = writable(prefersDark ? 'dark' : 'light');