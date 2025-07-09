import { writable } from 'svelte/store';

export const projects = writable([
  { name: 'All Projects', active: true },
  { name: 'My Awesome Project', color: 'indigo' },
  { name: 'E-commerce Platform', color: 'emerald' },
  { name: 'Legacy API', color: 'rose' },
]);

export const events = writable([
  {
    status: 200,
    name: 'user.created',
    path: 'POST /webhooks/users',
    time: '2m ago',
    project: 'My Awesome Project',
    projectColor: 'indigo',
    active: true,
  },
  {
    status: 500,
    name: 'invoice.payment_failed',
    path: 'POST /webhooks/invoices',
    time: '22m ago',
    project: 'E-commerce Platform',
    projectColor: 'emerald',
  },
  {
    status: 200,
    name: 'api.key.created',
    path: 'POST /webhooks/apikeys',
    time: '1h ago',
    project: 'Legacy API',
    projectColor: 'rose',
  },
]);

export const selectedProject = writable('All Projects');
export const selectedEvent = writable(null);
export const theme = writable('dark');

