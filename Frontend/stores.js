import { writable } from 'svelte/store';

export const projects = writable([
  { name: 'All Projects', active: true },
  { name: 'My Awesome Project', color: 'indigo' },
  { name: 'E-commerce Platform', color: 'emerald' },
  { name: 'Legacy API', color: 'rose' },
]);

const initialEvents = [
  {
    status: 200,
    name: 'user.created',
    id: 'evt_1J9Xqj2eZvKYlo2ChBqjBvjq',
    path: 'POST /webhooks/users',
    time: '2m ago',
    project: 'My Awesome Project',
    projectColor: 'indigo',
    active: true,
  },
  {
    status: 500,
    name: 'invoice.payment_failed',
    id: 'evt_2K9Xqj2eZvKYlo2ChBqjBvkq',
    path: 'POST /webhooks/invoices',
    time: '22m ago',
    project: 'E-commerce Platform',
    projectColor: 'emerald',
  },
  {
    status: 200,
    name: 'api.key.created',
    id: 'evt_3L9Xqj2eZvKYlo2ChBqjBvlq',
    path: 'POST /webhooks/apikeys',
    time: '1h ago',
    project: 'Legacy API',
    projectColor: 'rose',
  },
];

export const events = writable(initialEvents);

const activeEvent = initialEvents.find(e => e.active === true);

const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

export const selectedProject = writable('All Projects');
export const selectedEvent = writable(activeEvent || null);
export const theme = writable(prefersDark ? 'dark' : 'light');

